defmodule ExFhir.Router do
  use Phoenix.Router

  pipeline :browser do
    plug :accepts, ~w(html)
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
  end

  pipeline :api do
    plug :accepts, ~w(json)
  end

  scope "/", ExFhir do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/api", ExFhir do
    pipe_through :api
    get "/:resourcetype", FhirController, :get_all_resources
    get "/:resourcetype/:id", FhirController, :get_resource
    get "/:resourcetype/:id/_history/:version", FhirController, :get_resource_version
    post "/:resourcetype", FhirController, :create_resource
  end
end
