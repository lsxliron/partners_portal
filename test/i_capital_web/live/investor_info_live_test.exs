defmodule ICapitalWeb.InvestorInfoLiveTest do
  use ICapitalWeb.ConnCase

  import Phoenix.LiveViewTest
  import ICapital.InvestorsFixtures

  @create_attrs %{
    state: "NY",
    first_name: "some first_name",
    last_name: "some last_name",
    dob: "2025-05-14",
    phone_number: "some 2125554345",
    street: "some street",
    city: "some city",
    zip_code: "12345",
    records: ["file1", "file2"]
  }
  @update_attrs %{
    state: "NY",
    first_name: "some updated first_name",
    last_name: "some updated last_name",
    dob: "2025-05-15",
    phone_number: "212555665",
    street: "some updated street",
    city: "some updated city",
    zip_code: "12345",
    records: ["file3"]
  }
  @invalid_attrs %{
    state: nil,
    first_name: nil,
    last_name: nil,
    dob: nil,
    phone_number: nil,
    street: nil,
    city: nil,
    zip_code: nil,
    records: []
  }

  defp create_investor_info(_) do
    investor_info = investor_info_fixture()
    %{investor_info: investor_info}
  end

  describe "Index" do
    setup [:register_and_log_in_user, :create_investor_info]

    test "lists all inverstor_infos", %{conn: conn, investor_info: investor_info} do
      {:ok, _index_live, html} = live(conn, ~p"/inverstor_infos")

      assert html =~ "Listing Inverstor infos"
      assert html =~ investor_info.state
    end

    test "saves new investor_info", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/inverstor_infos")

      assert index_live |> element("a", "New Investor info") |> render_click() =~
               "New Investor info"

      assert_patch(index_live, ~p"/inverstor_infos/new")

      assert index_live
             |> form("#investor_info-form", investor_info: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#investor_info-form", investor_info: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/inverstor_infos")

      html = render(index_live)
      assert html =~ "Investor info created successfully"
      assert html =~ "some state"
    end

    test "updates investor_info in listing", %{conn: conn, investor_info: investor_info} do
      {:ok, index_live, _html} = live(conn, ~p"/inverstor_infos")

      assert index_live
             |> element("#inverstor_infos-#{investor_info.id} a", "Edit")
             |> render_click() =~
               "Edit Investor info"

      assert_patch(index_live, ~p"/inverstor_infos/#{investor_info}/edit")

      assert index_live
             |> form("#investor_info-form", investor_info: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#investor_info-form", investor_info: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/inverstor_infos")

      html = render(index_live)
      assert html =~ "Investor info updated successfully"
      assert html =~ "NY"
    end

    test "deletes investor_info in listing", %{conn: conn, investor_info: investor_info} do
      {:ok, index_live, _html} = live(conn, ~p"/inverstor_infos")

      assert index_live
             |> element("#inverstor_infos-#{investor_info.id} a", "Delete")
             |> render_click()

      refute has_element?(index_live, "#inverstor_infos-#{investor_info.id}")
    end
  end

  describe "Show" do
    setup [:register_and_log_in_user, :create_investor_info]

    test "displays investor_info", %{conn: conn, investor_info: investor_info} do
      {:ok, _show_live, html} = live(conn, ~p"/inverstor_infos/#{investor_info}")

      assert html =~ "Show Investor info"
      assert html =~ investor_info.state
    end

    test "updates investor_info within modal", %{conn: conn, investor_info: investor_info} do
      {:ok, show_live, _html} = live(conn, ~p"/inverstor_infos/#{investor_info}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Investor info"

      assert_patch(show_live, ~p"/inverstor_infos/#{investor_info}/show/edit")

      assert show_live
             |> form("#investor_info-form", investor_info: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#investor_info-form", investor_info: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/inverstor_infos/#{investor_info}")

      html = render(show_live)
      assert html =~ "Investor info updated successfully"
      assert html =~ "some updated state"
    end
  end
end
