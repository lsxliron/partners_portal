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
        phone_number: "some phone_number",
        records: ["option1", "option2"],
        state: "some state",
        street: "some street",
        zip_code: "some zip_code"
      })
      |> ICapital.Investors.create_investor_info()

    investor_info
  end
end
