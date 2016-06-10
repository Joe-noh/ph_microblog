defmodule PhMicroblog.Pager do
  alias PhMicroblog.Repo

  def paginate(queryable, opts) do
    size = Dict.get(opts, :page_size) || 30
    page = Dict.get(opts, :page_number) || 1

    queryable |> Repo.paginate(page_size: size, page: page)
  end

  def prev_page_path(conn, page) do
    if first_page?(page), do: "#", else: page_path(conn, page.page_number-1)
  end

  def next_page_path(conn, page) do
    if last_page?(page), do: "#", else: page_path(conn, page.page_number+1)
  end

  defp page_path(conn, page_number) do
    query_string = conn.private
      |> Dict.get(:query_params, %{})
      |> Map.put("p", page_number)
      |> URI.encode_query

    "#{conn.request_path}?#{query_string}"
  end

  def first_page?(page) do
    page.page_number == 1
  end

  def last_page?(page) do
    page.page_number == page.total_pages
  end
end
