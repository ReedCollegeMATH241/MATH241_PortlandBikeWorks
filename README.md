# Portland Bike Works
Final Project for Albert Kim's upper division data analysis class at Reed College. Analyses data from the open source Portland Ride™ app (enabled by Reed Switchboard) and different aesthetic approaches to this information. The RIDE data was juxtaposed with city data from the Civic Apps website. 

![ScreenShot](https://github.com/reediemeyers/Images/blob/master/Screen%20Shot%202015-05-10%20at%209.52.33%20PM.png)

The RIDE data incorperated over 3905 rides from the past year. With a tap to begin a ride, and a tap at the end, bikers can rate their ride experience. 0 is no comment/neutral, 1 is a good ride, and 2 is a bad ride. While dedicated bike paths are well-liked, the smaller side streets in busy areas like the industrial district prove uncomfortable for many RIDE participants. Longer commutes from the SE are also stressful. Well-used paths are also, generally, well-liked. See the full code for maps of the Downtown and Industrial areas.

![ScreenShot](https://github.com/reediemeyers/Images/blob/master/Screen%20Shot%202015-05-10%20at%209.52.02%20PM.png)

When juxtaposed with accidents in the area, we see more accidents on the bridge-proximate roads and on the poorly rated roads. On the more well-used roads we see more accidents as a function of that increased use. 

![ScreenShot](https://github.com/reediemeyers/Images/blob/master/Screen%20Shot%202015-05-10%20at%209.44.04%20PM.png)

When accidents are mapped onto road type (as designated by Portland Metro), it appears at-a-glance that the wider boulevards with bike accomodation might be less dangerous than the smaller lanes. (MTRAIL = Multi-Use Trail; LANE = Bike Lane; BLVD = Bike Boulevard; SCONN = Signed Connection) However, it does not seem, from this visual juxtaposition, that there is necessarily any correlation.

In short, this was a preliminary exploration of the RIDE data in the context of the CivicApps data. RIDE's rating system needs some adjustment - at the moment, it is difficult to parse apart what *parts* of a ride went well in relation to specific city infrastructure qualities like road type or accident frequency. 

#Analysis

## Smartphone Apps and Ride Evaluation
The prevalence of smartphones in the United States has made for an exciting era of crowd-sourced data. From Yelp to Waze, users share feedback in real time to clarify saturated markets and enhance the consumer or citizen experience. Fieldwork in the geosciences have welcomed new technologies that synthesize multiple types of data by geolocation. Mobile database applications increase data integrity by allowing users to enter information into a structured database during initial collection. In some cases, data can even be synced to a central server when the user has an internet or cellular connection. Mobile applications have been developed for anything from monitoring air pollution from user photos to ribotyping bacteria [Showstack, 2010; Guertler and Grando, 2013]. At the same time, the access app developers now have to intimate personal data has sparked debate around personal security in the digital era. Smartphone users are, in this context, most compelled to submit personal data when that data might consequently improve their own experience.

Portland aleady offers some online planning services. Some [map the Metro area](http://www.ridethecity.com/portland) with enhanced information pertinent to riders. [TriMet's Trip Planner](http://trimet.org/howtoride/maptripplanner.htm) lets you plan trips by bike, by public transit, by foot, or a combination of modes. The TriMet online mapping system lets you specify your preference for quickest route, flattest route, or most bike-friendly. You'll see the distance of the trip, get an elevation profile of the route, and you can print turn-by-turn directions. Apps have only recently hit the floor. The **MapMyRide** app is not specific to Portland but provides basic mapping information. The Oregon Department of Transportation (ODOT) and a research lab at Portland State University launched a [smartphone app](https://itunes.apple.com/us/app/orcycle/id900346454?mt=8) that allows you to record trips, display maps of the rides, and input feedback about collisions and safety issues. The data will then go to transportation planners to help them make decisions - hopefully made more easy by ODOT's involvement in this app's development.

The [RIDE app](http://ride.report/), developed by Reed graduate William Henderson [@quicklywilliam], has a similar purpose. The app is in Beta and makes its data publicly accessible. Henderson explains, 
>"Ride is an iPhone app that automatically logs your rides. When your ride is done, you rate it with a single tap on your lock screen. Ride uses your feedback and anonymous route data to improve bicycle planning and infrastructure in Portland. Later, this data will power a new technology for turn-by-turn bike directions that takes rider preferences and comfort into account."

While the ODOT app is mostly interested in infrastructure, RIDE additionally focusses on rider experience. It seems, through quick conversation, that the app might be able to share data in real time with sensors/bike counters installed throughout Portland; not only will the smartphone app gather data from users about their *experience*, but the app will dialogue with RIDE's physical infrastructure to update maps in real time. 

## Reporting Bias

The way that data is sorted in the RIDE app requires specific attention. Each individual ride receives a rating, which applies to the whole ride. As previously noted, 0 is no comment/neutral, 1 is a good ride, and 2 is a bad ride. A ride rating is a comment on the entire ride experience, which is good for determining preferred bike path but less useful for commenting on the bike amenities of various neighborhoods in PDX.

RIDE data ratings, in this Beta version, do not yet capture the nuances of a bike ride through PDX. Why was the ride bad? Was it an infrastructure problem, a route problem, or a random occurance? Is there a specific part of PDX that bikers should avoid? To answer the second question using RIDE data would require the researcher to sort RIDE data by what parts of town they went through. 

In this analysis I tried to add neighborhood variability with city data. Accident counts highlighted on the map, street type, etc. create classifications for neighborhoods. These were proxies for more specific data - the accident data, for example, were not proportional to ride data but are just counts. Still. they provide useful spatial awareness.

Finally, RIDE can only benefit from more app users. Thousands of bike trips are taken each day, and only a small fraction of them captured here. Currently each ride stands alone, not pinned to an identifiable single reporter; everyone has different standards for what a "good" or "bad" ride is, and the data might benefit from randomized IDs attached to each cell device. 

## Credit

Thank you to Albert Kim (@rudeboybert) for his support in transforming the RIDE data. Thanks to William Henderson for allowing me to work on his material, and Reed Switchboard for connecting me with William in the first place. All census tract and intrastructure data comes from the incredible CivicApps page, where anyone can access public data on Portland. Thanks to the comraderie of the Math241 class as well, and congrats!


