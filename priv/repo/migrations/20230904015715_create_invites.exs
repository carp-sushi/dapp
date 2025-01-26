defmodule Dapp.Repo.Migrations.CreateInvites do
  use Ecto.Migration

  def change do
    create table(:invites, primary_key: false) do
      add :id, :string, size: 21, primary_key: true
      add :user_id, references(:users, type: :string), size: 21, null: false
      add :role_id, references(:roles), null: false
      add :email, :string, null: false
      add :consumed_at, :timestamp
      timestamps()
    end
    create unique_index(:invites, [:email])
  end
end
