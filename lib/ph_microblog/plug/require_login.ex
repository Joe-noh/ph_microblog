defmodule PhMicroblog.RequireLogin do
  import Plug.Conn
  import Phoenix.Controller
  import PhMicroblog.Router.Helpers

  def init(opts) do
    opts |> Dict.get(:mode)
  end

  def call(conn, mode) do
    case conn.assigns[:current_user] do
      nil -> conn |> refuse(mode) |> halt
      _   -> conn
    end
  end

  defp refuse(conn, :json) do
    conn
    |> put_status(401)
    |> render(PhMicroblog.Json.ErrorView, "401.json")
  end

  defp refuse(conn, _) do
    conn
    |> store_location
    |> put_flash(:error, "Please log in.")
    |> redirect(to: session_path(conn, :new))
  end

  def forwarding_path(conn) do
    get_session(conn, :forwarding_path)
  end

  def delete_forwarding_path(conn) do
    delete_session(conn, :forwarding_path)
  end

  defp store_location(conn) do
    if conn.method == "GET" do
      conn |> put_session(:forwarding_path, conn.request_path)
    else
      conn
    end
  end
end
