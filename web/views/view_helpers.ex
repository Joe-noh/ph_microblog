defmodule PhMicroblog.ViewHelpers do
  @base "Sample App"

  def full_title(nil),   do: @base
  def full_title(title), do: "#{title} | #{@base}"

  def logged_in?(conn) do
    !is_nil(conn.assigns[:current_user])
  end

  def current_user?(conn, user) do
    logged_in?(conn) && conn.assigns.current_user.id == user.id
  end

  def gravatar_url(%{email: email}, size \\ 80) do
    "https://secure.gravatar.com/avatar/#{md5_digest(email)}?s=#{size}"
  end

  defp md5_digest(email) do
    email
    |> String.downcase
    |> :erlang.md5
    |> stringify_digest
  end

  defp stringify_digest(md5) do
    parts = for <<c <- md5>>, do: c |> Integer.to_string(16) |> String.rjust(2, ?0)
    parts |> List.flatten |> Enum.join |> String.downcase
  end
end
