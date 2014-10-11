defmodule PhMicroblog.Util do
  def errors_to_strings(errors) do
    Enum.map(errors, fn {field, desc} -> "#{field} #{desc}" end)
  end
end
