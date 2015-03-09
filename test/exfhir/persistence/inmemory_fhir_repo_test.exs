defmodule ExFhir.Model.InMemoryFhirRepo.Test do
  use ExUnit.Case
  alias ExFhir.FhirRepo, as: Repo
  alias ExFhir.Model.Resource, as: Resource

  test "insert resource adds resource to db" do
    resource =
    "patient"
    |> Resource.create
    |> Repo.insert

    assert resource["resourceType"] === "patient"
    assert resource["id"] === "1"
    assert resource["meta"]["versionId"] === "1"
  end

  test "get all returns existing resources" do
    ["Patient", "Questionnaire", "QuestionnaireAnswers"]
    |> Enum.map(&(Resource.create(&1)))
    |> Enum.map(&(Repo.insert(&1)))

    patients = Repo.get_all("patient")
    assert patients !== nil

    questionnaires = Repo.get_all("QuestiOnnaire")
    assert questionnaires !== nil

    answers = Repo.get_all("QuestionNaireanswers")
    assert answers !== nil
  end
end
