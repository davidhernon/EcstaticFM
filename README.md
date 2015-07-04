# 

TestFlight Guide

Screenshots:
920x640 (w/o status bar) minimum
640x960 max


Use the “ecstatic” provisioning profile in build settings

How to export a build:
set target to iosDevice
go to help>archive
Organizer - Archives should pop up
Highlight the correct build, then click “validate”
Do not include app symbols (uncheck the box after you clicked validate)
	Because there is some “symbols tool failed” error that I cannot fix. Please fix this. We need 	crash logs
Then once it has been validated, hit submit, and it should work.

then go to iTunes connect > my apps >  ecstatic > select the correct build 
What you really want is to submit to Testflight Beta
