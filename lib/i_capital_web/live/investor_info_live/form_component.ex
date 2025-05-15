defmodule ICapitalWeb.InvestorInfoLive.FormComponent do
  use ICapitalWeb, :live_component

  alias ICapital.Investors

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage investor_info records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="investor_info-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:first_name]} type="text" label="First name" />
        <.input field={@form[:last_name]} type="text" label="Last name" />
        <.input field={@form[:dob]} type="date" label="Dob" />
        <.input field={@form[:phone_number]} type="text" label="Phone number" />
        <.input field={@form[:street]} type="text" label="Street" />
        <.input field={@form[:city]} type="text" label="City" />
        <.input field={@form[:state]} type="text" label="State" />
        <.input field={@form[:zip_code]} type="text" label="Zip code" />
        <.input
          field={@form[:records]}
          type="select"
          multiple
          label="Records"
          options={[{"Option 1", "option1"}, {"Option 2", "option2"}]}
        />
        <:actions>
          <.button phx-disable-with="Saving...">Save Investor info</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{investor_info: investor_info} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Investors.change_investor_info(investor_info))
     end)}
  end

  @impl true
  def handle_event("validate", %{"investor_info" => investor_info_params}, socket) do
    changeset = Investors.change_investor_info(socket.assigns.investor_info, investor_info_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"investor_info" => investor_info_params}, socket) do
    save_investor_info(socket, socket.assigns.action, investor_info_params)
  end

  defp save_investor_info(socket, :edit, investor_info_params) do
    case Investors.update_investor_info(socket.assigns.investor_info, investor_info_params) do
      {:ok, investor_info} ->
        notify_parent({:saved, investor_info})

        {:noreply,
         socket
         |> put_flash(:info, "Investor info updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_investor_info(socket, :new, investor_info_params) do
    case Investors.create_investor_info(investor_info_params) do
      {:ok, investor_info} ->
        notify_parent({:saved, investor_info})

        {:noreply,
         socket
         |> put_flash(:info, "Investor info created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
