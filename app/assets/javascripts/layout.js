$(document).ready($(function () {
	// appointment accordion
    $(".accordions").click(function () {
    	accordion = $(this).next(".accordion")
    	console.log(accordion)
    	// accordion.siblings(".accordion").removeClass("current");
    	// accordion.siblings(".accordion").children(".appointments").slideUp("fast");
    	accordion.toggleClass("current");
    	accordion.slideToggle("fast")
    });
}));