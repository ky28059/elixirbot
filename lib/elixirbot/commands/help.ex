defmodule Elixirbot.Commands.Help do
  @behaviour Nosedrum.Command
  @behaviour Nosedrum.ApplicationCommand

  alias Nostrum.Api
  alias Nostrum.Struct.{Embed, User}
  alias Nosedrum.Storage.ETS, as: CommandStorage

  @impl true
  def usage, do: ["help"]

  @impl true
  def description, do: "Returns a list of commands."

  @impl true
  def predicates, do: []

  @impl true
  def command(msg, _args) do
    Api.create_message(
      msg.channel_id,
      embeds: [help_embed(msg.author)],
      message_reference: %{message_id: msg.id},
      allowed_mentions: :none
    )
  end

  @impl true
  def command(interaction) do
    [embeds: [help_embed(interaction.user)]]
  end

  @spec help_embed(User.t()) :: Embed.t()
  defp help_embed(user) do
    commands = CommandStorage.all_commands()
      |> Map.keys()
      |> Enum.join(", ")

    %Embed{
      title: "Commands",
      description: commands,
      color: 0x6e4a7e,
      footer: %{
        text: "Requested by #{User.full_name(user)}"
      }
    }
  end

  @impl true
  def type, do: :slash
end
