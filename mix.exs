defmodule PhMicroblog.Mixfile do
  use Mix.Project

  def project do
    [app: :ph_microblog,
     version: "0.0.1",
     elixir: "~> 1.0",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases,
     deps: deps]
  end

  def application do
    [
      mod: {PhMicroblog, []},
      applications: apps(Mix.env)
    ]
  end

  defp apps(:test) do
    apps() ++ [:ex_machina]
  end

  defp apps(_), do: apps()

  defp apps do
    [
      :phoenix, :phoenix_html, :cowboy, :logger, :gettext,
      :phoenix_pubsub, :phoenix_ecto, :postgrex, :comeonin,
      :scrivener, :scrivener_ecto, :joken
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  defp deps do
    [
      {:phoenix, "~> 1.2.0"},
      {:phoenix_pubsub, "~> 1.0.0"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_ecto, "~> 3.0"},
      {:phoenix_html, "~> 2.6"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:gettext, "~> 0.9"},
      {:cowboy, "~> 1.0"},

      {:comeonin, "~> 2.4"},
      {:scrivener_ecto, github: "drewolson/scrivener_ecto"},
      {:joken, "~> 1.2"},

      {:faker, "~> 0.7", only: :dev},

      {:floki, "~> 0.10", only: :test},
      {:ex_machina, "~> 1.0", only: :test},

      {:exrm, "~> 1.0"}
    ]
  end

  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"]
    ]
  end
end
