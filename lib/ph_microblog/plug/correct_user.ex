defmodule PhMicroblog.CorrectUser do
  import Plug.Conn
  import Phoenix.Controller, only: [redirect: 2]
  import PhMicroblog.Router.Helpers, only: [static_page_path: 2]

  def init(accessor: accessor), do: accessor

  def call(conn, accessor) when is_list(accessor) do
    current_user = conn.assigns.current_user
    resource_owner = Enum.reduce(accessor, conn.assigns, &Map.get(&2, &1))

    if current_user.id == resource_owner.id do
      conn
    else
      conn |> go_home
    end
  end

  defp go_home(conn) do
    conn
    |> redirect(to: static_page_path(conn, :home))
    |> halt
  end
end
