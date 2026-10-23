package = System.fetch_env!("RESVG_ELIXIR_PACKAGE")

dependencies = [{:resvg_elixir, path: package}]

dependencies =
  if System.get_env("RESVG_ELIXIR_BUILD") in ["1", "true"] do
    dependencies ++ [{:rustler, "~> 0.36.0", runtime: false}]
  else
    dependencies
  end

Mix.install(dependencies)

fixtures = Path.join(__DIR__, "support")
fonts = [font_dirs: [Path.join(fixtures, "fonts")], skip_system_fonts: true]
svg = File.read!(Path.join(fixtures, "text-font-change.svg"))
options = [resources_dir: fixtures, dpi: 256] ++ fonts

{:ok, expected} = ResvgElixir.svg_string_to_png_binary(svg, options)
<<137, "PNG", 13, 10, 26, 10, _::binary>> = expected
{:ok, buffer} = ResvgElixir.svg_string_to_png_buffer(svg, options)
true = IO.iodata_to_binary(buffer) == expected

{:ok, fontdb} = ResvgElixir.init_fontdb(fonts)

{:ok, actual} =
  ResvgElixir.svg_string_to_png_binary(svg, resources_dir: fixtures, dpi: 256, fontdb: fontdb)

true = actual == expected

[%{__struct__: ResvgElixir.Native.Node, id: "Layer-1"}] =
  ResvgElixir.query_all(Path.join(fixtures, "rustacean.svg"))

{:error, _message} = ResvgElixir.svg_to_png(Path.join(fixtures, "missing.svg"), "unused.png")
true = is_list(Application.spec(:resvg_elixir, :modules))

IO.puts("PASS: packaged rendering, byte buffers, reusable fonts, native structs and errors")
