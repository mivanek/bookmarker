class Folder < ActiveRecord::Base
  attr_accessible :name, :user_id

  belongs_to :user
  has_many :bookmarks

  before_save :add_sequence

  private

    def add_sequence
      if self.sequence.nil?
        last_sequence = Folder.order(:sequence).last.sequence
        self.sequence = 1 + (last_sequence.nil? ? 0 : last_sequence)
      end
    end
end
