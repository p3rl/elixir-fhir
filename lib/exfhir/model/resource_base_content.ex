defmodule ExFhir.Model.ResourceBaseContent do

  alias ExFhir.Model.ResourceId, as: ResourceId
  alias ExFhir.Model.ResourceMeta, as: ResourceMeta
  alias ExFhir.Model.ResourceBaseContent, as: ResourceBaseContent

  defstruct id: %ResourceId{}, meta: %ResourceMeta{}

  def from_json(json), do: Poison.Parser.parse!(json) |> from_resource

  def from_resource(%{} = resource) do
    id = parse_id(resource)
    meta = parse_meta(resource)
    %ResourceBaseContent{id: id, meta: meta}
  end

  defp parse_id(%{"resourceType" => resource_type} = resource) do
    %ResourceId
    {
      resource_type: resource_type,
      id: Dict.get(resource, "id", "")
    }
  end

  defp parse_meta(%{"meta" => meta}) do
    %ResourceMeta
    {
      versionid: Dict.get(meta, "versionId", ""),
      lastupdated: Dict.get(meta, "lastUpdated", "")
    }
  end

  defp parse_meta(%{}) do
    %ResourceMeta{}
  end
end
