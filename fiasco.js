function loadHomeScreen() { $('#IOSContainer').load('homescreen.html');}
function loadAboutApp() { $('#IOSContainer').load('aboutapp.html');}
function subSwap(folioID) {
	folio = document.getElementById(folioID);
	if (folio.style.display == "none") { 
		$(folio).slideDown("fast","swing");
		} else {
		$(folio).slideUp("fast","swing");
	}
}

function loadPlayset(title) {
	$('#IOSContainer').load('playsets/' + title + '.html');
}

function loadJSONPlayset(title) {
	$.getJSON("playsets/" + title,function(data) {$("#playsetProper").tmpl(data).replaceAll("#IOSContainer");});
}

function getPlayset(playset) {
	// console.log(playset);
	title = {"filename": playset};
	$.getJSON("playsets/" + playset,function(data) { data = title.merge(data); $("#playsetTitleScreen").tmpl(data).replaceAll("#IOSContainer");});
}

Object.prototype.merge = (function (ob) {var o = this;var i = 0;for (var z in ob) {if (ob.hasOwnProperty(z)) {o[z] = ob[z];}}return o;});
$(document).ready(function(){$('#IOSContainer').load('homescreen.html');});
