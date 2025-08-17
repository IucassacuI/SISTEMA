class Announcement < ApplicationRecord
	validates :text, presence: true, length: {maximum: 100}
end
