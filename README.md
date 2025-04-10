# Motivo

### Beta Documentation
#### Updated on 2025/04/09
#### Disclaimers:  
For testing purposes, use the following email and password to show a populated connections list  
Email: beta@gmail.com  
Password: 123456

Features removed from initial design:
- Group-Proposed Daily/Weekly Challenge
- Chat
- Chat-related Notifications (still keeping group invite notifications)
- Chat Search


**Contributions**  
Aaron Lee & Arisyia Wong (25%)
- Implemented deadlines for Habits and designed logic for determining "active" habit records based on habit deadline
- Integrated Group Cell data with Firestore

Aaron Lee & Cooper Wilk (5%)
- Camera Functionality Research and Implementation
    - Driver as Aaron Lee
    - Configure MockImagePicker
    - Set up test button for opening camera interface
    - Upload photo taken into FirebaseStorage

Aaron Lee (30%)
- REFACTORING for most files
- Added Camera functionality to HabitCell buttons
    - Added logic to insert image url into habit records
- Added Group View
    - Integrated with Firestore
    - Added Group Progress View tab and functionality
    - Added Group Overview View tab and functionality

Arisyia Wong (25%)
- UI
    - Custom UI components
    - Screens: All
- Set up Profile / Settings Page Functionality
- Set up Picker view and functionality for add habit
- Group Cell UI

Cooper Wilk (15%)
- Split Habit Model into HabitModel and HabitRecord
- Connect habit views to firestore
- Added pending photo display to habit cells 


- - -
**Deviations**  
- Group Invite
- Notification
    - Show group invite notifications
- Profile
    - Currently using hardcoded user stats. Will replace with firestore data
- Home
    - Habit List Display
- Connections
    - View pending photos of other users and verify their photos and update HabitRecord accordingly
- Group View
    - Menu button implementations (Edit Group Name, Invite User, Leave Group)
- Group View (Overview Tab)
    - Heat map
    - List of group member habits that fall under group categories
- Group View (Progress Tab)
    - Nudge
- Other user profile
    - Add segues to other user profiles
    - (multiple places)


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


