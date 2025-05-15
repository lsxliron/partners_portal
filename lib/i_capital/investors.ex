defmodule ICapital.Investors do
  @moduledoc """
  The Investors context.
  """

  import Ecto.Query, warn: false
  alias ICapital.Repo

  alias ICapital.Investors.InvestorInfo

  @doc """
  Returns the list of inverstor_infos.

  ## Examples

      iex> list_inverstor_infos()
      [%InvestorInfo{}, ...]

  """
  def list_inverstor_infos do
    Repo.all(InvestorInfo)
  end

  @doc """
  Gets a single investor_info.

  Raises `Ecto.NoResultsError` if the Investor info does not exist.

  ## Examples

      iex> get_investor_info!(123)
      %InvestorInfo{}

      iex> get_investor_info!(456)
      ** (Ecto.NoResultsError)

  """
  def get_investor_info!(id), do: Repo.get!(InvestorInfo, id)

  @doc """
  Creates a investor_info.

  ## Examples

      iex> create_investor_info(%{field: value})
      {:ok, %InvestorInfo{}}

      iex> create_investor_info(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_investor_info(attrs \\ %{}) do
    %InvestorInfo{}
    |> InvestorInfo.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a investor_info.

  ## Examples

      iex> update_investor_info(investor_info, %{field: new_value})
      {:ok, %InvestorInfo{}}

      iex> update_investor_info(investor_info, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_investor_info(%InvestorInfo{} = investor_info, attrs) do
    investor_info
    |> InvestorInfo.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a investor_info.

  ## Examples

      iex> delete_investor_info(investor_info)
      {:ok, %InvestorInfo{}}

      iex> delete_investor_info(investor_info)
      {:error, %Ecto.Changeset{}}

  """
  def delete_investor_info(%InvestorInfo{} = investor_info) do
    Repo.delete(investor_info)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking investor_info changes.

  ## Examples

      iex> change_investor_info(investor_info)
      %Ecto.Changeset{data: %InvestorInfo{}}

  """
  def change_investor_info(%InvestorInfo{} = investor_info, attrs \\ %{}) do
    InvestorInfo.changeset(investor_info, attrs)
  end
end
