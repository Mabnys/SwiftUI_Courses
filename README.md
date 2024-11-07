# SwiftUI_Courses

## SwiftUI Calculator

## Swift Concurrency
- Creating Models and an APIService
- VOODO and Creating the UI
- Improving the User Experience (Visual Clue that data is loading & Present error feedback to users)

## Vapor - Created Project Hello
- Vapor is web framework for Swift, allowing you to write backends, web apps APIs and HTTP servers in Swift.
- Vapor is written in Swift, which is a modern, powerful and safe language providing a number of benefits over the more traditional server languages.


# 2024 iOS Bootcamp

***Note that the content is from the Kodeco's bootcamp.***


## Bullseye App

Your First iOS & SwiftUI App.

[Link to the mockup using Figma](https://www.figma.com/design/3MBMeYd2hP4rajTbHnZL0z/Bullseye?node-id=6-388)

### *- Must Haves (An App from Scratch):*
- [x] Add an instruction label.
- [x] Add a target label.
- [x] Add a slider and make it go between the values 1 and 100.
- [x] Add a "Hit Me" button
- [x] Style the text like Luke's design
- [x] Show a popup when the user taps the "Hit Me" button
- [x] Read the value of the slider after the user taps the "Hit Me" button 
- [x] Generate a random number for the target value.
- [x] Calculate and display the score.

### *- Nice to Haves (Polishing the App):*
- [x] Implement multiple rounds.
- [x] Implement restarting the game
- [x] Add the leaderboard screen
- [x] Make the app look pretty :]


## SwiftUI Tutorial: Navigation
- In this tutorial, you’ll use SwiftUI to implement the navigation of a master-detail app.
- In addition you will learn more about managing the flow of data in your app using property wrappers:
- [x] *@State*,
- [x] *@Binding*,
- [x] *@ObservedObject*,
- [x] *@EnvironmentObjects* etc.
- You’ll learn how to implement a navigation stack, a navigation bar button, a context menu and a modal sheet. By [Fabrizio Brancati]().


## SwiftUI View Modifiers Tutorial for iOS
- In this tutorial, you'll learn how to refactor your code to create powerful custom SwiftUI view modifiers.
- In this tutorial, you’ll use an app called **AdoptAPet**, a simple master-detail view app, meaning there is a master view that shows high-level information, in this case an adoptable furry friend’s picture and name, and then a detail view that displays when the user taps a list row.
- You’ll refactor AdoptAPet as you learn how to use SwiftUI’s *ViewModifier* protocol for:
- [x] Creating custom view modifiers.
- [x] Building new **button styles**.
- [x] Creating modifiers with **conditional parameters**.
- [x] **Extending views** to create reusable components.
- You’ll learn how to make your views look consistent and your code easier to read and maintain. By [Danijela Vrzan]().

 ## MovieApp Project
 This project consists of two parts: a backend API (MovieAppVapor) and a frontend iOS app (MovieAppVaporFrontEnd).

 ### MovieAppVapor (Backend)
 MovieAppVapor is a Swift-based backend API built with the Vapor framework.
 - Key Features:
  - [x] CRUD operations for movies and reviews
  - [x] Fluent ORM for database interactions
  - [x] RESTful API for managing movies and reviews
- API Endpoints:
  - [x] GET /movies: Fetch all movies
  - [x] POST /movies: Create a new movie
  - [x] RESTful API for managing movies and reviews
  - [x] GET /movies/:id: Fetch a specific movie
  - [x] PUT /movies/:id: Update a movie
  - [x] DELETE /movies/:id: Delete a movie
  - [x] GET /reviews/movie/:movieID: Fetch reviews for a specific movie
  - [x] POST /reviews: Create a new review

  ### MovieAppVaporFrontEnd (iOS App)
 MovieAppVaporFrontEnd is a SwiftUI-based iOS app that consumes the MovieAppVapor API.
 - Key Features:
  - [x] Display list of movies
  - [x] SwiftUI views with MVVM architecture
  - [x] Combine framework for network requests
- API Endpoints:
  - [x] GET /movies: Fetch all movies
  - [x] GET /reviews/movie/:movieID: Fetch reviews for a specific movie

Keep learning with [Mamadou A. Balde]().
