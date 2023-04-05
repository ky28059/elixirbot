defmodule Elixirbot.Commands.Avatar do
  @behaviour Nosedrum.Command
  @behaviour Nosedrum.ApplicationCommand

  alias Nostrum.Api
  alias Nostrum.Struct.{Embed, User}

  @impl true
  def usage, do: ["avatar"]

  @impl true
  def aliases, do: ["pfp"]

  @impl true
  def description, do: "Gets your discord avatar."

  @impl true
  def predicates, do: []

  @impl true
  def command(msg, _args) do
    Api.create_message(
      msg.channel_id,
      embeds: [avatar_embed(msg.author)],
      message_reference: %{message_id: msg.id},
      allowed_mentions: :none
    )
  end

  @impl true
  def command(interaction) do
    [
      embeds: [avatar_embed(interaction.user)],
      allowed_mentions: []
    ]
  end

  @spec avatar_embed(User.t()) :: Embed.t()
  defp avatar_embed(user) do
    # Semi-hacky workaround to get larger pfp size (not supported by nostrum as it is by discord.js)
    icon_url = User.avatar_url(user) <> "?size=4096"

    %Embed{
      author: %{
        name: User.full_name(user),
        icon_url: icon_url
      },
      image: %{
        url: icon_url
      },
      color: 0x6e4a7e,
      footer: %{
        text: "Requested by #{User.full_name(user)}"
      }
    }
  end

  @impl true
  def type, do: :slash
end
