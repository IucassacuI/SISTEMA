class Message < ApplicationRecord
  belongs_to :user

  validates :text, presence: true, length: { maximum: 100 }

  after_create_commit -> { broadcast_append_to "chat" }
  after_destroy_commit -> { broadcast_remove_to "chat" }
  after_update_commit -> { broadcast_replace_to "chat" }
end
