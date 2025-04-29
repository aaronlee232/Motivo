# Motivo
## Group number: 4 <br> Names: Aaron Lee, Arisyia Wong
### Final Documentation
#### Updated on 2025/04/28
#### GitHub: `https://github.com/aaronlee232/Motivo/tree/main`
#### Dependencies:
- Xcode 16.2
- Swift 5
- Frameworks / Packages:
    - FirebaseAnalytics
    - FirebaseAuth
    - FirebaseAuthCombine-Community
    - FirebaseCore
    - FirebaseDatabase
    - FirebaseFirestore
    - FirebaseFirestoreCombine-Community
    - FirebaseStorage
    - FirebaseStorageCombine-Community
    - [Kingfisher](https://github.com/onevcat/Kingfisher)
    - [MockImagePicker](https://github.com/yonat/MockImagePicker?source=post_page-----e9e5b2acb0c1---------------------------------------)
    - [Shuffle](https://github.com/mac-gallagher/Shuffle)

#### Special Instructions:
- Please make sure all the packages above are installed before running the app
- Demo Accounts:
  - Jack Smith (**Main Account** / Email: jack.smith@gmail.com / Password: 123456)
  - Alice Sun (Email: alice.sun@gmail.com / Password: 123456)
  - Bob Tran (Email: bob.tran@gmail.com / Password: 123456)
  - Carol Lee (Email: carol.lee@gmail.com / Password: 123456)

#### Disclaimer:
- Most of the screens / features that are stubbed have an alert that would pop up indicating that it is unavailable
- For testing purposes, use the following email and password to show a populated connections list  
Email: jack.smith@gmail.com  
Password: 123456

#### Features removed from initial design:
- Social / Chat
- Chat Search
- Accountability Nudges
- Notifications (Group Invitations)
- Additional Social Features of Habits (Daily Check-Ins, Challenges)
- Gamification Features (Streaks, Leaderboards, Rewards)

| Feature | Description | Release <br> Planned | Release Actual | Deviations | Who / Percentage worked on |
| :- | :- | :-: | :-: | :-: | :-: |
| Authentication <br> (log in / out, account creation) | User can log in, log out, and reset password | Alpha | Alpha | N/A | Aaron (50%), Arisyia (50%) |
| UI | Various refinements to UI to match mockup | Final | Final | Style differences on some screens | Aaron (15%), Arisyia (85%) |
| Homepage / Overview | Home screen that shows a user's groups and favorite habits | Not Specified | Final | Missing favorite habits | Arisyia |
| Habits | Primary habit screen where user manages their habit list | Alpha | Final | N/A | Cooper (10%), Aaron (90%) |
| Group Matching | Creating a group, joining a group by invite, joining a random group | Alpha <br> (previously called pairing system) | Beta | Missing option to invite a user directly through the app | Aaron (50%), Arisyia(50%) |
| Social / Chat | Social engagement features including group chats, challenges, and leaderboards | Beta | N/A | Stubbed feature due to time constraints | N/A |
| Chat Search | Search for a specific set of keywords across all chats | Beta | N/A | Dropped feature due to time constraints | N/A |
| Connections | Shows a list of other users that the current user is connected to, and favoriting users | Alpha | Beta | Missing option to add a friend to the connection list that isn't in a common group | Aaron |
| Habit Verification | A user can progress their habits by taking photos and getting them verified by others | Not Specified | Final | N/A | Aaron (70%), Arisyia (30%) |
| Accountability Nudges | User's can remind other user's in the same group to work on their habits | Beta | N/A | Stubbed feature due to time constraints | N/A |
| Notifications | Serves as an inbox for Group Invitations | Final | N/A | Dropped feature due to time constraints | N/A |
| Profile | Displays a user's stats, groups, and approved photo gallery | Final | Final | Missing a heatmap tab for viewing habit progress overtime | Aaron (50%), Arisyia (50%) |
| Settings | Displays app-wide options like theme, help/about, and log out | Final | Beta | Missing implementation for: themes, about, and help options | Arisyia |
| Additional Social Features of Habits | Daily Check-Ins, Group-Proposed Daily/Weekly Challenge | Alpha | N/A | Dropped feature due to time constraints | N/A |
| Gamification Features | Streaks, Leaderboards, Reward System | Beta | N/A | Dropped feature due to time constraints | N/A |

- - -
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


