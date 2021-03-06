require 'spec_helper'

describe Api::OffersController do
  let(:offer) { FactoryGirl.create(:offer) }

  describe "GET index" do
    it "retrieves all offers" do
      offer
      get :index
      offers = JSON.parse(response.body)
      offers.count.should == 1
      offers.first["id"].should == offer.id
    end

    it "retrieve offers picking up at a place" do
      offer
      get :index, :source_place_id => FactoryGirl.create(:place).id
      offers = JSON.parse(response.body)
      offers.count.should == 0
      get :index, :source_place_id => offer.source_place.id
      offers = JSON.parse(response.body)
      offers.first["id"].should == offer.id
    end

    it "retrieve offers dropping of at a place" do
      offer
      get :index, :arrival_place_id => FactoryGirl.create(:place).id
      offers = JSON.parse(response.body)
      offers.count.should == 0
      get :index, :arrival_place_id => offer.arrival_place.id
      offers = JSON.parse(response.body)
      offers.first["id"].should == offer.id
    end
  end

  describe "POST create" do
    let(:from) { FactoryGirl.create(:place) }
    let(:to) { FactoryGirl.create(:place) }

    it "creates a new offer" do
      sign_in FactoryGirl.create(:user)
      post :create, {:offer => {:source_place_id => from.id,
                                 :arrival_place_id => to.id }}
      e = JSON.parse(response.body)
      e["source_place_id"].should == from.id
      e["arrival_place_id"].should == to.id
      from.offers_departing.first.id.should == e["id"]
      to.offers_arriving.first.id.should == e["id"]
    end

    it "fails when no user logged in" do
      post :create, {:offer => {:source_place_id => from.id,
                                 :arrival_place_id => to.id }}
      response.status.should == 401
    end
  end

  describe "PUT update" do
    it "updates an existing offer" do
      offer.summary.should_not == "Stewie"
      sign_in offer.courier
      put :update, :id => offer.id, :offer => {:summary => "Stewie"}
      e = JSON.parse(response.body)
      e["id"].should == offer.id
      e["summary"].should == "Stewie"
      offer.reload.summary.should == "Stewie"
    end

    it "fails when no user logged in" do
      put :update, :id => offer.id, :offer => {:summary => "Stewie"}
      response.status.should == 401
    end
  end

  describe "DELETE destroy" do
    it "destroys an existing offer" do
      sign_in offer.courier
      delete :destroy, :id => offer.id
      response.should be_success
      Errand.find_by_id(offer.id).should be_nil
    end

    it "fails when no user logged in" do
      delete :destroy, :id => offer.id
      response.status.should == 401
    end
  end

  describe "GET show" do
    it "fetches a single offer" do
      get :show, :id => offer.id
      JSON.parse(response.body)["id"].should == offer.id
    end
  end
end
