defmodule PhMicroblog.RequireLogin do
  import Plug.Conn
  import Phoenix.Controller, only: [put_flash: 3, redirect: 2]
  import PhMicroblog.Router.Helpers, only: [session_path: 2, static_page_path: 2]

  def init(_), do: :ok

  def call(conn, _) do
    case conn.assigns[:current_user] do
      nil -> conn |> go_login_page
      _   -> conn
    end
  end

  def forwarding_path(conn) do
    get_session(conn, :forwarding_path)
  end

  def delete_forwarding_path(conn) do
    delete_session(conn, :forwarding_path)
  end

  defp go_login_page(conn) do
    conn
    |> store_location
    |> put_flash(:error, "Please log in.")
    |> redirect(to: session_path(conn, :new))
    |> halt
  end

  defp store_location(conn) do
    if conn.method == "GET" do
      conn |> put_session(:forwarding_path, conn.request_path)
    else
      conn
    end
  end
end
