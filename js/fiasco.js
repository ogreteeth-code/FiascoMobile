function loadHomeScreen() {
	homescreen(1);
	$('#IOSContainer').load('tmpl/_homescreen.tmpl.html');

	setTimeout(function(){scrollTo(0,0)},1);
}

function loadAboutApp() {
	homescreen(2);
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
	homescreen(3);
	$.getJSON("playsets/" + title,function(data) {$("#playsetProper").tmpl(data).replaceAll("#IOSContainer");});
}

function homescreen(reset) {
	reset ? storeValue = reset : storeValue ? storeValue : storeValue = 0;
	// console.log(storeValue);
	return storeValue;
}

function buildTogglePreviewModeHandler() {
  var mode = 'cover';

  return function() {
    $('.playsetPreviews').removeClass('previewMode-' + mode);

    if (mode  == 'name') {
      mode = 'cover';
    } else if (mode == 'cover') {
      mode = 'name';
    }

    $('.playsetPreviews').addClass('previewMode-' + mode);
  }
}

function getPlayset(playset) {
	homescreen(2);
	currentPlayset = playset;
	// console.log(playset);
	title = {"filename": playset};
	$.getJSON("playsets/" + playset,function(data) {data = merge(title, data); $("#playsetTitleScreen").tmpl(data).replaceAll("#IOSContainer");});
	setTimeout(function(){scrollTo(0,0)},1);
}

function onPhoneReady(){ 
  document.addEventListener("backbutton", catchback, false);   // function(){ //hardware backbutton}
} 

function catchback(){
// You can call this function from a console to simulate the Android "Back" button!
  	if (homescreen() == 1) {
		// alert("exiting navigator");
		navigator.app.exitApp()
		
  	} else if (homescreen() == 2) {
	    loadHomeScreen();
  	} else if (homescreen() == 3) {
  		getPlayset(currentPlayset);
  	}
	$(document).bind("deviceready", onPhoneReady); //when phone is ready 
}

function merge(o, ob) {;var i = 0;for (var z in ob) {if (ob.hasOwnProperty(z)) {o[z] = ob[z];}}return o;}

function advanceCover(direction) {
  var $selected = $('.playsets .playsetList.selected');

  var $next;

  if (direction == 'right') {
    $next = $selected.prevAll('.playsetList:not(.disable)').first();
  } else { // left
    $next = $selected.nextAll('.playsetList:not(.disable)').first();
  }

  if ($next.length > 0) {
    $selected.removeClass('selected');
    $next.addClass('selected');
  }
}

function onSwipeCover(event) {
  if (event.type == 'swiperight') {
    advanceCover('right')
  } else {
    advanceCover('left')
  }
}

$.get('tmpl/_playsetTitleScreen.tmpl.html', function(templates) {$('body').append(templates);});
$.get('tmpl/_playsetProper.tmpl.html', function(templates) {$('body').append(templates);});

$(document).ready(function(){
	var x=location.search.split("?")[1];
	if(x) {
		getPlayset(x+".json");
	} else {
	    loadHomeScreen();
	}

  $('body').on('click', '.togglePreviewMode', buildTogglePreviewModeHandler());
  $('body').on('swiperight', '.playsetList', onSwipeCover);
  $('body').on('swipeleft', '.playsetList', onSwipeCover);

	//load the android back button catcher.
	document.addEventListener("deviceready", onPhoneReady, false);
});
