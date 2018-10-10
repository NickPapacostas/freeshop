$ ->
	# mark point of contact
	parent = $("[id^=membership_members_attributes_0]").first().parent().parent();
	parent.children('.point_of_contact').removeClass('d-invisible')