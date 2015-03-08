defmodule ExFhir.Model.ResourceIdTest do
  use ExUnit.Case
  alias ExFhir.Model.ResourceId, as: ResourceId

  test "build creates correct id" do
    id = ResourceId.build("http://localhost", "patient", "1", "2")
    assert id.baseuri === "http://localhost"
    assert id.resource_type === "patient"
    assert id.id === "1"
    assert id.version === "2"
  end

end
