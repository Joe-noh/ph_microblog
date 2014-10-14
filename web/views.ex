defmodule PhMicroblog.Views do

  defmacro __using__(_options) do
    quote do
      use Phoenix.View
      import unquote(__MODULE__)

      # This block is expanded within all views for aliases, imports, etc
      import PhMicroblog.I18n
      import PhMicroblog.Router.Helpers
      alias Phoenix.Controller.Flash
    end
  end

  # Functions defined here are available to all other views/templates
  def title(nil),  do: "PH Microblog"
  def title(name), do: "#{name} | PH Microblog"

  def logged_in?(conn) do
    case Plug.Conn.get_session(conn, :email) do
      ""  -> false
      nil -> false
      _   -> true
    end
  end
end
