defmodule ExFhir.Model.Resource do

  def create(resourcetype), do: %{"resourceType" => resourcetype}

  def with_baseuri(%{} = resource, uri), do: Dict.put(resource, "baseUri", uri)

  def with_id(%{} = resource, id), do: Dict.put(resource, "id", id)

  def with_version(%{} = resource, vid), do: with_meta(resource, vid: vid)

  def with_meta(%{} = resource, [vid: vid, updated: updated]) do
    meta = Dict.get(resource, "meta", %{"versionId" => "", "lastUpdated" => ""})
    Dict.put(resource, "meta", %{meta | "versionId" => vid, "lastUpdated" => updated})
  end

  def with_meta(%{} = resource, [vid: vid]) do
    meta = Dict.get(resource, "meta", %{"versionId" => ""})
    Dict.put(resource, "meta", %{meta | "versionId" => vid})
  end

  def is_type(%{} = resource, type), do: String.downcase(resource["resourceType"]) === String.downcase(type)
end
