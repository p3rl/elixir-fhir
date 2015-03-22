defmodule ExFhir.Service.FhirServiceTest do
  use ExUnit.Case
  alias ExFhir.FhirService, as: FhirService
  alias ExFhir.Model.Resource, as: Resource

  test "Create resource with mismatch resource type returns error and reason" do
    {:error, reason} = FhirService.create_resource("", Resource.create("patient"))
    assert reason !== ""
  end
end
