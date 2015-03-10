defmodule ExFhir.InMemoryFhirRepo do
  use GenServer
  use Timex
  require Logger
  alias ExFhir.Model.Resource, as: Resource
  alias ExFhir.Model.ResourceId, as: ResourceId

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, name: :fhir_repo)
  end

  def init(:ok) do
    Logger.info "[FhirRepo] Initializing inmemory FHIR repository"
    {:ok, %{resources: [], instance_counters: %{}, version_counters: %{}}}
  end

  def handle_call({:get_all, resourcetype}, _from, db) do
    Logger.info "[FhirRepo] get all #{resourcetype}"
    resources = Enum.filter(db.resources, &(Resource.is_type(&1, resourcetype)))
    {:reply, resources, db}
  end

  def handle_call({:insert, resource}, _from, db) do
    Logger.info "[FhirRepo] insert resource"

    resourcetype = Resource.get_type(resource)
    nextid = 1 + Dict.get(db.instance_counters, resourcetype, 0)
    instance_counters = Dict.put(db.instance_counters, resourcetype, nextid)
    resource = Resource.with_id(resource, to_string(nextid)) |> Resource.with_meta(vid: "1", updated: get_date_time())

    {:reply, resource, %{db | resources: [resource | db.resources], instance_counters: instance_counters}}
  end

  def handle_call({:update, resource}, _from, db) do
    Logger.info "[FhirRepo] update resource"

    id = Resource.get_identity(resource)
    nextvid = 1 + Dict.get(db.version_counters, id.id, 0)
    version_counters = Dict.put(db.version_counters, id.id, nextvid)
    resource = Resource.with_meta(resource, vid: to_string(nextvid), updated: get_date_time())

    {:reply, resource, %{db | resources: [resource | db.resources], version_counters: version_counters}}
  end

  defp get_date_time(), do: DateFormat.format!(Date.now(), "{ISO}")

end
