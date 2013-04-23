require 'spec_helper'


describe Folder do
  let(:user) { FactoryGirl.create(:user) }

  before do
    @folder = Folder.new(name: "Test folder", user_id: user.id)
  end

  subject { @folder }

  it { should respond_to(:name) }
  it { should respond_to(:user_id) }
  it { should respond_to(:sequence) }

  it "the name should not be empty" do
    ["", " ", nil].each do |name|
      @folder.name = name
      should_not be_valid
    end
  end

  it "sequence should not be empty" do
    ["", " ", nil].each do |sequence|
      @folder.sequence = sequence
      should_not be_valid
    end
  end

  it "user id should not be empty" do
    ["", " ", nil].each do |user_id|
       @folder.user_id = user_id
       should_not be_valid
    end
  end
end
