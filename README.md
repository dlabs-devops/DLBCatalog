DLBCatalog
=========

DLBCatalog is an internal repository of common UI components from multiple projects. It currently contains components from next projects:

- Wandera V4
- Outcast
- RockPamperScissors

# Component list

- **Bar Graph**
  
  *Some description.*
  
- **Circular Progress View**
  
  *Some description.*
  
- **Line Graph**
  
  *Some description.*
  
- **Media Recorder**
  
  *Some description.*
  
- **Numeric Counter**
  
  *Some description.*
  
- **Pie Chart**
  
  *Some description.*
  
- **Pulse Graph**
  
  *Some description.*
  
# Contributing

To contribute a component into the catalog, just create a new branch (or fork the repository) and push all changes to the branch. Then create a pull request and ask us to review it, because we must update Podspec to support CocoaPods integration.

# Star view

A proper star view meant for rating display
Features:
- Can set number of stars (animatable)
- Must set images for selected and deselected star
- Can set rating (animatable)
- Can select maximum rating (so you can have a rating from 1 to 10 represented by 5 stars for instance) (animatable)
- Can set a star image content mode (aspect fit by default)
- Can set view content insets (edge insets)
- Can set rounding value (for instance .5 will round all rating values to .5 e.g.: .0, .5, 1.0, 1.5...)

Interectable subclass:
- Adds a gesture recognizer for the user to be able to select a specific rating
- Can set a selection granularity to round the user selection (for instance .5 will round all rating values to .5 e.g.: .0, .5, 1.0, 1.5...)
- Can have a delegate to be notified when the user selects a rating

And the best part: Its DESIGNABLE!!!
You may use an interface builder to set:
- star images
- number of stars
- rating
- maximum rating
- rounding value



License
========

Proprietary - all code owned by **D·Labs**.

