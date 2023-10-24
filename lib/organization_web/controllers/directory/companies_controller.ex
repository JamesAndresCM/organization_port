defmodule OrganizationWeb.Directory.CompaniesController do
  use OrganizationWeb, :controller
  alias Organization.Services.PaginatorService
  alias Organization.Queries.CompanyQuery
  plug :put_view, OrganizationWeb.CompanyView
  plug :put_view, OrganizationWeb.CompanyCreateView
  alias Organization.Services.Company.Create
  alias Organization.Directory

  # overriding action/2
  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.current_user]
    apply(__MODULE__, action_name(conn), args)
  end

  def index(conn, params, current_user) do
    companies = Directory.get_all_companies_by_customer(current_user.customer)
    total_persons = Directory.count_persons(companies)
    paginator = CompanyQuery.apply_filter(companies, params) |> PaginatorService.new(params)
    meta_data = %{
      page_number: paginator.page_number,
      per_page: paginator.per_page,
      total_pages: paginator.total_pages,
      total_elements: paginator.total_elements
    }
    conn
    |> put_view(OrganizationWeb.CompanyView)
    |> render("index.json-api", data: paginator.entries, total_persons: total_persons, opts: [meta: meta_data])
  end

  def create(conn, params, current_user) do
    case Create.new(params, current_user) |> Create.save do
      {:ok, company} ->
        company = Directory.Company.get_company_with_preloads(company.id)
        conn
        |> put_status(:created)
        |> render("show.json-api", data: company, view: CompanyCreateView)
      {:error, errors} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: errors})
    end
  end

  def show(conn, %{"id" => company_id}, _current_user) do
    case Directory.Company.get_company_with_preloads(company_id|> String.to_integer) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Company not found"})
  
      company ->
        conn
        |> render("show.json-api", data: company)
    end
  end
end
