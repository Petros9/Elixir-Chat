defmodule ChatApp.Talk do
    alias ChatApp.Repo
    alias ChatApp.Talk.Room
    alias ChatApp.Talk.Message

    import Ecto.Query

    def create_message(user, room, attrs) do
        user
        |> Ecto.build_assoc(:messages, room_id: room.id)
        |> Message.changeset(attrs)
        |> Repo.insert()
    end

    def list_messages(room_id, limit\\30) do
        Repo.all(
            from message in Message,
            join: user in assoc(message, :user),
            where: message.room_id == ^room_id,
            order_by: [desc: message.inserted_at],
            limit: ^limit,
            select: %{body: message.body, user: %{username: user.username}}
        )
    end

    def list_rooms() do
        Repo.all(Room)
    end

    def create_room(user, attrs \\ %{}) do
        user
        |> Ecto.build_assoc(:rooms)
        |> Room.changeset(attrs)
        |> Repo.insert()
    end

    def get_room!(id), do: Repo.get!(Room, id)

    def change_room(%Room{} = room) do
        Room.changeset(room, %{})
    end

    def update_room(%Room{} = room, attrs) do
        room
        |> Room.changeset(attrs)
        |> Repo.update
    end

    def delete_room(%Room{} = room) do
        room |> Repo.delete()
    end
end