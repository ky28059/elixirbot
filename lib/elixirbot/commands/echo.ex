defmodule Elixirbot.Commands.Echo do
  @behaviour Nosedrum.ApplicationCommand

  @impl true
  def description(), do: "Echos a message."

  @impl true
  def command(interaction) do
    [%{name: "message", value: message}] = interaction.data.options
    [
      content: message,
      ephemeral?: true
    ]
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
