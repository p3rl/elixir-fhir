defmodule ExFhir.InMemoryFhirRepo do
  use GenServer
  use Timex
  require Logger
  alias ExFhir.Model.Resource, as: Resource
  alias ExFhir.Model.ResourceId, as: ResourceId
  import String, only: [downcase: 1]

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, name: :fhir_repo)
  end

  def init(:ok) do
    Logger.info "[FhirRepo] Initializing inmemory FHIR repository"
    {:ok, %{resources: [], counters: %{}}}
  end

  def handle_call({:get_all, resourcetype}, _from, db) do
    Logger.info "[FhirRepo] get all #{resourcetype}"

    resources =
      db.resources
      |> Enum.filter(&(Resource.is_type(&1, resourcetype)))
      |> Enum.filter(&(is_latest_version(&1, db)))

    {:reply, resources, db}
  end

  def handle_call({:get_resource, resourcetype, [id: id, vid: vid]}, _from, db) do
    Logger.info "[FhirRepo] get resource #{resourcetype}, id #{id}, vid #{vid}"

    req_id = ResourceId.build("", downcase(resourcetype), id, vid)
    resource = Enum.find(db.resources, fn(r) ->
      id = Resource.get_identity(r)
      downcase(id.resourcetype) == req_id.resourcetype and id.id == req_id.id and id.vid == req_id.vid
    end)

    {:reply, resource, db}
  end

  def handle_call({:get_resource, resourcetype, [id: id]}, _from, db) do
    Logger.info "[FhirRepo] get resource #{resourcetype}, id #{id}"

    resource =
      db.resources
      |> Enum.filter(&(Resource.is_type(&1, resourcetype)))
      |> Enum.filter(&(is_latest_version(&1, db)))
      |> Enum.find(&(Resource.get_id(&1) == id))

    {:reply, resource, db}
  end

  def handle_call({:insert, resource}, _from, db) do
    Logger.info "[FhirRepo] insert resource"

    type_name = downcase(Resource.get_type(resource))
    instance_counters = Dict.get(db.counters, type_name, %{count: 0, versions: %{}})
    nextid = instance_counters.count + 1
    instance_counters = %{instance_counters | count: nextid, versions: Dict.put(instance_counters.versions, to_string(nextid), 1)}

    counters = Dict.put(db.counters, type_name, instance_counters)

    resource =
      resource
      |> Resource.with_id(to_string(nextid))
      |> Resource.with_meta(vid: "1", updated: get_date_time())

    {:reply, resource, %{db | resources: [resource | db.resources], counters: counters}}
  end

  def handle_call({:update, resource}, _from, db) do
    Logger.info "[FhirRepo] update resource"

    id = Resource.get_identity(resource)
    instance_counters = db.counters[downcase(id.resourcetype)];
    nextvid = 1 + instance_counters.versions[id.id];
    version_counters = Dict.put(instance_counters.versions, id.id, nextvid)
    instance_counters = Dict.put(instance_counters, :versions, version_counters)
    counters = Dict.put(db.counters, downcase(id.resourcetype), instance_counters)

    resource =
      resource
      |> Resource.with_meta(vid: to_string(nextvid), updated: get_date_time())

    {:reply, resource, %{db | resources: [resource | db.resources], counters: counters}}
  end

  defp get_date_time(), do: DateFormat.format!(Date.now(), "{ISO}")

  defp is_latest_version(%{} = resource, %{} = db) do
    id = Resource.get_identity(resource)
    instance_counters = db.counters[downcase(id.resourcetype)]
    versions = instance_counters.versions
    latest_version = to_string(versions[id.id])
    id.vid === latest_version
  end

end
