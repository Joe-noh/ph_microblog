defmodule PhMicroblog.UserView do
  use PhMicroblog.View

  def gravatar_url(email) do
    "https://secure.gravatar.com/avatar/#{md5_digest(email)}"
  end

  defp md5_digest(string) do
    string |> do_md5_digest |> List.flatten |> Enum.join
  end

  defp do_md5_digest(string) do
    for <<c <- :erlang.md5(string)>> do
      c |> Integer.to_string(16) |> String.rjust(2, ?0)
    end
  end
end
