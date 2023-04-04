defmodule Elixirbot.MixProject do
  use Mix.Project

  def project do
    [
      app: :elixirbot,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {Elixirbot.Application, []}
    ]
  end

  defp deps do
    [
      {:nostrum, "~> 0.6"}
    ]
  end
end
