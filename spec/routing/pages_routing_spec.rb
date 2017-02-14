require "spec_helper"

describe PagesController do
  describe "routing" do

    it "routes to #show" do
      get("/pages/privacy-policy").should route_to("pages#show", :id => "privacy-policy")
    end

    it "does not route to #index" do
      get("/pages").should_not route_to("pages#index")
    end

    it "does not route to #new" do
      get("/pages/new").should_not route_to("pages#new")
    end

    it "does not route to #edit" do
      get("/pages/1/edit").should_not route_to("pages#edit", :id => "1")
    end

    it "does not route to #create" do
      post("/pages").should_not route_to("pages#create")
    end

    it "does not route to #update" do
      put("/pages/1").should_not route_to("pages#update", :id => "1")
    end

    it "does not route to #destroy" do
      delete("/pages/1").should_not route_to("pages#destroy", :id => "1")
    end

  end
end
