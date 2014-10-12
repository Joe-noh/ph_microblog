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

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [mod: {PhMicroblog, []},
     applications: apps(Mix.env)]
  end

  defp apps do
    [:phoenix, :cowboy, :postgrex, :ecto, :bcrypt, :logger]
  end

  defp apps(:test), do: [:hound | apps]
  defp apps(_env),  do: apps

  # Specifies your project dependencies
  #
  # Type `mix help deps` for examples and options
  defp deps do
    [
      {:phoenix, github: "phoenixframework/phoenix"},
      {:cowboy, "~> 1.0"},
      {:postgrex, ">= 0.6.0"},
      {:ecto, "~> 0.2.2"},

      {:bcrypt, github: "opscode/erlang-bcrypt", tag: "0.5.0.3"},
      {:hound, "0.5.8"},
      {:ibrowse, github: "cmullaparthi/ibrowse"},
      {:amrita, github: "josephwilk/amrita"}
    ]
  end
end
