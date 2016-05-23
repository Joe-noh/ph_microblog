defmodule PhMicroblog.LayoutView do
  use PhMicroblog.Web, :view

  def full_title(nil) do
    "Sample App"
  end

  def full_title(title) do
    "#{title} | Sample App"
  end
end
