class Note < ActiveRecord::Base
  belongs_to :annotate, :polymorphic => true

  validates :note, :presence => true
end
# == Schema Information
#
# Table name: notes
#
#  id            :integer         not null, primary key
#  annotate_id   :integer
#  annotate_type :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  note          :text
#  private       :                default("t")
#

