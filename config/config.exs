import Config

config :nostrum,
  gateway_intents: [
    :guilds,
    :guild_messages,
    :guild_presences,
    :guild_members,
    :message_content
  ]

config :nosedrum,
  prefix: "e"

import_config "config.secret.exs"
