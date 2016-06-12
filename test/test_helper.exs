ExUnit.start

Mix.Task.run "ecto.create", ~w(-r PhMicroblog.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r PhMicroblog.Repo --quiet)
Ecto.Adapters.SQL.Sandbox.mode(PhMicroblog.Repo, :manual)

defmodule PhMicroblog.TestHelper do
  def has_title?(html, title) do
    html |> Floki.find("title") |> Floki.text == title
  end

  def inner_text(html, selector) do
    html |> Floki.find(selector) |> Floki.text
  end

  def count_element(html, selector) do
    html |> Floki.find(selector) |> Enum.count
  end
end
