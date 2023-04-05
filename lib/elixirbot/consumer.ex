defmodule Elixirbot.Consumer do
  require Logger
  use Nostrum.Consumer

  alias Nosedrum.Invoker.Split, as: CommandInvoker
  alias Nosedrum.Storage.ETS, as: CommandStorage
  alias Nostrum.Api
  alias Nostrum.Struct.{User}

  @commands %{
    "ping" => Elixirbot.Commands.Ping,
    "avatar" => Elixirbot.Commands.Avatar,
    "echo" => Elixirbot.Commands.Echo,
    "help" => Elixirbot.Commands.Help
  }

  @global_slash_commands %{
    "ping" => Elixirbot.Commands.Ping,
    "avatar" => Elixirbot.Commands.Avatar,
    "echo" => Elixirbot.Commands.Echo,
    "help" => Elixirbot.Commands.Help
  }

  def start_link do
    Consumer.start_link(__MODULE__)
  end

  def handle_event({:READY, data, _ws_state}) do
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

  def handle_event({:MESSAGE_CREATE, msg, _ws_state}) do
    CommandInvoker.handle_message(msg, CommandStorage)
  end

  def handle_event({:INTERACTION_CREATE, interaction, _ws_state}) do
    Nosedrum.Interactor.Dispatcher.handle_interaction(interaction)
  end

  def handle_event(_event) do
    :noop
  end
end
