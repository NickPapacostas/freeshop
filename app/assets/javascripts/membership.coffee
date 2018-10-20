$ ->
	members_tab = $('li.members-tab')
	appointments_tab = $('li.appointments-tab')
	members_tab.on('click', ->
		if (!members_tab.hasClass('active'))
			appointments_tab.removeClass('active')
			members_tab.addClass('active')
			$('.membership-form').removeClass('hide')
			$('.membership-appointments').addClass('hide'))
	appointments_tab.on('click', ->
		if (!appointments_tab.hasClass('active'))
			members_tab.removeClass('active')
			appointments_tab.addClass('active')
			$('.membership-form').addClass('hide')
			$('.membership-appointments').removeClass('hide'))