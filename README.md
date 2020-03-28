FiascoMobile
============

Reads JSON formatted playsets and makes them available for mobile devices.

Todo:
* The multitude of category templates need to be refactored into an *actual* template.
* Playsets: Add more. Always.

Wishlist:
* Search by movie night
* Custom entries


# # #

2.0.0
* New Cover Browser feature!
+ Playset: Alpha Complex
+ Playset: Fist City
+ Playset: Flight 1180
+ Playset: Havana 1953
+ Playset: Hollywood Wives
+ Playset: No References Required
+ Playset: Old Aged Crisis
+ Playset: Rat Patrol
+ Playset: Reality Check Out
+ Playset: Salem 1692
+ Playset: Tartan Noir
+ Playset: Touring Rock Band 2
+ Playset: White Hole


* Current count: 85 playsets
* Update to PhoneGap multi-version build cli-9.0.0
* Changed "top field" navigation to work like the Android back button to back up a single level.
* Improvements to secondary subheads on the title page of a playset
* Changed "The Score" title to the flavorful version
* Bug: JS prevents display of playset accessed via cover-browsing mode
* Bug: browsing via cover, and returning (via catchback() function) hides browsed playset entries.
- Removed "Pen Show" playset per BPG request

(todo)
* Graphic Redesign
* App purchase now includes access to the website. Just fill in your email address.
-- perhaps isolate with cordova-device plugin and include device.uuid in coupon-related form submission.
* Feature: incremental navigation accessible via the top bar.
* Change icon to "return arrow" once you've navigated deeper into a playset (homescreen level 2,3)
* Change cover-mode navigation to return to selected playset when backing up.


1.2.5
+ Playset: #superheroes
+ Playset: 300 Crooks
+ Playset: Double Cross Country Dash
+ Playset: Echoes of the Lost City
+ Playset: Fortune and Glory
+ Playset: Hell's Highway
+ Playset: Little Town, Dark Woods
+ Playset: Reality Check
+ Playset: Resleeved
+ Playset: Risky Business
+ Playset: Under a Full Moon
* Added "The Car" as a top-level category template
* Updated to PhoneGap multi-version build cli-5.2.0
* Current count: 60 playsets
* Windows Phone 8.x Browser: Solved arcane bug where punctuation in submitted form failed to be translated into %## code, as well as workaround for failure to correctly handle javascript href.location script.

1.2.1
* Android: From homepage, back button now processes the standard workflow correctly.
* Android: Fix the broken splash screens

1.2.0
+ Playset: 10 Minutes in the Future
+ Playset: Hollywood Hospital
+ Playset: Pen Show
+ Playset: Staring Down At Madison Avenue
+ Playset: The Sunshine State
+ Added [Title] of The Score to the playset page template.
* Various and sundry bugfixes
* Intermittent fix to the improve Android Back button handling
