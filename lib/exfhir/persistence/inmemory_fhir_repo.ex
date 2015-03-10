defmodule ExFhir.InMemoryFhirRepo do
  use GenServer
  use Timex
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
    resource_type = Resource.get_type(resource)
    type_counter = Dict.get(db.counters, resource_type, %{count: 0, version: %{1 => 1}})
    nextid = type_counter.count + 1
    counters = Dict.put(db.counters, resource_type, %{type_counter | count: nextid})
    resource = Resource.with_id(resource, nextid) |> Resource.with_meta(vid: "1", updated: get_date_time())
    {:reply, resource, %{db | resources: [resource | db.resources], counters: counters}}
  end

  defp get_date_time(), do: DateFormat.format!(Date.now(), "{ISO}")

end
