defmodule Elixirbot.Commands.Avatar do
  @behaviour Nosedrum.Command
  @behaviour Nosedrum.ApplicationCommand

  alias Nostrum.Struct.{Embed, User}
  alias Nosedrum.Converters
  alias Elixirbot.Util.Messages

  @impl true
  def usage, do: ["avatar @[user]?"]

  @impl true
  def aliases, do: ["pfp"]

  @impl true
  def description, do: "Gets your discord avatar."

  @impl true
  def predicates, do: []

  @impl true
  def command(msg, []) do
    Messages.reply_embed(msg, avatar_embed(msg.author))
  end

  @impl true
  def command(msg, [target]) do
    case Converters.to_member(target, msg.guild_id) do
      # Lookup successful
      {:ok, member} ->
        Messages.reply_embed(msg, avatar_embed(msg.author, member.user))

      # Error found
      {:error, _error} ->
        Messages.failed_to_parse_user(msg, target)
    end
  end

  @impl true
  def command(msg, args) do
    Messages.argument_arity_mismatch(msg, "avatar", "0-1", length args)
  end

  @impl true
  def command(interaction) do
    embed = case interaction.data.options do
      [%{name: "user", value: id}] ->
        {:ok, target} = Nostrum.Cache.UserCache.ETS.get(id)
        avatar_embed(interaction.user, target)
      nil -> avatar_embed(interaction.user)
    end
    [
      embeds: [embed],
      allowed_mentions: []
    ]
  end

  @spec avatar_embed(User.t(), User.t()) :: Embed.t()
  defp avatar_embed(user, target) do
    # Semi-hacky workaround to get larger pfp size (not supported by nostrum as it is by discord.js)
    icon_url = User.avatar_url(target) <> "?size=4096"

    %Embed{
      author: %{
        name: User.full_name(target),
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

  @spec avatar_embed(User.t()) :: Embed.t()
  defp avatar_embed(user), do: avatar_embed(user, user)

  @impl true
  def type, do: :slash

  @impl true
  def options() do
    [
      %{
        type: :user,
        name: "user",
        description: "The user to get the avatar of.",
        required: false
      }
    ]
  end
end
