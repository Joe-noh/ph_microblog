defmodule PhMicroblog.Plug.CurrentUser do
  import Plug.Conn

  alias PhMicroblog.{User, Repo}

  def session_key, do: :current_user_id

  def init(_), do: :ok

  def call(conn, _) do
    with {:ok, id} <- user_id_from_session(conn),
         {:ok, user} <- fetch_user(conn, id) do
      conn |> assign(:current_user, user)
    end
  end

  defp user_id_from_session(conn) do
    case get_session(conn, session_key) do
      nil -> conn
      id  -> {:ok, id}
    end
  end

  defp fetch_user(conn, id) do
    case Repo.get(User, id) do
      nil  -> conn
      user -> {:ok, user}
    end
  end
end
