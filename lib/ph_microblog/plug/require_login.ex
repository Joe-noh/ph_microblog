defmodule PhMicroblog.RequireLogin do
  import Plug.Conn
  import Phoenix.Controller, only: [put_flash: 3, redirect: 2]
  import PhMicroblog.Router.Helpers, only: [session_path: 2]

  def init(_), do: :ok

  def call(conn, _) do
    case conn.assigns[:current_user] do
      nil -> conn |> go_login_page
      _   -> conn
    end
  end

  defp go_login_page(conn) do
    conn
    |> put_flash(:error, "Please log in.")
    |> redirect(to: session_path(conn, :new))
    |> halt
  end
end
