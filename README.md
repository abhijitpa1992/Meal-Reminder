# Meal-Reminder
This project is created for assignment submission purpose in Navia Life Care.
A verticle segmented view application for creating meal reminder.

## Features

AFNetworking
EKReminder

## Supported Devices

iPhone with iOS 10 or later

## Installing

Clone the project.
Go to application folder from terminal
Run the comman 'pod install' (requires CocoaPods)
open Meal Reminder.xcworkspace.

## Architecture

1. Table View

diet_table_view

2. Verticle Segmented Controller

EMVerticalSegmentedControl


## Support Files

1. Json Manager

JsonAPICall --> Acts as a mediatior to pass network api call request to JSONManager and send back the response to perticular delegate.

JSONManager --> Makes network connection to the backend and fetches the response. Uses AFNetworking.
