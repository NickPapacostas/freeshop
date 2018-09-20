class Membership < ApplicationRecord
	has_many :members

	has_one :point_of_contact, class_name: 'Member'

	accepts_nested_attributes_for :members, allow_destroy: true
end
