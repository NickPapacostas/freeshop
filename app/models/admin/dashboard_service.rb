class Admin::DashboardService
	def checkout_items_by_week(weeks = 3)
		this_week_start = Date.today.beginning_of_week
		end_of_week = Date.today.end_of_week

		weeks.times.map do |week|
			{
				start: this_week_start - week.weeks,
				end_of_week: end_of_week - week.weeks
			}.reverse
		end
	end

	def checkout_items_by_day(days = 14)
		CheckoutItem.group_by_day(:created_at).sum(:count)
	end
end