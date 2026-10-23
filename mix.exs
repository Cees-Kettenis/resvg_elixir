defmodule ResvgElixir.MixProject do
  use Mix.Project

  @source_url "https://github.com/Cees-Kettenis/resvg_elixir"
  @version "0.1.0"

  def project do
    [
      aliases: aliases(),
      app: :resvg_elixir,
      deps: deps(),
      docs: docs(),
      elixir: "~> 1.14",
      elixirc_paths: elixirc_paths(Mix.env()),
      name: "resvg_elixir",
      package: package(),
      start_permanent: Mix.env() == :prod,
      version: @version
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:rustler_precompiled, "~> 0.8.1"},
      {:rustler, "~> 0.36.0", optional: true},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:approval, only: :test, github: "mrdotb/approval"}
    ]
  end

  defp package do
    [
      description:
        "Maintained Elixir bindings for resvg, tracking upstream development with tested rendering fixes.",
      maintainers: ["Cornelis Kettenis"],
      licenses: ["MIT"],
      files: ~w(
        lib native/resvg_elixir/src native/resvg_elixir/Cargo.toml
        native/resvg_elixir/Cargo.lock native/resvg_elixir/Cross.toml
        native/resvg_elixir/.cargo .formatter.exs README.md LICENSE.md
        CHANGELOG.md CONTRIBUTING.md CODE_OF_CONDUCT.md docs mix.exs
        checksum-Elixir.ResvgElixir.Native.exs
      )s,
      links: %{"GitHub" => @source_url}
    ]
  end

  def docs do
    [
      main: "readme",
      extras: [
        "CHANGELOG.md": [],
        "CONTRIBUTING.md": [title: "Contributing"],
        "CODE_OF_CONDUCT.md": [title: "Code of Conduct"],
        "LICENSE.md": [title: "License"],
        "README.md": [title: "Overview"],
        "docs/migration.md": [title: "Migrating from resvg"],
        "docs/upstream.md": [title: "Upstream renderer and carried fixes"],
        "docs/releases.md": [title: "Maintaining and publishing releases"]
      ],
      source_url: @source_url,
      source_ref: "resvg_elixir-v#{@version}",
      homepage_url: @source_url,
      formatters: ["html"]
    ]
  end

  defp aliases do
    [
      "format.all": [
        "format",
        "cmd cargo fmt --manifest-path native/resvg_elixir/Cargo.toml"
      ],
      "format.check": [
        "format --check-formatted",
        "cmd cargo fmt --manifest-path native/resvg_elixir/Cargo.toml -- --check"
      ]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test"]
  defp elixirc_paths(_), do: ["lib"]
end
