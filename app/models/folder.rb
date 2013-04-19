class Folder < ActiveRecord::Base
  attr_accessible :name, :user_id

  belongs_to :user
  has_many :bookmarks

  before_save :add_sequence

  private

    def add_sequence
      if self.sequence.nil?
        folder = Folder.order(:sequence).last
        if folder
          last_sequence = folder.sequence
          self.sequence = 1 + (last_sequence.nil? ? 0 : last_sequence)
        else
          self.sequence = 1
        end
      end
    end
end
