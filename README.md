# Motivo

### Beta Documentation
#### Updated on 2025/04/09
#### Disclaimers:  
For testing purposes, use the following email and password to show a populated connections list  
Email: beta@gmail.com  
Password: 123456

Features removed from initial design:
- Placeholder


**Contributions**  
Aaron Lee & Arisyia Wong & Cooper Wilk (%)
- Placeholder
    - Driver: 
    - Placeholder elements

Aaron Lee & Arisyia Wong (%)
- Placeholder
    - Driver: 
    - Placeholder elements

Aaron Lee & Cooper Wilk (%)
- Placeholder
    - Driver: 
    - Placeholder elements

Aaron Lee (%)
- Placeholder
    - Placeholder elements

Arisyia Wong (%)
- UI
    - Custom UI components
    - Screens: Group Entry, Create New, Home, Profile, Settings
- Set up Profile / Settings Page Functionality
- Group Visual Component

Cooper Wilk (%)
- Placeholder
    - Placeholder elements


- - -
**Deviations**  
Placeholder:
- Placeholder


- - -
### Alpha Documentation
#### Updated on: 2025/03/12
### Names: Aaron Lee, Cooper Wilk, Arisyia Wong, John Bukoski

#### Disclaimer:  
For testing purposes, use the following email and password to show a populated connections list  
Email: test@gmail.com  
Password: 123456  

Creating account and forget password works, but the populated connections list only works for test user (test@gmail.com) since the social functionality is not fully implemented yet.

Group Invite Code: It works if user provides the group ID from Firebase. However, we still need to implement retrieving the group code inside the app.


**Contributions**  
Aaron Lee & Arisyia Wong (60%)
- Authentication screens
    - Aaron as driver
    - Setting up Firebase for the project and removed storyboard elements
    - Created MVC file structure
    - Created tab navigation controller and stub pages for the primary view controllers (Home, Task, Chat, Connections, Profile)
    - Created login, register, and forget password pages
    - Created UserModel and user collection in Firestore
- Group Matching screens
    - Arisyia as driver
    - Created Create New Group, Join Existing Group, and Join Random Group screens
    - Implemented functionality for Create New Group and Join Existing Group
    - Implemented GroupModel and GroupMembershipModel
    - Created the Utilities folder with AlertUtils.swift for handling user error and debugging alerts

Aaron Lee (10%)
- Connection screens
    - Created list of contacts, using Firebase data
    - Created generic header view
 
Cooper Wilk (30%)
- Habit screens
    - Created Habit Model, Habits View Model, Habits Controller,
    - Create Habit cell with streak and habit implement functionality.
    - Created Settings View Controller to change view settings, display only selected categories
    - Created Add Task Controller, add new task to Stub Data (name, units, frequency, publicity, category), dynamically display new task on the task page
    - Implement Alternate View detailed view of the task page with placeholders for heatmap and data visualization
  
John Bukoski (0%)


- - -
**Deviations**  
Join Random Group Implementation:
- The confirm buttons for join random screen is set up, but the user cannot join a random group yet. Aaron and Arisyia will implement this in the beta deliverable

Habit View Data:
- Habit data is still gathered from STUB data right now, it needs to be hooked up to the firebase in Beta.


