# Organization

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).


# Endpoints
- Important! Number after organizations uri represent current user

- Get all companies `http://localhost:4000/api/v1/organizations/1/companies`
- Get detail about company `http://localhost:4000/api/v1/organizations/1/companies/121`
- Create new Company 
```
POST http://localhost:4000/api/v1/organizations/1/companies

PAYLOAD:
{
  "company": {
    "name": "Elixir",
    "domain": "elixir.com",
    "note": "Elixir note",
    "addresses": [
      { "country_id": 1, "name": "Address 1", "district": "District 1", "city": "City 1", "region": "Region 1", "postal_code": "12345" }
    ],
    "business_name": {
      "name": "Business Name",
      "identification": { "country_id": 2, "identification_type": "cuit", "identification_number": "123" }
    },
    "entity_positions": [
      { "person_id": 3, "position_type": "contact" },
      { "person_id": 4, "position_type": "legal_representative" },
      { "person_id": 5, "position_type": "legal_representative" }
    ]
  }
}

```

- Get all countries `http://localhost:4000/api/v1/organizations/1/countries`

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
