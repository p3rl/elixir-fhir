defmodule ExFhir.Model.ResourceId do
  alias ExFhir.Model.ResourceId, as: ResourceId

  defstruct baseuri: "", resourcetype: "", id: "", vid: ""

  def build(baseuri, resourcetype, id, vid) do
    %ResourceId{baseuri: baseuri, resourcetype: resourcetype, id: id, vid: vid}
  end

  def has_version(%ResourceId{vid: vid}), do: vid !== ""

  def without_version(%ResourceId{baseuri: baseuri, resourcetype: resourcetype, id: id, vid: _vid}) do
    %ResourceId{baseuri: baseuri, resourcetype: resourcetype, id: id, vid: ""}
  end

  def to_string(%ResourceId{vid: vid} = id) when vid !== "" do
    "#{id.baseuri}/#{id.resourcetype}/#{id.id}/_history/#{id.vid}"
  end

  def to_string(%ResourceId{} = id) do
    "#{id.baseuri}/#{id.resourcetype}/#{id.id}"
  end

end
