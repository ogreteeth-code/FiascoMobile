function loadHomeScreen() {
	homescreen(1);
	$('#IOSContainer').load('tmpl/_homescreen.tmpl.html');
}

function loadAboutApp() {
	homescreen(2);
	$('#IOSContainer').load('tmpl/_aboutapp.tmpl.html');
	setTimeout(function(){scrollTo(0,0)},1);
}

function getPlayset(playset) {
	homescreen(2);
	console.log("getting playset")
	// currentPlayset = playset;
	title = {"filename": playset};
	$.getJSON("playsets/" + playset,function(data) {
		data = merge(title, data);
		$("#playsetTitleScreen").tmpl(data).replaceAll("#IOSContainer");
		setTimeout(function(){scrollTo(0,0)},1);});
}

function loadJSONPlayset(title) {
	homescreen(3);
	$.getJSON("playsets/" + title,function(data) {
		$("#playsetProper").tmpl(data).replaceAll("#IOSContainer");	
		});
}

// function loadXMLDoc(file,dom) {
	//f.loadAboutApp():  loadXMLDoc('tmpl/_aboutapp.tmpl.html');
	//var file = "tmpl/_homescreen.tmpl.html"
	//var dom = "IOSContainer"
    //var xmlhttp;
    //if (window.XMLHttpRequest) {
    //  xmlhttp = new XMLHttpRequest();
    //}
	//xmlhttp.onreadystatechange = function() {
    //  if (this.readyState == 4 && this.status == 200) {
    //    document.getElementById("IOSContainer").innerHTML = this.responseText;
    //  }
 // };
  
  //xmlhttp.open("GET", file, true);
  //xmlhttp.send();  

//}


function subSwap(folioID) {
	// folioID.nextElementSibling.style.display = ("show");
	folio = document.getElementById(folioID);
		if (folio.style.display == "none") {
		$(folio).slideDown("fast","swing");
		} else {
		$(folio).slideUp("fast","swing");
	}
}


function homescreen(reset) {
	reset ? storeValue = reset : storeValue ? storeValue : storeValue = 0;
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
      swapModes();
    } else {
      loadHomeScreen();
    }
    return false;
  }
}


function onPhoneReady(){ 
  document.addEventListener("backbutton", catchback, false);   // function(){ //hardware backbutton}
} 

function catchback(){
// You can call this function from a console to simulate the Android "Back" button!
  	if (homescreen() == 1) {
		// alert("exiting navigator");
		// alert(device.platform);
		// device.platform == "Android" ? navigator.app.exitApp() : false;
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
	document.querySelector(".navigation").addEventListener("click", catchback, false);

 // onClick="catchback();" 

	var x=location.search.split("?")[1];
	if(x) {
		getPlayset(x+".json");
	} else {
	    loadHomeScreen();
	    // getPlayset('tester.json');
	}


  $('body').on('click', '.togglePreviewMode', buildTogglePreviewModeHandler());
  $('body').on('swiperight', '.playsetList', onSwipeCover);
  $('body').on('swipeleft', '.playsetList', onSwipeCover);
  $('body').on('click', '.playsets .nextCover', function() { return onSwipeCover('right'); });
  $('body').on('click', '.playsets .previousCover', function() { return onSwipeCover('left'); });

  //load the android back button catcher.
  document.addEventListener("deviceready", onPhoneReady, false);
});
