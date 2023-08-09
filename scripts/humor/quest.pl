sub quest {
   climb $HighestMountains;
   run $ThroughTheFields;
   run, crawl, scale $CityWalls;
   only $ToBeWithYou;
   find $WhatImLookingFor and say "Eureka!" and return 1
   or say "I still haven't found $WhatImLookingFor" and return 0;
}