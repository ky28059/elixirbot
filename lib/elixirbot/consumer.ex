defmodule Elixirbot.Consumer do
  require Logger
  use Nostrum.Consumer

  alias Nosedrum.Invoker.Split, as: CommandInvoker
  alias Nosedrum.Storage.ETS, as: CommandStorage
  alias Nostrum.Api
  alias Nostrum.Struct.{User}

  @commands %{
    "ping" => Elixirbot.Commands.Ping,
    "avatar" => Elixirbot.Commands.Avatar
  }

  def start_link do
    Consumer.start_link(__MODULE__)
  end

  def handle_event({:READY, data, _ws_state}) do
    Logger.info("Logged in as #{User.full_name(data.user)}!")

    # https://discord.com/developers/docs/game-sdk/activities#data-models-activitytype-enum
    Api.update_status(:online, "the competition", 5)

    # Add commands to storage
    Enum.each(@commands, fn {name, command} -> CommandStorage.add_command([name], command) end)
  end

  def handle_event({:MESSAGE_CREATE, msg, _ws_state}) do
    CommandInvoker.handle_message(msg, CommandStorage)
  end

  def handle_event(_event) do
    :noop
  end
end
