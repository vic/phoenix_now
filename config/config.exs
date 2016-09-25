# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :now,
  ecto_repos: [Now.Repo]

# Configures the endpoint
config :now, Now.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "/aPVSRU22jylhODl6JwbWKvZb1aRBFzCQ2loAsK6Xji89huoI6F0tYctIx198pPO",
  render_errors: [view: Now.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Now.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
