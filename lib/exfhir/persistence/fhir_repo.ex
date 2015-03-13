defmodule ExFhir.FhirRepo do

  def get_all(resourcetype), do: GenServer.call(:fhir_repo, {:get_all, resourcetype})

  def get_resource(resourcetype, [id: id, vid: vid]), do: GenServer.call(:fhir_repo, {:get_resource, resourcetype, [id: id, vid: vid]})

  def get_resource(resourcetype, [id: id]), do: GenServer.call(:fhir_repo, {:get_resource, resourcetype, [id: id]})

  def insert(resource), do: GenServer.call(:fhir_repo, {:insert, resource})

  def update(resource), do: GenServer.call(:fhir_repo, {:update, resource})

end
