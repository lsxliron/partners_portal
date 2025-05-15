defmodule ICapital.Investors.InvestorInfo do
  use Ecto.Schema
  import Ecto.Changeset

  schema "inverstor_infos" do
    field :state, :string
    field :first_name, :string
    field :last_name, :string
    field :dob, :date
    field :phone_number, :string
    field :street, :string
    field :city, :string
    field :zip_code, :string
    field :records, {:array, :string}

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(investor_info, attrs) do
    investor_info
    |> cast(attrs, [
      :first_name,
      :last_name,
      :dob,
      :phone_number,
      :street,
      :city,
      :state,
      :zip_code,
      :records
    ])
    |> validate_required([
      :first_name,
      :last_name,
      :dob,
      :phone_number,
      :street,
      :city,
      :state,
      :zip_code,
      :records
    ])
    |> validate_length(:records, min: 1, max: 10)
    |> validate_length(:records, max: 10)
    |> validate_length(:zip_code, is: 5)
    |> validate_length(:phone_number, is: 10)
    |> validate_length(:state, is: 2)
  end
end
