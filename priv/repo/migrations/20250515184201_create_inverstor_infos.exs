defmodule ICapital.Repo.Migrations.CreateInverstorInfos do
  use Ecto.Migration

  def change do
    create table(:inverstor_infos) do
      add :first_name, :string
      add :last_name, :string
      add :dob, :date
      add :phone_number, :string
      add :street, :string
      add :city, :string
      add :state, :string
      add :zip_code, :string
      add :records, {:array, :string}

      timestamps(type: :utc_datetime)
    end
  end
end
