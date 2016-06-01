defmodule PhMicroblog.LayoutView do
  use PhMicroblog.Web, :view

  @base "Sample App"

  def full_title(nil),   do: @base
  def full_title(title), do: "#{title} | #{@base}"

  def logged_in?(conn) do
    !is_nil(conn.assigns[:current_user])
  end
end
