defmodule ChatAppWeb.RoomController do
    use ChatAppWeb, :controller

    alias ChatApp.Talk.Room
    alias ChatApp.Talk

    plug ChatAppWeb.Plugs.AuthUser when action not in [:index]

    plug :authorise_user when action in [:edit, :update, :delete]

    def index(conn, _params) do
        rooms = Talk.list_rooms()
        render(conn, "index.html", rooms: rooms)
    end

    def new(conn, _params) do
        changeset = Room.changeset(%Room{}, %{})
        render(conn, "new.html", changeset: changeset)
    end

    def create(conn, %{"room" => room_params}) do
        case Talk.create_room(conn.assigns.current_user, room_params) do
            {:ok, _} ->
                conn
                |> put_flash(:info, "Room Opened!")
                |> redirect(to: Routes.room_path(conn, :index))

            {:error, %Ecto.Changeset{} = changeset} ->
                render(conn, "new.html", changeset: changeset)
        end
    end

    def show(conn, %{"id" => id}) do
        room = Talk.get_room!(id)
        render(conn, "show.html", room: room)
    end

    def edit(conn, %{"id" => id}) do
        room = Talk.get_room!(id)
        changeset = Talk.change_room(room)
        render(conn, "edit.html", room: room, changeset: changeset)
    end

    def update(conn, %{"id" => id, "room" => room_params}) do
        room = Talk.get_room!(id)

        case Talk.update_room(room, room_params) do
            {:ok, _} ->
                conn
                |> put_flash(:info, "Room updated")
                |> redirect(to: Routes.room_path(conn, :show, room))
            {:error, %Ecto.Changeset{} = changeset} ->
                render(conn, "edt.html", room: room, changeset: changeset)
        end
    end

    def delete(conn, %{"id" => id}) do
        room = Talk.get_room!(id)
        {:ok, _} = Talk.delete_room(room)

        conn
        |>put_flash(:info, "Room deleted")
        |> redirect(to: Routes.room_path(conn, :index))
    end


    defp authorise_user(conn, _params) do
        %{params: %{"id" => room_id}} = conn
        room = Talk.get_room!(room_id)

        if conn.assigns.current_user.id == room.user_id do
            conn
        else 
            conn
            |> put_flash(:error, "Not authorised!")
            |> redirect(to: Routes.room_path(conn, :index))
            |> halt()
        end
    end
end