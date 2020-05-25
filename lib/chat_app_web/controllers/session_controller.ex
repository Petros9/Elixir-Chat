defmodule ChatAppWeb.SessionController do
    use ChatAppWeb, :controller

    alias ChatApp.Accounts

    def new(conn, _params) do
        render(conn, "new.html")
    end

    def create(conn , %{"session" => %{"email" => email, "password" => password}}) do
        case Accounts.sign_in(email, password) do
            {:ok, user} ->
                conn
                |> put_session(:current_user_id, user.id)
                |> put_flash(:info, "Signed In")
                |>redirect(to: Routes.room_path(conn, :index))

            {:error, _} ->
                conn
                |> put_flash(:error, "Wrong email or password!")
                |> render("new.html")
        end
    end

    def delete(conn, _params) do
        conn
        |> Accounts.sign_out()
        |> redirect(to: Routes.room_path(conn, :index))
    end
end