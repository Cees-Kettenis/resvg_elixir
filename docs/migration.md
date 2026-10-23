# Migrating from resvg

`resvg_elixir` is a maintained fork with its own application and module
namespace. Rendering functions and options retain the existing wrapper API
under the new namespace.

## Dependency and modules

Replace the dependency after the first Hex release is published:

```elixir
{:resvg_elixir, "~> 0.1.0"}
```

Update calls and explicit struct references:

| Original | Maintained fork |
| --- | --- |
| `Resvg` | `ResvgElixir` |
| `Resvg.Options` | `ResvgElixir.Options` |
| `Resvg.Native.Node` | `ResvgElixir.Native.Node` |
| OTP application `:resvg` | OTP application `:resvg_elixir` |
| `RESVG_BUILD=1` | `RESVG_ELIXIR_BUILD=1` |

An application can use `alias ResvgElixir, as: Resvg` to keep its existing
call sites while changing the dependency. The package itself does not define
compatibility modules in the `Resvg` namespace, so both packages can coexist.

Recreate reusable font databases with `ResvgElixir.init_fontdb/1`. A font database
is a native resource owned by its NIF; do not pass handles created by the old
package into the renamed one.

## Native binaries

The native crate and library are named `resvg_elixir`, and register with
"Elixir.ResvgElixir.Native". Old binaries named `libresvg` register with the old
module and cannot be relabeled as new binaries. Release assets must be rebuilt.

The new checksum manifest is `checksum-Elixir.ResvgElixir.Native.exs`. Download
it from the matching branded release, or generate it using the release guide.
Keep manifests and native artifacts from the same package version together.

## Rendering differences

The original wrapper's 0.6.0 baseline used resvg/usvg 0.47. This fork pins a
reviewed snapshot of the 0.48.1 development line plus additional fixes.
Text shaping, filtering and geometry can therefore produce different pixels.
Run application rendering comparisons when migrating; the namespace change
does not promise identical pixels across different renderer revisions.
