require 'spec_helper'


describe Folder do
  let(:user) { FactoryGirl.create(:user) }

  before do
    @folder = Folder.new(name: "Test folder", user_id: user.id)
  end

  def blank
    ["", " ", nil]
  end

  subject { @folder }

  it { should respond_to(:name) }
  it { should respond_to(:user_id) }
  it { should respond_to(:sequence) }

  it "the name should not be empty" do
    blank.each do |name|
      @folder.name = name
      should_not be_valid
    end
  end

  it "user id should not be empty" do
    blank.each do |user_id|
       @folder.user_id = user_id
       should_not be_valid
    end
  end

  describe "model should set sequence" do
    before do
      @folder_number = Folder.all.count
      @folder.save
    end
    it { @folder.sequence.should_not be_nil }
    # Have to account for default folders
    it { @folder.sequence.should == @folder_number + 1 }
  end


  describe "new folder should have the highest sequence" do
    before do
      @new_folder = @folder.dup
      @folder_number_old = Folder.all.count
      @folder.save
      @folder_number_new = Folder.all.count
      @new_folder.save
    end

    # Have to account for no_folder
    it { @folder.sequence.should == @folder_number_old + 1 }
    it { @new_folder.sequence.should == @folder_number_new + 1 }
  end
end
