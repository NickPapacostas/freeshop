class Membership < ApplicationRecord
	has_many :members
	has_many :appointments

	has_one :point_of_contact, class_name: 'Member'

	accepts_nested_attributes_for :members, allow_destroy: true

	def name
		point_of_contact.full_name
	end

	def completed_appointments
		appointments.where(attended: true)
	end

	def upcoming_appointments
		appointments.where(attended: false).where('datetime > ?', DateTime.now)
	end

	def point_of_contact
		members.find { |m| m.id == point_of_contact_id }
	end
end
