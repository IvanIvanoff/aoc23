defmodule Aoc23.MixProject do
  use Mix.Project

  def project do
    [
      app: :aoc23,
      version: "0.1.0",
      elixir: "~> 1.16-rc",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:explorer, "~> 0.7.0"},
      {:nx, "~> 0.5"},
      {:libgraph, "~> 0.16"}
    ]
  end
end
