defmodule ExFhir.Model.InMemoryFhirRepo.Test do
  use ExUnit.Case
  alias ExFhir.FhirRepo, as: Repo
  alias ExFhir.Model.Resource, as: Resource

  test "insert resource adds resource to db" do
    p1 = Resource.create("patient") |> Repo.insert
    p2 = Resource.create("patient") |> Repo.insert

    assert p1["resourceType"] === "patient"
    assert p1["id"] === "1"
    assert p1["meta"]["versionId"] === "1"

    assert p2["resourceType"] === "patient"
    assert p2["id"] === "2"
    assert p2["meta"]["versionId"] === "1"
  end

  test "update resource assigns correct version id" do
    patient = Resource.create("patient") |> Repo.insert |> Repo.update
    id = Resource.get_identity(patient)
    assert id.id === "1"
    assert id.vid === "2"
  end

  test "get all returns existing resources" do
    ["Patient", "Questionnaire", "QuestionnaireAnswers"]
    |> Enum.map(&(Resource.create(&1)))
    |> Enum.map(&(Repo.insert(&1)))

    patients = Repo.get_all("patient")
    assert Enum.count(patients) == 1

    questionnaires = Repo.get_all("QuestiOnnaire")
    assert Enum.count(questionnaires) == 1

    answers = Repo.get_all("QuestionNaireanswers")
    assert Enum.count(answers) == 1
  end
end
