# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :organization,
  ecto_repos: [Organization.Repo]

# Configures the endpoint
config :organization, OrganizationWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    formats: [json: OrganizationWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Organization.PubSub,
  live_view: [signing_salt: "ScQOytcm"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :organization, Organization.Mailer, adapter: Swoosh.Adapters.Local

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :phoenix, :format_encoders,
  "json-api": Jason

config :mime, :types, %{
  "application/vnd.api+json" => ["json-api"]
}

config :ja_serializer,
  key_format: :underscored,
  # This ensures that singleton_resources surface their json:api
  # resource type as plural
  pluralize_types: true

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
