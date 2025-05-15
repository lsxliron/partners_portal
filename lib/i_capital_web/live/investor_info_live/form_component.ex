defmodule ICapitalWeb.InvestorInfoLive.FormComponent do
  use ICapitalWeb, :live_component
  require Logger
  alias ICapital.Investors

  @impl true
  def mount(socket) do
    socket =
      socket
      |> assign(:uploaded_files, [])
      |> allow_upload(:documents,
        accept: ~w(.jpg .jpeg .pdf .png .tiff .tar .gz .zip),
        max_entries: 10,
        max_file_size: 100_000_000
      )

    {:ok, socket}
  end

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
        <div class="mt-2">
          <label for="documents" class="block text-sm font-semibold leading-6 text-zinc-800 mb-2">
            Documents
          </label>
          <.live_file_input upload={@uploads.documents} />
        </div>

        <section>
          <article :for={entry <- @uploads.documents.entries} class="upload-entry">
            <div class="w-full flex items-center gap-4">
              <p class="flex-initial">{entry.client_name}</p>
              <progress class="flex-1" value={entry.progress} max="100">{entry.progress}%</progress>
              <button
                type="button"
                phx-click="cancel-upload"
                phx-value-ref={entry.ref}
                aria-label="cancel"
              >
                <.icon name="hero-x-mark" />
              </button>
            </div>
          </article>
        </section>
        <:actions>
          <.button phx-disable-with="Saving...">Save Investor info</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @doc """
  Handles the file upload and return the files path after upload ot the assigns
  """
  @spec upload_files(socket :: Phoenix.LiveView.Socket.t()) :: list(String.t())
  def upload_files(socket) do
    consume_uploaded_entries(socket, :documents, fn %{path: path}, _entry ->
      target_folder = :code.priv_dir(:i_capital) |> Path.join("uploads")
      filename = Path.basename(path)
      dest = Path.join(target_folder, filename)
      Logger.info("uploading file to #{dest}")

      # TODO: better error handling
      File.cp!(path, dest)
      Logger.info("#{dest} was uploaded successfully")
      {:ok, dest}
    end)
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
  def handle_event("cancel-upload", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :documents, ref)}
  end

  @impl true
  def handle_event("validate", %{"investor_info" => investor_info_params}, socket) do
    changeset = Investors.change_investor_info(socket.assigns.investor_info, investor_info_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"investor_info" => investor_info_params}, socket) do
    uploaded_files = upload_files(socket)

    # Ensure no errors on upload
    investor_info_params = investor_info_params |> Map.put("records", uploaded_files)
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
