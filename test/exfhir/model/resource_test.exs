defmodule ExFhir.Model.ResourceTest do
  use ExUnit.Case, async: true
  alias ExFhir.Model.Resource, as: Resource

  test "create resource returns correct map" do
    resource = Resource.create("patient")
    assert resource !== nil
    assert Dict.get(resource, "resourceType") === "patient"
  end

  test "with id populates resoure with correct key and value" do
    resource = "patient" |> Resource.create |> Resource.with_id("2")
    assert resource["id"] === "2"
  end

  test "with version populates resoure with correct key and value" do
    resource = "patient" |> Resource.create |> Resource.with_version("42")
    assert resource["meta"]["versionId"] === "42"
  end

  test "with meta with version id populates resoure with correct key and value" do
    resource = "patient" |> Resource.create |> Resource.with_meta(vid: "42")
    assert resource["meta"]["versionId"] === "42"
  end

  test "with meta with version id and last updated populates resoure with correct key and value" do
    resource = "patient" |> Resource.create |> Resource.with_meta(vid: "42", updated: "2015-03-05")
    assert resource["meta"]["versionId"] === "42"
    assert resource["meta"]["lastUpdated"] === "2015-03-05"
  end

  test "get logical id for resource with id returns id" do
    import Resource
    resource = create("patient") |> with_id("1")
    assert get_id(resource) === "1"
  end

  test "get logical id for resource without id returns empty string" do
    id = Resource.create("patient") |> Resource.get_id
    assert id === ""
  end

end
