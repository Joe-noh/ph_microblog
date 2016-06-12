defmodule PhMicroblog.Plug.CurrentUser do
  import Plug.Conn

  alias PhMicroblog.{User, Repo, Jwt}

  def session_key, do: :current_user_id

  def init(opts) do
    opts |> Dict.get(:mode)
  end

  def call(conn, mode) do
    with {:ok, id}   <- fetch_user_id(conn, mode),
         {:ok, user} <- fetch_user(id) do
      conn |> assign(:current_user, user)
    else
      _ -> conn
    end
  end

  defp fetch_user_id(conn, :json) do
    with ["Bearer " <> token | _] <- get_req_header(conn, "authorization"),
         {:ok, claims} <- Jwt.decode(token) do
      {:ok, claims["user_id"]}
    else
      _ -> nil
    end
  end

  defp fetch_user_id(conn, _) do
    case get_session(conn, session_key) do
      nil -> nil
      id  -> {:ok, id}
    end
  end

  defp fetch_user(id) do
    case Repo.get(User, id) do
      nil  -> nil
      user -> {:ok, user}
    end
  end
end
