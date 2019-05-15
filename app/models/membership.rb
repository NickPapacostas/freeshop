class Membership < ApplicationRecord
	has_many :members, -> { order(:id) }, dependent: :destroy

	has_many :appointments
	has_many :checkouts, through: :appointments

	has_one :point_of_contact, class_name: 'Member'


	attr_accessor :skip_point_of_contact
	after_create :insure_point_of_contact

	accepts_nested_attributes_for :members, allow_destroy: true

  validates :members, presence: true
	validates_presence_of :number
	validates_uniqueness_of :number

	def self.next_membership_number
		Membership.order(:number).last.number +  1
	end

	def name
		point_of_contact.full_name
	end

	def past_appointments
		appointments.where('datetime < ?', DateTime.now)
	end

	def upcoming_appointments
		appointments.where(attended: false).where('datetime > ?', DateTime.now)
	end

	def point_of_contact
		members.find { |m| m.id == point_of_contact_id }
	end

	def insure_point_of_contact
		unless skip_point_of_contact
			self.point_of_contact_id = members.first.id if point_of_contact_id.nil?
			self.save
		end
	end

	def has_one_member
	  errors.add(:base, 'must add at least one member') if self.members.empty?
	end

	def item_totals
		totals = Hash.new(0)
		checkout_totals = checkouts.map(&:item_totals)
		checkout_totals.each do |totals_hash|
			totals_hash.each do |item, count|
				totals[item] = totals[item] + count
			end
		end
		totals.sort_by {|key, value| -value}
	end

end
