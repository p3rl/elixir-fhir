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

    resources =
      db.resources
      |> Enum.filter(&(Resource.is_type(&1, resourcetype)))
      |> Enum.filter(&(is_latest_version(&1, db)))

    {:reply, resources, db}
  end

  def handle_call({:insert, resource}, _from, db) do
    Logger.info "[FhirRepo] insert resource"

    type_name = Resource.get_type(resource)
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
    instance_counters = db.counters[id.resourcetype];
    nextvid = 1 + instance_counters.versions[id.id];
    version_counters = Dict.put(instance_counters.versions, id.id, nextvid)
    instance_counters = Dict.put(instance_counters, :versions, version_counters)
    counters = Dict.put(db.counters, id.resourcetype, instance_counters)

    resource =
      resource
      |> Resource.with_meta(vid: to_string(nextvid), updated: get_date_time())

    {:reply, resource, %{db | resources: [resource | db.resources], counters: counters}}
  end

  defp get_date_time(), do: DateFormat.format!(Date.now(), "{ISO}")

  defp is_latest_version(%{} = resource, %{} = db) do
    id = Resource.get_identity(resource)
    versions = db.counters[id.resourcetype].versions
    latest_version = to_string(versions[id.id])
    IO.puts "latest version #{latest_version}"
    id.vid === latest_version
  end

end
