defmodule ExFhir.InMemoryFhirRepo do
  use GenServer
  require Logger
  alias ExFhir.Model.Resource, as: Resource

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, name: :fhir_repo)
  end

  def init(:ok) do
    Logger.info "[FhirRepo] Initializing inmemory FHIR repository"
    {:ok, %{resources: [], counters: %{}}}
  end

  def handle_call({:get_all, resourcetype}, _from, db) do
    Logger.info "[FhirRepo] get all #{resourcetype}"
    resources = Enum.filter(db.resources, &(Resource.is_type(&1, resourcetype)))
    {:reply, resources, db}
  end

  def handle_call({:insert, resource}, _from, db) do
    Logger.info "[FhirRepo] insert resource"
    counters = Dict.put(db.counters, resource["resourceType"], %{count: 1, version: %{1 => 1}})
    resource = Resource.with_id(resource, "1") |> Resource.with_version("1")
    {:reply, resource, %{db | resources: [resource | db.resources], counters: counters}}
  end

end
