defmodule PhMicroblog.ErrorMessage do
  import Kernel, except: [inspect: 1]

  def inspect({field, :required}) do
    "#{field} is required"
  end

  def inspect({field, :format}) do
    "invalid format for #{field}."
  end

  def inspect({field, {:too_short, min}}) do
    "#{field} must be longer than or equal to #{min}."
  end

  def inspect({_field, message}) when is_binary(message) do
    message
  end

  def inspect(error) do
    Kernel.inspect error
  end
end
