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
    embed = avatar_embed(msg.author)

    Api.create_message(
      msg.channel_id,
      embeds: [embed],
      message_reference: %{message_id: msg.id},
      allowed_mentions: :none
    )
  end

  @impl true
  def command(interaction) do
    embed = avatar_embed(interaction.user)
    [
      embeds: [embed],
      allowed_mentions: []
    ]
  end

  @spec avatar_embed(User) :: Embed
  defp avatar_embed(user) do
    # Semi-hacky workaround to get larger pfp size (not supported by nostrum as it is by discord.js)
    icon_url = User.avatar_url(user) <> "?size=4096"

    %Embed{}
      |> Embed.put_author(User.full_name(user), nil, icon_url)
      |> Embed.put_image(icon_url)
      |> Embed.put_color(0x6e4a7e)
      |> Embed.put_footer("Requested by #{User.full_name(user)}", nil)
  end

  @impl true
  def type, do: :slash
end
