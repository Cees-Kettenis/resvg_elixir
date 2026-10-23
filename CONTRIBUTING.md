# Contributing to resvg_elixir

Report binding issues and propose changes in
[Cees-Kettenis/resvg_elixir](https://github.com/Cees-Kettenis/resvg_elixir).
The project is maintained by Cornelis Kettenis. Please follow the
[Code of Conduct](CODE_OF_CONDUCT.md).

## Development setup

Install Git, Elixir/Erlang and a current stable Rust toolchain. The package
supports Elixir 1.14 or newer; its approval-test dependency requires Elixir
1.16 or newer for development. `.tool-versions` records the current development runtime.
The pinned renderer's Rust dependencies may require a newer compiler than
resvg's own minimum supported Rust version.

```sh
git clone https://github.com/Cees-Kettenis/resvg_elixir.git
cd resvg_elixir
mix deps.get
RESVG_ELIXIR_BUILD=1 mix compile --warnings-as-errors
RESVG_ELIXIR_BUILD=1 mix test
```

Building this checkout from source is necessary before the first branded
release has published binaries and checksums. The rename deliberately does not
reuse the original fork's `Resvg.Native` binaries.

## Checks

```sh
mix format.check
cargo check --locked --manifest-path native/resvg_elixir/Cargo.toml
cargo test --locked --manifest-path native/resvg_elixir/Cargo.toml
RESVG_ELIXIR_BUILD=1 mix test
RESVG_ELIXIR_BUILD=1 mix docs --warnings-as-errors
```

`mix format.all` formats Elixir and Rust source. Rust commands need Cargo on
`PATH`; a Rustup-managed stable toolchain can be selected with
`RUSTUP_TOOLCHAIN=stable`.

Rendering tests retain their checked-in reference images. Investigate a changed
image before updating its reference. The existing approval helper writes
working output images during tests; review `git diff` after running the suite.

Keep generated output and investigations under ignored `tmp/`. Package files
explicitly include native source and build configuration, and exclude Cargo
build output.

## Updating the renderer

Follow [the upstream update policy](docs/upstream.md). Keep resvg and usvg
pinned to the same reviewed Rust revision. Rebuild native binaries whenever
native source, crate identity or the renderer pin changes.

## Release preparation

Follow [the release guide](docs/releases.md) for native builds, checksums,
package validation and Hex publication. A normal source commit does not
publish a Hex package.
