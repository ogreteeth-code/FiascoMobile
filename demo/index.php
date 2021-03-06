<!DOCTYPE html>
<html>
<head>
<?php

function curPageURL() {
 $pageURL = 'http';
 if ($_SERVER["HTTPS"] == "on") {$pageURL .= "s";}
 $pageURL .= "://";
 if ($_SERVER["SERVER_PORT"] != "80") {
  $pageURL .= $_SERVER["SERVER_NAME"].":".$_SERVER["SERVER_PORT"].$_SERVER["REQUEST_URI"];
 } else {
  $pageURL .= $_SERVER["SERVER_NAME"].$_SERVER["REQUEST_URI"];
 }
  if(preg_match("/brooklynindie/", $pageURL)) {
    return "<base href=\"http://brooklynindiegames.com/fm/\">";
  } else if(preg_match("/fiascomobile.com/", $pageURL)) {
    return "<base href=\"http://fiascomobile.com/\">";
  } else {
    return "<base href=\"http://fiascomobile.ogreteeth.com\">";
  }
}

echo curPageURL();

?>

<link href="http://fonts.googleapis.com/css?family=Syncopate:400,700%7CMetrophobic" rel="stylesheet" type="text/css">
<script type="text/javascript" src="js/jquery-1.4.3.min.js"></script>
<script type="text/javascript" src="js/jquery.tmpl.min.js"></script>
<script id="playsetTitleScreen" type="text/x-jquery-tmpl">
	<div id="IOSContainer">
		<h1>${playset.title}</h1>
		<div id="bodyContainer">
		<h2>By ${playset.credits.author}</h2>
		
		
		<h3>The Score</h3>
		{{each playset.score.paragraphs}}
		<p>${$value}</p>
		{{/each}}

		<img src="img/fiascofuse.png">
		<h3>Movie Night</h3>
		<p>{{each playset.movie_night}}${title}. {{/each}}</p>

		<div id="playnow" onClick="loadJSONPlayset('${filename}')">Play Now</div>
		</div>
	</div>
</script>
<script id="playsetProper" type="text/x-jquery-tmpl">
<div id="IOSContainer">
	<h1>${playset.title}</h1>
	<div class="playset">

		{{if playset.relationships}}
		<h2 class="playsetList" onClick="subSwap('subRelationships')">Relationships</h2>
		<div id="subRelationships" style="display: none;" class="L0"><ol class="L1">
		{{each(i, item) playset.relationships}}
			<li onClick="subSwap('relationships${i}')">${item.title}</li>
			<div id="relationships${i}" style="display: none;">
				<ul class="L2">{{each(i, item) elements}}<li><img src="img/d${i+1}.png" alt="${i+1}"> ${item}</li>{{/each}}</ul>
			</div>
		{{/each}}</ol>
		</div>
		{{/if}}

		{{if playset.needs}}
		<h2 class="playsetList" onClick="subSwap('subNeeds')">Needs</h2>
		<div id="subNeeds" style="display: none;" class="L0"><ol class="L1">
		{{each(i, item) playset.needs}}
			<li onClick="subSwap('needs${i}')">${item.title}</li>
			<div id="needs${i}" style="display: none;">
				<ul class="L2">{{each(i, item) elements}}<li><img src="img/d${i+1}.png" alt="${i+1}"> ${item}</li>{{/each}}</ul>
			</div>
		{{/each}}</ol>
		</div>
		{{/if}}
		
		{{if playset.locations}}
		<h2 class="playsetList" onClick="subSwap('subLocations')">Locations</h2>
		<div id="subLocations" style="display: none;" class="L0"><ol class="L1">
		{{each(i, item) playset.locations}}
			<li onClick="subSwap('locations${i}')">${item.title}</li>
			<div id="locations${i}" style="display: none;">
				<ul class="L2">{{each(i, item) elements}}<li><img src="img/d${i+1}.png" alt="${i+1}"> ${item}</li>{{/each}}</ul>
			</div>
		{{/each}}</ol>
		</div>
		{{/if}}
		
		{{if playset.events}}
		<h2 class="playsetList" onClick="subSwap('subEvents')">Events</h2>
		<div id="subEvents" style="display: none;" class="L0"><ol class="L1">
		{{each(i, item) playset.events}}
			<li onClick="subSwap('events${i}')">${item.title}</li>
			<div id="events${i}" style="display: none;">
				<ul class="L2">{{each(i, item) elements}}<li><img src="img/d${i+1}.png" alt="${i+1}"> ${item}</li>{{/each}}</ul>
			</div>
		{{/each}}</ol>
		</div>
		{{/if}}

		{{if playset.moments}}
		<h2 class="playsetList" onClick="subSwap('subMoments')">Moments</h2>
		<div id="subMoments" style="display: none;" class="L0"><ol class="L1">
		{{each(i, item) playset.moments}}
			<li onClick="subSwap('moments${i}')">${item.title}</li>
			<div id="moments${i}" style="display: none;">
				<ul class="L2">{{each(i, item) elements}}<li><img src="img/d${i+1}.png" alt="${i+1}"> ${item}</li>{{/each}}</ul>
			</div>
		{{/each}}</ol>
		</div>
		{{/if}}

		{{if playset.objects}}
		<h2 class="playsetList" onClick="subSwap('subObjects')">Objects</h2>
		<div id="subObjects" style="display: none;" class="L0"><ol class="L1">
		{{each(i, item) playset.objects}}
			<li onClick="subSwap('objects${i}')">${item.title}</li>
			<div id="objects${i}" style="display: none;">
				<ul class="L2">{{each(i, item) elements}}<li><img src="img/d${i+1}.png" alt="${i+1}"> ${item}</li>{{/each}}</ul>
			</div>
		{{/each}}</ol>
		</div>
		{{/if}}
	</div>
	<h1 class="footer">...${playset.score.tagline}</h1>

</div>
</script>
<script src="demo/fiascoDemo.js"></script>

	<meta charset="UTF-8">
    <meta name="viewport" content="user-scalable=no, width=device-width, initial-scale=1, maximum-scale=1" />
    <meta name="apple-mobile-web-app-capable" content="yes" />

    <meta name="apple-mobile-web-app-status-bar-style" content="black" />

    <link rel="apple-touch-icon" href="img/apple-touch-icon.png" />
    
	<link rel="apple-touch-startup-image" href="img/768x1004-opener.png" media="screen and (min-device-width: 481px) and (max-device-width: 1024px) and (orientation:portrait)" />
	<link rel="apple-touch-startup-image" href="img/1024x748-opener.png" media="screen and (min-device-width: 481px) and (max-device-width: 1024px) and (orientation:landscape)" />
	<link rel="apple-touch-startup-image" href="img/320x460-opener.png" media="screen and (min-device-width: 200px) and (max-device-width: 320) and (orientation:portrait)" />
	
    <link rel="stylesheet" href="fm.css" type="text/css" media="screen, mobile" title="main">

	<title>FiascoMobile Demo</title>
	<!-- Mobile Edition Window -->
</head>
<body>
<nav><img src="img/header.png" alt="Fiasco Mobile" onClick="loadHomeScreen()" /></nav>

<div id="IOSContainer">
</div>
</body>
</html>
