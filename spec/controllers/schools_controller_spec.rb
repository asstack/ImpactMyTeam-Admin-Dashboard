require 'spec_helper'

describe SchoolsController do

  describe "GET 'index'" do
    let!(:school) { Fabricate(:school) }

    context 'with default params' do
      before { get :index }

      it { should respond_with :success }
      specify { assigns(:schools).should be_empty }
    end

    context 'with search terms' do
      let!(:robin) { Fabricate(:school, name: 'Batman and Robin', city: 'Van Buren', region: 'North Dakota') }
      let!(:alfred) { Fabricate(:school, name: 'Batman and Alfred', city: 'Art Van', region: 'West Dakota') }
      let!(:neither) { Fabricate(:school, name: 'Super', city: 'Grand Rapids', region: 'Michigan') }

      context 'full words across attributes' do
        before { get :index, query: 'Batman Van Dakota' }

        it { should respond_with :success }
        specify { assigns(:schools).should =~ [robin, alfred] }
        specify { controller.schools.first.should be_decorated_with SchoolDecorator }
      end
    end
  end

  describe "GET 'index.json'" do
    let!(:school) { Fabricate(:school) }
    before { get :index, format: :json }
    it { should respond_with :success }
  end

  describe "GET 'show'" do
    let(:school) { Fabricate(:school_full) }
    before { get :show, id: school.id }

    it { should respond_with :success }
    specify { assigns(:school).should == school }
    specify { controller.school.should be_decorated_with SchoolDecorator }
  end

  describe "GET 'show.json'" do
    let(:school) { Fabricate(:school_full) }
    before { get :show, id: school.id, format: :json }
    it { should respond_with :success }
  end

  describe "GET 'new'" do
    let!(:user) { login Fabricate(:user) }
    before { get :new }

    specify { assigns(:school).should be_a_new(School) }
    specify { assigns(:default_address).should be_a_new(SchoolAddress) }
    specify { assigns(:primary_contact).should be_a_new(SchoolContact) }
    specify { assigns(:school_role).should be_a_new(SchoolRole) }
  end

  describe "POST create" do
    let!(:user) { login Fabricate(:user) }
    let(:valid_attributes) { Fabricate.attributes_for(:school) }

    describe "with valid params" do
      it "creates a new School" do
        expect {
          post :create, {school: valid_attributes}
        }.to change(School, :count).by(1)
      end

      it "assigns a newly created school as @school" do
        post :create, {school: valid_attributes}
        assigns(:school).should be_a(School)
        assigns(:school).should be_persisted
      end

      it "redirects to the created school" do
        post :create, {school: valid_attributes}
        response.should redirect_to(assigns(:school))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved school as @school" do
        # Trigger the behavior that occurs when invalid params are submitted
        post :create, {school: { "name" => "invalid value" }}
        assigns(:school).should be_a_new(School)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        post :create, {school: { "name" => "invalid value" }}
        response.should render_template("new")
      end
    end
  end

  describe "GET 'edit'" do
    let!(:user) { login Fabricate(:user) }
    let!(:school) { Fabricate(:school) }

    before do
      user.school_roles.for_school(school).create(name: 'school_admin').tap(&:verify!)
      get :edit, id: school.id
    end

    specify { assigns(:school).should == school }
    specify { assigns(:default_address).should_not be_nil }
    specify { assigns(:primary_contact).should_not be_nil }
  end

  describe "PUT update" do
    let!(:user) { login Fabricate(:user) }
    let!(:school) { Fabricate(:school) }
    let!(:role) { user.school_roles.for_school(school).create(name: 'school_admin').tap(&:verify!) }

    let(:valid_attributes) { {name: 'Updated School Name'} }

    describe "with valid params" do
      it "updates the requested school" do
        # Assuming there are no other schools in the database, this
        # specifies that the School created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        School.any_instance.should_receive(:update_attributes)
          .with({ "name" => "MyString"})
        put :update, {id: school.id, school: { "name" => "MyString" }}
      end

      it "assigns the requested school as @school" do
        put :update, {id: school.id, school: valid_attributes}
        assigns(:school).should eq(school)
      end

      it "redirects to the school" do
        put :update, {id: school.id, school: valid_attributes}
        response.should redirect_to(school)
      end
    end

    describe "with invalid params" do
      it "assigns the school as @school" do
        # Trigger the behavior that occurs when invalid params are submitted
        School.any_instance.stub(:save).and_return(false)
        put :update, {id: school.id, school: { "name" => "invalid value" }}
        assigns(:school).should eq(school)
      end

      it "re-renders the 'edit' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        School.any_instance.stub(:save).and_return(false)
        put :update, {id: school.id, school: { "name" => "invalid value" }}
        response.should render_template("edit")
      end
    end
  end

end
