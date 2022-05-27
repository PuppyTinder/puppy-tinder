# Pupple

## Table of Contents
1. [Overview](#Overview)
2. [Product Spec](#Product-Spec)
3. [Wireframes](#Wireframes)
4. [Schema](#Schema)
5. [GIF Updates](#Updates) 

## Overview
### Description
A Tinder-like app that allows dog owners to find a playmate for their dogs.

### MVP Slide Deck
Click [here](https://docs.google.com/presentation/d/1Qpr55RPmLqqVPcJ7YX44Q_GFPZXR50YeXrakF_OOr8o/edit?usp=sharing) to view our MVP Slide Deck showing our app's features.
 
### App Evaluation

- **Category:** Social Networking
- **Mobile:** This app will be primarily developed for mobile but would function on a computer as well. Mobile version for this application would be more friendly to use and allows for more features.
- **Story:** Dog owners are able to connect and match with other dog owners and potentially set up a puppy playdate.
- **Market:** Dog owners will typically be using this app.
- **Habit:** This app will be used in the event a dog owner is looking for nearby companions for their furry friend. Could be often and also unoften.
- **Scope:** We hope to start off with a basic Tinder replica and apply some unique matching features into the app.

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**
- [x] User can see a stylized launch screen and icon.
- [x] User can see a stylized welcome screen.
- [x] User can login.
- [x] User can create a profile.
- [x] User can see other dog profiles.
- [x] User can like or not like a dog profile.
- [x] User can view their previous likes.
- [x] User can view their matches.
- [x] User can view a list of conversations with other dogs.
- [x] User can message a match in real-time.

**Optional Nice-to-have Stories**
- [x] User can edit a profile.
- [x] User can set their preferences for dog profiles
* User can create an event (e.g. playdate)
* User can view events
* User can report a dog profile
* More accurate location setting and filter

### Screen Archetypes
* Welcome Screen
    * Create an account: Create a profile
    * Login
* Feed (Like/Dislike other dog profiles)
    * User can like or dislike a dog profile
    * User can view more information about dog profile
* Personal Profile
    * User can edit and view their owner profile and their dogs' profile
* Dog Profile
    * User can view prospective playdate pictures, breed information, age, fun facts, and owner information
* Likes
    * User can view previous dog profiles they've liked
    * User can tap on a previous like to view their dog profile
* Matches/Inbox
    * User can tap on a match and open a conversation with them
- Conversation
    - User can view a messaging history

### 3. Navigation

**Tab Navigation** (Tab to Screen)
* Feed
* Likes
* Matches

### Flow Navigation
* Welcome Screen
    * No Account: Create profile screen
    * Account: Login
* Feed, Likes, Matches
    * Dog & Owner Profile
* Owner & Dog Profile
* Matches
    * Conversation


## Digital Wireframes

### Figma
[Figma Link](https://www.figma.com/file/6FvZexl2m7K3RwQXaSSBr7/Puppy-Tinder-Project?node-id=0%3A1)

### Launch, Welcome, and Login Screen
<p float="left"> 
<img src="https://i.imgur.com/RHWwVh9.png" width=400>
<img src="https://i.imgur.com/U0nY2ez.png" width=220>
</p>

### Signup Screens
<img src="https://i.imgur.com/GZoFE4j.png" width=1000>

### Tab Navigation Screens
<img src="https://i.imgur.com/q64oP71.png" width=600>

###  Profiles
<img src="https://i.imgur.com/DCJX2De.png" width=600>

###  Messages
<img src="https://i.imgur.com/S8VVzs9.png" width=200>


### [BONUS] Interactive Prototype
<img src="https://i.imgur.com/FXbtcXs.gif" width=300>

## Schema 

### Models

##### User
  | Property        | Type              | Description |
  | --------------- | ----------------- | ------------|
  | id              | int               | Unique id for the user (default field)|
  | username        | string            | Username set by user |
  | password        | String            | Password set by user |
  | image           | File              | Profile image that user uploads |
  | created_at      | timestamp         | Time of account creation |
  | firstname       | string            | Users first name|
  | lastname        | string            | Last name of the user |
  | birthday        | date              | The birthday of the user |
  | email           | string            | Email of the user|
  | phone           | string            | Users phone number|
  | dog             | ptr to dog        | Users dog   |
  | bio             | string            | User biography: user can write about themselves|
  | conversations   | array of convo    | Conversations that the user has|
  | likes           | array of dog id   | Users liked dogs|
  | likedby         | array of dog id   | Profiles that liked the user|
  
##### Dog
  | Property        | Type              | Description |
  | --------------- | ----------------- | ------------|
  | id              | int               | Id of the dog |
  | ownerid         | ptr ro user       | Id of the dogs owner|
  | yearsold        | int               | Age of the dog in years|
  | monthsold       | int               | Age of the dog in months|
  | name            | string            | Name of the dog |
  | gender          | string            | The gender of the dog |
  | breed           | string            | Breed of the dog |
  | vaccinated      | boolean           | If the dog is vaccinated or not |
  | fixed           | boolean           | If the dog is fixed or not|
  | image           | file              | Image of the dog |
  | bio             | string            | Dog biography: imformation of the dog |
  | city            | string            | City where dog is located|
  | state           | string            | State where dog is located |
  

##### Conversation
  | Property        | Type              | Description |
  | --------------- | ----------------- | ------------|
  | id              | int               | Conversation id    |
  | created_at      | timestamp         | Time of conversation creation |
  | messages        | array of msgs     | Messages in the conversation|
  | dogs            | array of dogs     | Dog ids |
  
  
##### Messages
  | Property        | Type              | Description |
  | --------------- | ----------------- | ------------|
  | id              | int               | Messages id |
  | created_at      | timestamp         | Time message was sent |
  | message         | string            | Content of the messages|
  | sender          | ptr to user       | User id |
  | recipient       | ptr to user       | User id |
  | convo_id        | ptr to convo      | conversation id |



### Networking

* Welcome/ Login Screen
    * (Create/Post) Create a profile 
    * (Read/GET) Query logged in user object
* Signup Screens
    * (Create/Post) Create owner profile and dog’s profile 
* Likes Screen
    * (Read/GET) Get all the profiles that liked you and you liked 
* Feed Screen
    * (Read/Get) Get dogs’ profiles 
    * (Create/Post) Like/ dislike dog profiles 
* Matches/ Inbox Screen
    * (Read/Get) Get all the new matches and messages with matches 
* Personal Profile 
    * (Update/Put) Update owner profile and dogs’ profile 
* Message Screen 
    * (Create/Post) Compose and send a message 
    * (Read/Get) Get messages with another user 
 
- The Dog API https://thedogapi.com/ for a list of official dog breeds

## Updates

### Sprint 1

- User can see a stylized icon and launch & welcome screen.
- User can create an account with a profile.
- User can login.

<p float="left">
  <img src="http://g.recordit.co/PLhFfi40g6.gif" width="300" />
  <img src="https://i.imgur.com/6cNhrWK.png" width="290" /> 

</p>

### Sprint 2

- User can see the view of other dogs.
- User can swipe between dog profiles.
- User can tap to see other dogs profiles.
- User can refresh feed.

<p float="left">
    <img src="https://i.imgur.com/kfic4lQ.gif"
width="300"/>
    <img 
src="https://i.imgur.com/7tHtJC8.gif"
width="300" /> 
</p>

### Sprint 3

- User can edit profiles (owner and dog)
- User can see a list of dogs that have liked you and a list of dogs that you have liked
- User can logout
<img src="http://g.recordit.co/m5PLZRWeeX.gif" width="300" />


### Sprint 4

- User can view a list of dogs they've matched with
- User can view a list of conversations with other dogs that they've had
- User can message the owner of another dog!


<img src="http://g.recordit.co/aicWodhZx3.gif" width="300" />
