defmodule PhMicroblog.Pager do
  alias PhMicroblog.Repo

  def paginate(queryable, opts) do
    size = opts[:page_size] || 30
    page = opts[:page_number] || 1

    queryable |> Repo.paginate(page_size: size, page: page)
  end
end
