defmodule Elixirbot.Util.Parser do
  alias Nostrum.Cache.GuildCache
  alias Nostrum.Struct.{Guild, User}

  @doc """
  Attempts to parse a string to a Discord user ID.
  """
  @spec to_user_id(String.t()) :: {:ok, pos_integer()} | {:error, String.t()}
  def to_user_id(str) do
    parsed = str
      |> String.trim_leading("<@")
      |> String.trim_leading("!")
      |> String.trim_trailing(">")

    case Integer.parse(parsed) do
      :error -> {:error, "Could not parse #{str} to a valid user id."}
      {i, _rem} -> {:ok, i}
    end
  end

  @doc """
  Gets a `Guild.Member` from the given guild and user id.
  """
  @spec get_member(Guild.id(), User.id()) :: {:ok, Guild.Member.t()} | {:error, String.t()}
  def get_member(guild_id, user_id) do
    case GuildCache.get(guild_id) do
      # If the guild was found, get the member via id from its members map.
      {:ok, guild} -> case Map.get(guild.members, user_id) do
        nil -> {:error, "<@#{user_id}> is not a member of this server."}
        member -> {:ok, member}
      end

      # Guild not found in cache
      # TODO: fetch from API?
      {:error, reason} -> {:error, reason}
    end
  end

  @doc """
  Gets whether a member is hierarchially above another member in a given server.
  TODO: find a better place to put this?
  """
  @spec is_above?(Guild.id(), Guild.Member.t(), Guild.Member.t()) :: boolean()
  def is_above?(guild_id, member, target) when is_integer(guild_id) do
    case GuildCache.get(guild_id) do
      {:ok, guild} -> is_above?(guild, member, target)
      {:error, _reason} -> false  # TODO: better handling?
    end
  end

  @spec is_above?(Guild.t(), Guild.Member.t(), Guild.Member.t()) :: boolean()
  def is_above?(guild, member, target) do
    target_top_role = Guild.Member.top_role(target, guild)

    case Guild.Member.top_role(member, guild) do
      nil -> false  # If user has no roles, they are not hierarchially above other users.
      role -> role.position > target_top_role.position
    end
  end
end
