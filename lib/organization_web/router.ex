defmodule OrganizationWeb.Router do
  use OrganizationWeb, :router

  pipeline :api do
    plug :accepts, ["json-api"]
    #plug JaSerializer.ContentTypeNegotiation
    plug JaSerializer.Deserializer
  end

  pipeline :set_current_user do
    plug Organization.Plugs.CurrentUser
  end

  scope "/api", OrganizationWeb do
    pipe_through [:api, :set_current_user]
    scope "/v1" do
      scope "/organizations" do
        scope "/:user_id", as: :user do
          resources "/companies", Directory.CompaniesController, only: [:create, :index, :show]
          resources "/positions", Directory.PositionsController, only: [:index, :create]
          resources "/countries", CountriesController, only: [:index]
        end
      end
    end
  end

  # Enable Swoosh mailbox preview in development
  if Application.compile_env(:organization, :dev_routes) do

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
