# Maintaining and publishing releases

One `resvg_elixir` release consists of a Hex package and platform-specific native
binaries hosted on this repository's GitHub release. A separate crates.io release
of the Rust renderer fork is not required.

The initial `0.1.0` identity is release preparation. The old `0.6.0-pdf.*`
releases belong to `Resvg.Native` and are not compatible binary artifacts for
"ResvgElixir.Native". Release tags use the `resvg_elixir-v` prefix to avoid
colliding with inherited upstream tags.

## Prepare the source

1. Update `@version` in `mix.exs`, the installation examples and changelog together.
2. Confirm that both renderer crates use the same reviewed commit and retain
   the matching `Cargo.lock`. Update `docs/upstream.md` when the pin changes.
3. Run the contributor checks, including the Rust source build, Elixir tests
   and documentation with warnings as errors.
4. Commit and push the release source. Tag that exact commit as `resvg_elixir-vVERSION` and
   push that tag when ready to create the GitHub release.

The package/OTP app is `resvg_elixir`. The Rust crate/library and native source
directory are also `resvg_elixir`. The NIF registers with
"Elixir.ResvgElixir.Native"; all three identities must agree with the build workflow.

## Build native assets

The release workflow runs for `resvg_elixir-v*` tags, or manually for build-only validation.
Its matrix builds the targets listed in "ResvgElixir.Native" for NIF ABI 2.15
and uploads each archive to the tagged GitHub release. NIF ABI 2.15 is compatible
with all supported OTP runtimes. The package job waits for every native build,
downloads all archives, generates the checksum manifest and builds the Hex
archive. It attaches that package and manifest to the same release. Fresh
consumers then test precompiled loading on Linux, macOS and Windows, including
the minimum supported Elixir version on Linux.

Hex publication remains a maintainer action.

Inspect the workflow results for every supported platform. Do not advertise
a binary target whose matching release artifact failed to build.

## Generate and verify checksums locally

After the native assets exist, the equivalent local preparation is:

```sh
mix deps.get
RESVG_ELIXIR_BUILD=1 mix rustler_precompiled.download ResvgElixir.Native --all
mix format checksum-Elixir.ResvgElixir.Native.exs
RESVG_ELIXIR_BUILD=1 mix hex.build --unpack
```

The source-build flag lets the checksum task compile the module before a new
version has a checksum manifest. The task still downloads and hashes all
release assets. Include `checksum-Elixir.ResvgElixir.Native.exs` in the Hex
package and commit it to the repository after verification.

Do not copy checksums from the old module or a different version. The manifest
is intentionally absent before the first branded native release has been built.

## Validate a fresh consumer

Unpack the generated Hex archive and compile it outside this checkout. Verify
normal precompiled loading without `RESVG_ELIXIR_BUILD`, and separately verify
source compilation with Rustler explicitly installed. Exercise a PNG render,
node bounds and a reusable font database in the renamed namespace.

Check that the archive contains its native Rust source, lockfile, Cargo
configuration, checksum manifest and documentation, without `target/`, test
outputs or build caches. Build documentation with warnings as errors.

## Publish to Hex

Authenticate as the package owner and publish only after the package and native
assets have been verified:

```sh
mix hex.publish --dry-run
mix hex.publish
```

The package is published as `resvg_elixir`. Keep native binaries, their checksums
and the package immutable after publication; ship a new version for a new renderer
pin or native change. GitHub repository renames redirect old links, but new
releases and documentation should use the canonical `resvg_elixir` URL.
