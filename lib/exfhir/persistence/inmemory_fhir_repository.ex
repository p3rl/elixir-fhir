defmodule ExFhir.InMemoryFhirRepository do
  use GenServer
  require Logger

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, name: :fhir_repo)
  end

  def init(:ok) do
    Logger.info "Initializing inmemory FHIR repository"
    {:ok, %{resources: []}}
  end

  def handle_call({:get_all, resourcetype}, _from, db) do
    Logger.info "get all #{resourcetype}"
    {:reply, db.resources, db}
  end

  def handle_call({:insert, resource}, _from, db) do
    Logger.info "insert resource"
    {:reply, :ok, %{db | resources: [resource | db.resources]}}
  end

end
