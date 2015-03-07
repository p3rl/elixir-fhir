defmodule ExFhir.Model.ResourceId do
  alias ExFhir.Model.ResourceId, as: ResourceId
  defstruct baseuri: "", resource_type: "", id: "", version: ""

  def build(baseuri, resource_type, id, version) do
    %ResourceId{baseuri: baseuri, resource_type: resource_type, id: id, version: version}
  end

  def has_version(%ResourceId{version: version}) do
    version !== ""
  end

  def without_version(%ResourceId{baseuri: baseuri, resource_type: resource_type, id: id, version: _version}) do
    %ResourceId{baseuri: baseuri, resource_type: resource_type, id: id, version: ""}
  end

  def to_string(%ResourceId{version: version} = id) when version !== "" do
    "#{id.baseuri}/#{id.resource_type}/#{id.id}/_history/#{id.version}"
  end

  def to_string(%ResourceId{} = id) do
    "#{id.baseuri}/#{id.resource_type}/#{id.id}"
  end

end
