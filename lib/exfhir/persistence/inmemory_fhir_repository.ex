defmodule ExFhir.InMemoryFhirRepository do
  use GenServer
  require Logger

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, name: :fhir_repo)
  end

  def init(:ok) do
    Logger.info "[FhirRepo] Initializing inmemory FHIR repository"
    {:ok, %{resources: []}}
  end

  def handle_call({:get_all, resourcetype}, _from, db) do
    Logger.info "[FhirRepo] get all #{resourcetype}"
    {:reply, db.resources, db}
  end

  def handle_call({:insert, resource_base_content, resource}, _from, db) do
    Logger.info "[FhirRepo] insert resource"
    {:reply, resource, %{db | resources: [resource | db.resources]}}
  end

end
