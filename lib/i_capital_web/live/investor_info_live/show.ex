defmodule ICapitalWeb.InvestorInfoLive.Show do
  use ICapitalWeb, :live_view

  alias ICapital.Investors

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:investor_info, Investors.get_investor_info!(id))}
  end

  defp page_title(:show), do: "Show Investor info"
  defp page_title(:edit), do: "Edit Investor info"
end
