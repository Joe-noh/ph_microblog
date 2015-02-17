defmodule PhMicroblog.Mixfile do
  use Mix.Project

  def project do
    [app: :ph_microblog,
     version: "0.0.1",
     elixir: "~> 1.0",
     elixirc_paths: ["lib", "web"],
     compilers: [:phoenix] ++ Mix.compilers,
     deps: deps]
  end

  def application do
    [mod: {PhMicroblog, []},
     applications: apps]
  end

  defp apps do
    [:phoenix, :cowboy, :postgrex, :ecto, :comeonin, :logger]
  end

  defp deps do
    [
      {:phoenix, "~> 0.9"},
      {:cowboy, "~> 1.0"},
      {:postgrex, "~> 0.7"},
      {:ecto, "~> 0.8"},
      {:comeonin, "~> 0.2"}
    ]
  end
end
