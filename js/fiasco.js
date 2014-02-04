function handleOpenURL(url) {
    window.setTimeout(function () {
        window.alert('handleOpenURL: ' + url);       
		var y=url.search.split("?")[1];
		if(y) {
	
			$(document).ready(function(){
				getPlayset(x+".json");
			});
		}	
		alert(url);
    }, 1000);
}



function loadHomeScreen() {
	$('#IOSContainer').load('tmpl/_homescreen.tmpl.html');
	setTimeout(function(){scrollTo(0,0)},1);
}

function loadAboutApp() {
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
	$.getJSON("playsets/" + title,function(data) {$("#playsetProper").tmpl(data).replaceAll("#IOSContainer");});
}

function getPlayset(playset) {
	// console.log(playset);
	title = {"filename": playset};
	$.getJSON("playsets/" + playset,function(data) {data = title.merge(data); $("#playsetTitleScreen").tmpl(data).replaceAll("#IOSContainer");});
	setTimeout(function(){scrollTo(0,0)},1);
}

Object.prototype.merge = (function (ob) {var o = this;var i = 0;for (var z in ob) {if (ob.hasOwnProperty(z)) {o[z] = ob[z];}}return o;});

$.get('tmpl/_playsetTitleScreen.tmpl.html', function(templates) {$('body').append(templates);});
$.get('tmpl/_playsetProper.tmpl.html', function(templates) {$('body').append(templates);});

document.addEventListener("deviceready", onDeviceReady, false);

function onDeviceReady() {
    if ('invokeString' in window) {
        window.alert('onDeviceReady: ' + invokeString);
    } else {
        window.alert('onDeviceReady: no invokeString');
    }    
}

$(document).ready(function(){
	alert('Seed is ' + window.Invoke_params.seed);
	
	var x=location.search.split("?")[1];
	if(x) {
		//alert(x);
		getPlayset(x+".json");
	} else {
		// alert("no playset passed");
		$('#IOSContainer').load('tmpl/_homescreen.tmpl.html');
	}
});