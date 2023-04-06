defmodule Elixirbot.Handlers.Ready do
  require Logger

  alias Nosedrum.Storage.ETS, as: CommandStorage
  alias Nostrum.Api
  alias Nostrum.Struct.User

  @commands %{
    "ping" => Elixirbot.Commands.Ping,
    "avatar" => Elixirbot.Commands.Avatar,
    "echo" => Elixirbot.Commands.Echo,
    "kick" => Elixirbot.Commands.Kick,
    "help" => Elixirbot.Commands.Help
  }

  # TODO: better way of expressing overlap between the two?
  @global_slash_commands %{
    "ping" => Elixirbot.Commands.Ping,
    "avatar" => Elixirbot.Commands.Avatar,
    "echo" => Elixirbot.Commands.Echo,
    "kick" => Elixirbot.Commands.Kick,
    "help" => Elixirbot.Commands.Help
  }

  @doc """
  Handles the :READY event by updating the bot's status and registering text and slash commands.
  """
  @spec handle(map()) :: :ok
  def handle(data) do
    Logger.info("Logged in as #{User.full_name(data.user)}!")

    # https://discord.com/developers/docs/game-sdk/activities#data-models-activitytype-enum
    prefix = Application.get_env(:nosedrum, :prefix)
    Api.update_status(:online, "#{prefix}help", 2)

    # Add text commands to storage
    Enum.each(@commands, fn {name, command} -> CommandStorage.add_command([name], command) end)

    # Register global slash commands
    Enum.each(@global_slash_commands, fn {name, command} ->
      case Nosedrum.Interactor.Dispatcher.add_command(name, command, :global) do
        {:ok, _} -> Logger.info("Registered command [#{name}].")
        e -> IO.inspect(e, label: "An error occurred registering command [#{name}]")
      end
    end)
  end
end
