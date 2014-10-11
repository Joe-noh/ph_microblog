"""
defmodule PhMicroblog.Repo do
  use Ecto.Repo, adapter: Ecto.Adapters.Postgres, env: Mix.env

  def conf(env) do
    parse_url url(env)
  end

  def url(:dev) do
    "ecto://postgres:password@localhost/ph_microblog_dev"
  end

  def url(:test) do
    "ecto://postgres:password@localhost/ph_microblog_test?size=1"
  end

  def url(:prod) do
    "ecto://postgres:password@localhost/ph_microblog"
  end

  def priv do
    app_dir(:ph_microblog, "priv/repo")
  end
end
"""
