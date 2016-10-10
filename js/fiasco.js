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
	// console.log("storeValue: " + storeValue);
	return storeValue;
}

function buildTogglePreviewModeHandler() {
  var mode = 'name';

  function swapModes() {
    $('body').removeClass('previewMode-' + mode);
//-----------------
    $show_all_playsets = $('.playsets .playsetList');
    var arrayLength = $show_all_playsets.length;
	for (var i = 0; i < arrayLength; i++) {
      if ($show_all_playsets[i].style.display == "none") {
      	$show_all_playsets[i].style.display = "";
      }
	}
//-----------------
    if (mode  == 'name') {
      mode = 'cover';
    } else if (mode == 'cover') {
      mode = 'name';
    }

    $('body').addClass('previewMode-' + mode);
  }

  return function() {
  	
    if (homescreen() == 1) { // Only changes modes if we're already on the home screen
      console.log("homescreen: " + homescreen());
      console.log("swapping modes")
      swapModes();
    } else {
      console.log("homescreen: " + homescreen())
      console.log("loading homescreen")      
      loadHomeScreen();
    }
    return false;
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
		android ? navigator.app.exitApp() : false;
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
    var otherDirection = 'left';
    $next = $selected.prevAll('.playsetList:not(.disable)').first();
  } else { // left
    var otherDirection = 'right';
    $next = $selected.nextAll('.playsetList:not(.disable)').first();
  }

  if ($next.length > 0) {
    $selected.hide("slide", { direction: direction }, function() {
      $selected.removeClass('selected');
      $next.hide();
      $next.addClass('selected');
      $next.show("slide", { direction: otherDirection });
    });
  }
}

function onSwipeCover(event) {
  if (! $('body').hasClass('previewMode-cover')) {
    return;
  }

  if (event.type == 'swiperight') {
    advanceCover('right')
  } else {
    advanceCover('left')
  }

  return false;
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
  $('body').on('click', '.playsets .coverArrow.nextCover', function() { return onSwipeCover('right'); });
  $('body').on('click', '.playsets .coverArrow.previousCover', function() { return onSwipeCover('left'); });

	//load the android back button catcher.
	document.addEventListener("deviceready", onPhoneReady, false);
});
