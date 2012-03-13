// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require_tree .


$(document).ready(function() {
	// alert('Handler for .change() called.');
	$("#domain_favicon_path").keypress(function() {
		previewFavicon();
	});
	$("#domain_url").keypress(function() {
		previewFavicon();
	});
	
	// iframeLoader();
});

function previewFavicon() {
	src = $("#domain_url").val() + "/" + $("#domain_favicon_path").val();
	$("#favicon_preview").attr("src", src);
}; 


function iframeLoader(body){
	$("#iframe").contents(body);
}