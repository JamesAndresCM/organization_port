defmodule Organization.Directory do
  import Ecto.Query, warn: false
  alias Organization.Repo
  alias Organization.Accounts
  alias Organization.Directory

  def get_all_companies_by_customer(customer) do
    from(c in Directory.Company, where: c.customer_id == ^customer.id and is_nil(c.deleted_at))
  end
  

  def get_customer(customer_id) do
    Accounts.Customer |> Repo.get(customer_id)
  end

  def current_user(user_id) do
    Accounts.User |> Repo.get(user_id) |> Repo.preload(:customer)
  end

  def with_persons(query \\ Company) do
    from(c in query,
      left_join: p in assoc(c, :persons),
      where: is_nil(p.deleted_at),
      group_by: c.id
    )
  end

  def count_persons(query) do
    query
    |> with_persons()
    |> select([c, p], {c.id, count(p.id)})
    |> Repo.all()
    |> Enum.into(%{})
  end

  def get_all_countries do
    Directory.Country
  end
end
