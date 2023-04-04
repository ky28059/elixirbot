defmodule Elixirbot.Consumer do
  @moduledoc """
  Documentation for `Elixirbot`.
  """

  require Logger
  use Nostrum.Consumer

  alias Nostrum.Api
  alias Nostrum.Struct.{Embed, User}

  def start_link do
    Consumer.start_link(__MODULE__)
  end

  def handle_event({:READY, data, _ws_state}) do
    Logger.info("Logged in as #{User.full_name(data.user)}!")

    # https://discord.com/developers/docs/game-sdk/activities#data-models-activitytype-enum
    Api.update_status(:online, "the competition", 5)
  end

  def handle_event({:MESSAGE_CREATE, msg, _ws_state}) do
    case msg.content do
      "!ping" ->
        Api.create_message(msg.channel_id, "pong!")

      "!pfp" ->
        # Semi-hacky workaround to get larger pfp size (not supported by nostrum as it is by discord.js)
        icon_url = User.avatar_url(msg.author) <> "?size=4096"

        embed = %Embed{}
          |> Embed.put_author(User.full_name(msg.author), nil, icon_url)
          |> Embed.put_image(icon_url)
          |> Embed.put_color(0x6e4a7e)
          |> Embed.put_footer("Requested by #{User.full_name(msg.author)}", nil)

        Api.create_message(
          msg.channel_id,
          embeds: [embed],
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
