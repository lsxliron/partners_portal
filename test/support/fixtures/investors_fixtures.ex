defmodule ICapital.InvestorsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ICapital.Investors` context.
  """

  @doc """
  Generate a investor_info.
  """
  def investor_info_fixture(attrs \\ %{}) do
    {:ok, investor_info} =
      attrs
      |> Enum.into(%{
        city: "some city",
        dob: ~D[2025-05-14],
        first_name: "some first_name",
        last_name: "some last_name",
        phone_number: "2125556789",
        records: ["file10", "file11"],
        state: "NY",
        street: "some street",
        zip_code: "12345"
      })
      |> ICapital.Investors.create_investor_info()

    investor_info
  end
end
