defmodule ExFhir.Model.Resource do
  alias ExFhir.Model.ResourceId, as: ResourceId
  alias ExFhir.Model.ResourceMeta, as: ResourceMeta

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

  def is_type(%{"resourceType" => resourcetype}, type), do: String.downcase(resourcetype) === String.downcase(type)

  def get_type(%{"resourceType" => resourcetype}), do: resourcetype

  def get_identity(%{"resourceType" => resourcetype} = resource) do
    id = Dict.get(resource, "id", "")
    meta = Dict.get(resource, "meta", %{})
    vid = Dict.get(meta, "versionId", "")
    %ResourceId{resourcetype: resourcetype, id: id, vid: vid}
  end

  def get_meta(%{"resourceType" => _resourcetype} = resource) do
    meta = Dict.get(resource, "meta", %{})
    vid = Dict.get(meta, "versionId", "")
    updated = Dict.get(meta, "lastUpdated", "")
    %ResourceMeta{vid: vid, lastupdated: updated}
  end

  def get_vid(%{"resourceType" => _resourcetype, "meta" => %{"versionId" => vid}}), do: vid

  def get_id(%{"resourceType" => _resourcetype, "id" => id}), do: id

  def get_id(%{"resourceType" => _resourcetype}), do: ""

end
