defmodule ExFhir.FhirRepo do

  def get_all(resourcetype), do: GenServer.call(:fhir_repo, {:get_all, resourcetype})

  def get_resource(resourcetype, [id: id, vid: vid]), do: GenServer.call(:fhir_repo, {:get_resource, resourcetype, [id: id, vid: vid]})

  def get_resource!(resourcetype, [id: id, vid: vid]) do
    case GenServer.call(:fhir_repo, {:get_resource, resourcetype, [id: id, vid: vid]}) do
      {:ok, resource} -> resource
      {:error, reason} -> raise reason
    end
  end

  def get_resource(resourcetype, [id: id]), do: GenServer.call(:fhir_repo, {:get_resource, resourcetype, [id: id]})

  def get_resource!(resourcetype, [id: id]) do
    case GenServer.call(:fhir_repo, {:get_resource, resourcetype, [id: id]}) do
      {:ok, resource} -> resource
      {:error, reason} -> raise reason
    end
  end

  def insert(resource), do: GenServer.call(:fhir_repo, {:insert, resource})

  def insert!(resource) do
    case GenServer.call(:fhir_repo, {:insert, resource}) do
      {:ok, resource} -> resource
      {:error, reason} -> raise reason
    end
  end

  def update(resource), do: GenServer.call(:fhir_repo, {:update, resource})

  def update!(resource) do
    case GenServer.call(:fhir_repo, {:update, resource}) do
      {:ok, resource} -> resource
      {:error, reason} -> raise reason
    end
  end

end
