defmodule Elixirbot.Commands.Ping do
  @behaviour Nosedrum.Command
  @behaviour Nosedrum.ApplicationCommand

  alias Nostrum.Api

  @impl true
  def usage, do: ["ping"]

  @impl true
  def description, do: "Ping pong!"

  @impl true
  def predicates, do: []

  @impl true
  def command(msg, _args) do
    Api.create_message(msg.channel_id, "pong!")
  end

  @impl true
  def command(_interaction) do
    [content: "pong!"]
  end

  @impl true
  def type, do: :slash
end
