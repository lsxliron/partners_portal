defmodule ICapitalWeb.InvestorInfoLive.Index do
  use ICapitalWeb, :live_view

  alias ICapital.Investors
  alias ICapital.Investors.InvestorInfo

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :inverstor_infos, Investors.list_inverstor_infos())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Investor info")
    |> assign(:investor_info, Investors.get_investor_info!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Investor info")
    |> assign(:investor_info, %InvestorInfo{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Inverstor infos")
    |> assign(:investor_info, nil)
  end

  @impl true
  def handle_info({ICapitalWeb.InvestorInfoLive.FormComponent, {:saved, investor_info}}, socket) do
    {:noreply, stream_insert(socket, :inverstor_infos, investor_info)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    investor_info = Investors.get_investor_info!(id)
    {:ok, _} = Investors.delete_investor_info(investor_info)

    {:noreply, stream_delete(socket, :inverstor_infos, investor_info)}
  end
end
