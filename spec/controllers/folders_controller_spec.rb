require 'spec_helper'

describe FoldersController do

  let(:user) { FactoryGirl.create(:user) }
  let!(:folder) { FactoryGirl.create(:folder, user_id: user.id, sequence: 1) }

  describe "#new" do
    before do
      Folder.should_receive(:new).and_return(folder)
      get :new
    end

    it { assigns(:folder).should_not be_nil }
  end
end
