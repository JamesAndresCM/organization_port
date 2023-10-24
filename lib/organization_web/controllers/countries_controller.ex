defmodule OrganizationWeb.CountriesController do
  use OrganizationWeb, :controller
  alias Organization.Services.PaginatorService
  plug :put_view, OrganizationWeb.CountryView

  def index(conn, params) do
    countries = Organization.Directory.get_all_countries
    paginator = countries |> PaginatorService.new(params)
    IO.inspect countries
    meta_data = %{
      page_number: paginator.page_number,
      per_page: paginator.per_page,
      total_pages: paginator.total_pages,
      total_elements: paginator.total_elements
    }
    conn
    |> put_view(OrganizationWeb.CountryView)
    |> render("index.json-api", data: paginator.entries, opts: [meta: meta_data])
  end
end