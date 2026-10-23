# resvg_elixir

Maintained Elixir bindings for [resvg](https://github.com/linebender/resvg),
an SVG renderer written in Rust.

Maintained by [Cornelis Kettenis](https://github.com/Cees-Kettenis), this fork
tracks upstream resvg development and carries tested rendering fixes between
upstream releases. It builds on [mrdotb/resvg_nif](https://github.com/mrdotb/resvg_nif).
The original authors retain their attribution and MIT license.

The package and OTP application are `resvg_elixir`; the public module is
`ResvgElixir`. These names let it coexist with the original `resvg` package.

## Renderer baseline

The current renderer is based on the resvg/usvg 0.48.1 development line with
upstream changes after that release and additional rendering fixes. Both Rust
crates are pinned to commit
[`5464662c0ec59ecc830c52418673b322da1791b5`](https://github.com/Cees-Kettenis/resvg/commit/5464662c0ec59ecc830c52418673b322da1791b5).

Each release uses this exact snapshot.
See [the upstream guide](docs/upstream.md) for the carried fixes and update policy.

## Installation

Add the package to `mix.exs`:

```elixir
defp deps do
  [
    {:resvg_elixir, "~> 0.1.0"}
  ]
end
```

Released packages use checksum-verified native binaries from this repository's
GitHub releases. Supported binary targets cover Linux GNU and musl on x86-64
and ARM64, Linux 32-bit ARM and RISC-V, macOS on Intel and Apple Silicon, and Windows
on x86-64. The exact target and NIF ABI matrix lives in the
[release workflow](https://github.com/Cees-Kettenis/resvg_elixir/blob/master/.github/workflows/release.yml). A source build requires Rust
and the source-build dependency described below.

## Render SVG

```elixir
:ok = ResvgElixir.svg_to_png("input.svg", "output.png")

svg = ~s(<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24"><circle cx="12" cy="12" r="10" fill="blue"/></svg>)

{:ok, png} =
  ResvgElixir.svg_string_to_png_binary(svg, resources_dir: System.tmp_dir!())

File.write!("circle.png", png)
```

`svg_string_to_png_binary/2` returns a PNG binary. The older
`svg_string_to_png_buffer/2` API returns a list of bytes. File rendering,
font inspection and SVG node bounds remain available through `ResvgElixir`.
Pass `resources_dir` for SVG strings so relative image references have a base.

## Reuse fonts

```elixir
{:ok, fontdb} =
  ResvgElixir.init_fontdb(
    font_files: ["/path/to/DejaVuSans.ttf"],
    skip_system_fonts: true
  )

{:ok, png} =
  ResvgElixir.svg_string_to_png_binary(svg,
    resources_dir: System.tmp_dir!(),
    fontdb: fontdb
  )
```

A reusable font database avoids parsing the same fonts for each render. When
`fontdb` is supplied, the database already determines the font selection;
other font-loading options are ignored.

## Build from source

In an application that needs source builds, include Rustler explicitly:

```elixir
{:resvg_elixir, "~> 0.1.0"},
{:rustler, "~> 0.36.0", runtime: false}
```

Then compile with:

```sh
RESVG_ELIXIR_BUILD=1 mix deps.compile resvg_elixir --force
```

The same pinned resvg/usvg revision is used for source builds and release
binaries. The Rust fork is fetched by Cargo; it does not need a separate
crates.io publication.

## Documentation

- [Migrating from resvg](docs/migration.md)
- [Upstream renderer and carried fixes](docs/upstream.md)
- [Maintaining and publishing releases](docs/releases.md)
- [Contributing](CONTRIBUTING.md)
- [Livebook examples](https://github.com/Cees-Kettenis/resvg_elixir/blob/master/livebooks/example.livemd)
- [Changelog](CHANGELOG.md)

## License

The Elixir bindings are MIT licensed. See [LICENSE.md](LICENSE.md) for the
original and fork copyright notices. The underlying renderer and its dependencies
retain their own licenses, recorded in their source repositories.
