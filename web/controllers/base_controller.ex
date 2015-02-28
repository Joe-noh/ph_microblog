defmodule PhMicroblog.BaseController do

  defmacro __using__(_) do
    quote do
      use Phoenix.Controller

      def not_found(conn) do
        conn |> put_view(PhMicroblog.ErrorView) |> render("404.html")
      end
    end
  end
end
