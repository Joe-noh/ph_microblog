defmodule PhMicroblog.View do
  use Phoenix.View, root: "web/templates"

  # The quoted expression returned by this block is applied
  # to this module and all other views that use this module.
  using do
    quote do
      # Import common functionality
      import PhMicroblog.Router.Helpers

      # Use Phoenix.HTML to import all HTML functions (forms, tags, etc)
      use Phoenix.HTML
    end
  end

  def full_title(nil), do: "Sample App"
  def full_title(title), do: "Sample App | #{title}"
end
