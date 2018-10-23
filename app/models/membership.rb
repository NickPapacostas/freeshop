class Membership < ApplicationRecord
	has_many :members
	has_many :appointments

	has_one :point_of_contact, class_name: 'Member'

	after_create :insure_point_of_contact

	accepts_nested_attributes_for :members, allow_destroy: true

	def self.next_membership_number
		Membership.order(:number).last.number +  1
	end

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

	def insure_point_of_contact
		self.point_of_contact_id = members.first.id if point_of_contact_id.nil?
	end


end
