defmodule ExFhir.Model.ResourceBaseContentTest do
  use ExUnit.Case, async: true
  alias ExFhir.Model.ResourceBaseContent, as: ResourceBaseContent

  test "parse base content with meta succeeds" do
    bc = ResourceBaseContent.from_json(patient_json)
    assert bc.id.resource_type === "patient"
    assert bc.id.id === "1"
    assert bc.meta.versionid === "2"
    assert bc.meta.lastupdated === "2015-01-01"
  end

  test "parse base content with no meta succeeds" do
    bc = ResourceBaseContent.from_json(patient_not_meta_json)
    assert bc.id.resource_type === "patient"
    assert bc.id.id === "1"
  end

  defp patient_json do
    """
    {
      "resourceType" : "patient",
      "id" : "1",
      "meta" : {
        "versionId" : "2",
        "lastUpdated" : "2015-01-01"
      }
    }
    """
  end

  defp patient_not_meta_json do
    """
    {
      "resourceType" : "patient",
      "id" : "1"
    }
    """
  end

end
