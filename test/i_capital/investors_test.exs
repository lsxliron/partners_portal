defmodule ICapital.InvestorsTest do
  use ICapital.DataCase

  alias ICapital.Investors

  describe "inverstor_infos" do
    alias ICapital.Investors.InvestorInfo

    import ICapital.InvestorsFixtures

    @invalid_attrs %{
      state: nil,
      first_name: nil,
      last_name: nil,
      dob: nil,
      phone_number: nil,
      street: nil,
      city: nil,
      zip_code: nil,
      records: nil
    }

    test "list_inverstor_infos/0 returns all inverstor_infos" do
      investor_info = investor_info_fixture()
      assert Investors.list_inverstor_infos() == [investor_info]
    end

    test "get_investor_info!/1 returns the investor_info with given id" do
      investor_info = investor_info_fixture()
      assert Investors.get_investor_info!(investor_info.id) == investor_info
    end

    test "create_investor_info/1 with valid data creates a investor_info" do
      valid_attrs = %{
        state: "NY",
        first_name: "some first_name",
        last_name: "some last_name",
        dob: ~D[2025-05-14],
        phone_number: "2125555555",
        street: "some street",
        city: "some city",
        zip_code: "12345",
        records: ["file1", "file2"]
      }

      assert {:ok, %InvestorInfo{} = investor_info} = Investors.create_investor_info(valid_attrs)
      assert investor_info.state == "NY"
      assert investor_info.first_name == "some first_name"
      assert investor_info.last_name == "some last_name"
      assert investor_info.dob == ~D[2025-05-14]
      assert investor_info.phone_number == "2125555555"
      assert investor_info.street == "some street"
      assert investor_info.city == "some city"
      assert investor_info.zip_code == "12345"
      assert investor_info.records == ["file1", "file2"]
    end

    test "create_investor_info/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Investors.create_investor_info(@invalid_attrs)
    end

    test "update_investor_info/2 with valid data updates the investor_info" do
      investor_info = investor_info_fixture()

      update_attrs = %{
        state: "NY",
        first_name: "some updated first_name",
        last_name: "some updated last_name",
        dob: ~D[2025-05-15],
        phone_number: "2125555555",
        street: "some updated street",
        city: "some updated city",
        zip_code: "12345",
        records: ["file1"]
      }

      assert {:ok, %InvestorInfo{} = investor_info} =
               Investors.update_investor_info(investor_info, update_attrs)

      assert investor_info.state == "NY"
      assert investor_info.first_name == "some updated first_name"
      assert investor_info.last_name == "some updated last_name"
      assert investor_info.dob == ~D[2025-05-15]
      assert investor_info.phone_number == "2125555555"
      assert investor_info.street == "some updated street"
      assert investor_info.city == "some updated city"
      assert investor_info.zip_code == "12345"
      assert investor_info.records == ["file1"]
    end

    test "update_investor_info/2 with invalid data returns error changeset" do
      investor_info = investor_info_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Investors.update_investor_info(investor_info, @invalid_attrs)

      assert investor_info == Investors.get_investor_info!(investor_info.id)
    end

    test "delete_investor_info/1 deletes the investor_info" do
      investor_info = investor_info_fixture()
      assert {:ok, %InvestorInfo{}} = Investors.delete_investor_info(investor_info)
      assert_raise Ecto.NoResultsError, fn -> Investors.get_investor_info!(investor_info.id) end
    end

    test "change_investor_info/1 returns a investor_info changeset" do
      investor_info = investor_info_fixture()
      assert %Ecto.Changeset{} = Investors.change_investor_info(investor_info)
    end
  end
end
