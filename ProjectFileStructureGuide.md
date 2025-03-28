#  Project File Structure Guide

Constants - Holds global constants

Controllers - Holds ViewControllers. Contains UI Logic
Controllers/Core - Holds ViewControllers for primary navigation tabs (main app sections)
Controllers/General - Holds ViewControllers for secondary features that support core sections

Extensions - Holds App-wide extensions

Managers - Holds Managers that hold non-UI logic

Models - Holds models used to hold data and basic helper functions (computed properties and defaults).
Models/AppModels - Models used to hold ViewController state
Models/FirestoreModels - Models used to represent Firestore collections. 

Resources - Contains assets, info.plist, launchscreen storyboard

Utilities - Holds app-wide utility classes

Views - Holds Views that only contains UI setup and "dumb" utility functions 
