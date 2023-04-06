defmodule Elixirbot.Commands.Kick do
  @behaviour Nosedrum.Command
  @behaviour Nosedrum.ApplicationCommand

  alias Nostrum.Api
  alias Nostrum.Struct.{Embed, Guild, User}
  alias Nostrum.Cache.Me
  alias Nosedrum.Predicates
  alias Elixirbot.Util.Messages
  alias Elixirbot.Util.Parser

  @impl true
  def usage, do: ["kick @[target]"]

  @impl true
  def description(), do: "Kicks the target user from the server."

  @impl true
  def predicates, do: [&Predicates.guild_only/1, Predicates.has_permission(:kick_members)]

  @impl true
  def command(msg, [target | rest]) do
    {:ok, target_id} = Parser.to_user_id(target)  # TODO: error message

    case Parser.get_member(msg.guild_id, target_id) do
      {:ok, _member} ->
        Messages.reply_embed(msg, kick_embed(msg.guild_id, msg.author.id, target_id, Enum.join(rest)))
      {:error, _reason} ->
        Messages.failed_to_parse_user(msg, target)
    end
  end

  @impl true
  def command(msg, args) do
    Messages.argument_arity_mismatch(msg, "kick", "1+", length args)
  end

  @impl true
  def command(interaction) do
    [%{name: "user", value: target_id} | rest] = interaction.data.options

    case rest do
      [%{name: "reason", value: reason}] -> [embeds: [kick_embed(interaction.guild_id, target_id, reason)]]
      [] -> [embeds: [kick_embed(interaction.guild_id, interaction.user.id, target_id)]]
    end
  end

  @spec kick_embed(Guild.id(), User.id(), User.id(), String.t() | nil) :: Embed.t()
  defp kick_embed(guild_id, user_id, target_id, reason \\ nil) do
    {:ok, bot_member} = Parser.get_member(guild_id, Me.get().id)
    {:ok, target_member} = Parser.get_member(guild_id, target_id)  # TODO: error message

    cond do
      # If the user is attempting to kick themselves
      user_id == target_id ->
        %Embed{
          title: "[ERR] Unable to kick requested user",
          description: "You cannot kick yourself!",
          color: 0x6e4a7e
        }

      # If the bot is not hierarchially above the kick target
      not Parser.is_above?(guild_id, bot_member, target_member) ->
        %Embed{
          title: "[ERR] Unable to kick requested user",
          description: "Elixirbot is too low in the role hierarchy to kick #{target_member}.",
          color: 0x6e4a7e
        }

      # Success!
      true ->
        Api.remove_guild_member(guild_id, target_id, reason)
        %Embed{
          description: "Kicked <@#{target_id}> from the server.",
          color: 0x6e4a7e
        }
    end
  end

  @impl true
  def type(), do: :slash

  @impl true
  def options() do
    [
      %{
        type: :user,
        name: "user",
        description: "The user to kick.",
        required: true
      },
      %{
        type: :string,
        name: "reason",
        description: "The reason the user was kicked.",
        required: false
      }
    ]
  end
end
