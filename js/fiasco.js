function loadHomeScreen() {
	document.getElementById("homescreen").setAttribute("value","0");
	$('#IOSContainer').load('tmpl/_homescreen.tmpl.html');
	setTimeout(function(){scrollTo(0,0)},1);
}

function loadAboutApp() {
	document.getElementById("homescreen").setAttribute("value","-1");
	$('#IOSContainer').load('tmpl/_aboutapp.tmpl.html');
	setTimeout(function(){scrollTo(0,0)},1);
}

function subSwap(folioID) {
	folio = document.getElementById(folioID);
	if (folio.style.display == "none") { 
		$(folio).slideDown("fast","swing");
		} else {
		$(folio).slideUp("fast","swing");
	}
}

function loadJSONPlayset(title) {
	document.getElementById("homescreen").setAttribute("value","-2");
	$.getJSON("playsets/" + title,function(data) {$("#playsetProper").tmpl(data).replaceAll("#IOSContainer");});
}

function getPlayset(playset) {
	document.getElementById("homescreen").setAttribute("value","-1");
	currentPlayset = playset;
	// console.log(playset);
	title = {"filename": playset};
	$.getJSON("playsets/" + playset,function(data) {data = title.merge(data); $("#playsetTitleScreen").tmpl(data).replaceAll("#IOSContainer");});
	setTimeout(function(){scrollTo(0,0)},1);
}

function onPhoneReady(){ 
  document.addEventListener("backbutton", function(){ //hardware backbutton
	var homescreen = document.getElementById("homescreen").getAttribute("value");
	alert(homescreen);
  	if (homescreen == 0) {
  		return true;
  	} else if (homescreen == -2) {
  		alert("homescreen == -2");
  		getPlayset(currentPlayset);
  		return false;
  	} else {
  		// alert("return home now");
	    loadHomeScreen();
	    return false;
  	}
  	
/*
    loadHomeScreen();
    return false; //prevents default behaviour 
*/

  }, false); 
} 

function catchback(){
	$(document).bind("deviceready", onPhoneReady); //when phone is ready 
}


Object.prototype.merge = (function (ob) {var o = this;var i = 0;for (var z in ob) {if (ob.hasOwnProperty(z)) {o[z] = ob[z];}}return o;});

$.get('tmpl/_playsetTitleScreen.tmpl.html', function(templates) {$('body').append(templates);});
$.get('tmpl/_playsetProper.tmpl.html', function(templates) {$('body').append(templates);});

var homescreen = 0;

$(document).ready(function(){
	var x=location.search.split("?")[1];
	if(x) {
		getPlayset(x+".json");
	} else {
		$('#IOSContainer').load('tmpl/_homescreen.tmpl.html');
	}
	//load the android back button catcher.
	document.addEventListener("deviceready", onPhoneReady, false);
});

