defmodule PhMicroblog.CorrectUser do
  import Plug.Conn
  import Phoenix.Controller
  import PhMicroblog.Router.Helpers

  alias PhMicroblog.Json.ErrorView

  def init(opts) do
    [
      accessor: Dict.get(opts, :accessor),
      mode:     Dict.get(opts, :mode)
    ]
  end

  def call(conn, opts) do
    current_user = conn.assigns.current_user
    resource_owner = get_resource_owner(conn, opts[:accessor])

    if resource_owner && current_user.id == resource_owner.id do
      conn
    else
      conn |> refuse(opts[:mode]) |> halt
    end
  end

  defp get_resource_owner(conn, accessor) do
    do_get_resource_owner(conn, accessor, conn.assigns)
  end

  defp do_get_resource_owner(_conn, _, nil), do: nil

  defp do_get_resource_owner(_conn, [], resource_owner), do: resource_owner

  defp do_get_resource_owner(conn, [key | accessor], assigns) do
    do_get_resource_owner(conn, accessor, Map.get(assigns, key))
  end

  defp refuse(conn, :json) do
    conn
    |> put_status(401)
    |> render(ErrorView, "401.json")
  end

  defp refuse(conn, _) do
    conn |> redirect(to: static_page_path(conn, :home))
  end
end
