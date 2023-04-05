defmodule Elixirbot.Commands.Echo do
  @behaviour Nosedrum.Command
  @behaviour Nosedrum.ApplicationCommand

  alias Nostrum.Api

  @impl true
  def usage, do: ["echo <message>"]

  @impl true
  def aliases, do: ["say"]

  @impl true
  def description(), do: "Echos a message."

  @impl true
  def predicates, do: []

  @impl true
  def parse_args(args), do: Enum.join(args, " ")

  @impl true
  def command(msg, text) do
    Api.create_message(
      msg.channel_id,
      content: text,
      message_reference: %{message_id: msg.id},
      allowed_mentions: :none
    )
  end

  @impl true
  def command(interaction) do
    [%{name: "message", value: message}] = interaction.data.options
    [content: message]
  end

  @impl true
  def type(), do: :slash

  @impl true
  def options() do
    [
      %{
        type: :string,
        name: "message",
        description: "The message for the bot to echo.",
        required: true
      }
    ]
  end
end
