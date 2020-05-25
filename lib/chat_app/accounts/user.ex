defmodule ChatApp.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias ChatApp.Accounts.User

  schema "users" do
    field :email, :string
    field :password_hash, :string
    field :username, :string

    field :password, :string, virtual: true

    has_many :rooms, ChatApp.Talk.Room
    has_many :messages, ChatApp.Talk.Message
    
    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :username, :password_hash])
    |> validate_required([:email, :username, :password_hash])
    |> validate_length(:username, min: 5, max: 18)
    |> validate_length(:password_hash, min: 6, max: 30)
    |> unique_constraint(:email)
    |> unique_constraint(:username)
  end
  
  def registration_changeset(%User{} = user, attrs) do
    user
    |> changeset(attrs)
    |> writing()
  end

  def writing(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password_hash: password}}->
        put_change(changeset, :password_hash, password)
      _->
        changeset
      end
  end
end
