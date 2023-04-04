defmodule Elixirbot.Consumer do
  @moduledoc """
  Documentation for `Elixirbot`.
  """

  require Logger
  use Nostrum.Consumer

  alias Nostrum.Api
  alias Nostrum.Struct.User

  def start_link do
    Consumer.start_link(__MODULE__)
  end

  def handle_event({:READY, data, _ws_state}) do
    Logger.info("Logged in as #{data.user.username}##{data.user.discriminator}!")
    Api.update_status(:online, "the competition", 5)  # https://discord.com/developers/docs/game-sdk/activities#data-models-activitytype-enum
  end

  def handle_event({:MESSAGE_CREATE, msg, _ws_state}) do
    case msg.content do
      "!ping" ->
        Api.create_message(msg.channel_id, "pong!")

      "!pfp" ->
        Api.create_message(
          msg.channel_id,
          content: User.avatar_url(msg.author),
          message_reference: %{message_id: msg.id},
          allowed_mentions: :none
        )

      _ ->
        :ignore
    end
  end

  def handle_event(_event) do
    :noop
  end
end
