# Upstream renderer and carried fixes

Cornelis Kettenis maintains `resvg_elixir` as an Elixir binding that follows
upstream resvg development and ships tested rendering corrections between
upstream tagged releases. It derives from
[mrdotb/resvg_nif](https://github.com/mrdotb/resvg_nif) and uses the renderer from
[Linebender/resvg](https://github.com/linebender/resvg).

## Current snapshot

Both `resvg` and `usvg` are pinned in `native/resvg_elixir/Cargo.toml` and
`Cargo.lock` to
[`5464662c0ec59ecc830c52418673b322da1791b5`](https://github.com/Cees-Kettenis/resvg/commit/5464662c0ec59ecc830c52418673b322da1791b5)
in [Cees-Kettenis/resvg](https://github.com/Cees-Kettenis/resvg).

The crates identify as 0.48.1, with subsequent upstream development included
through `054ccf39743179eee7d3a32e5b8bcf59941081da` and the following carried changes:

| Area | Included correction |
| --- | --- |
| Text paths | More accurate inverse arc-length positioning |
| Patterns | Fractional-size spacing and seams; selectable renderer sampling filter |
| Color | linearRGB gradients and luminance masks in 8-bit rendering |
| Markers | Automatic orientation corrections |
| Small images | Preserve strokes on tiny rasters |
| Rectangle fills | More accurate coverage for axis-aligned rectangles |

The baseline also includes upstream filter-transform, marker viewport and
shared paint-server fixes. This guide describes what is in the pinned snapshot;
a pull request being merged later does not change an already published binary.
The native wrapper does not expose every Rust renderer option as an Elixir option.

## Maintenance policy

1. Review upstream releases and relevant development commits.
2. Reconcile carried patches, removing duplicate patches when upstream includes them.
3. Pin resvg and usvg to the same immutable commit and refresh `Cargo.lock`.
4. Run binding tests and relevant renderer image regressions. Review changed
   output before accepting new reference images.
5. Record the engine revision and behavior changes in the changelog.
6. Build new binaries and verify the package using the release guide.

Continue contributing generally useful fixes upstream. The fork is independent
of the original Elixir package and does not claim to be the official upstream
Elixir binding or to track upstream's moving head automatically.

## Versioning

The Elixir package has its own versions, starting at `0.1.0`. These do not imply
that the underlying Rust crates have the same version. Record both the package
version and renderer commit when reporting a rendering issue.
