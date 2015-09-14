Tweet Streamer
======================================

This is an Elastic Search backed Rails App to listen to all of the public streaming tweets.

Steps to deploy it on local
----------------------------
* Please make sure elastic search is running in the default port.
* Boot the Rails Server
* Run the rake command to create the index - rake tweets:create
* Run the twitter listener - rake tweets:listen
* Fire up localhost on your browser and you are all set to search for location centric tweets

  
