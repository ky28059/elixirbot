defmodule Elixirbot.Commands.Ping do
  @behaviour Nosedrum.Command

  alias Nostrum.Api

  @impl true
  def usage, do: "ping"

  @impl true
  def description, do: "Ping?"

  @impl true
  def predicates, do: []

  @impl true
  def command(msg, _args) do
    Api.create_message(msg.channel_id, "pong!")
  end
end
