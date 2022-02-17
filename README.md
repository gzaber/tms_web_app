# tms_web_app - Task Management System frontend

Frontend web application for TMS (Task Management System) backend.

The project was written for a friendly company.  
It is used to manage services of security systems and other installations at various facilities.

## Table of contents

- [Screenshots](#screenshots)
- [Features](#features)
- [Technologies](#technologies)
- [Setup](#setup)
- [Test](#test)
- [Launch](#launch)
- [Insipiration](#inspiration)

## Screenshots

[<img alt="Authorization screen" width="400px" src="_screenshots/tms_web_app_auth.png" />](_screenshots/tms_web_app_auth.png)
[<img alt="Home screen" width="400px" src="_screenshots/tms_web_app_home.png" />](_screenshots/tms_web_app_home.png)
[<img alt="Task status" width="400px" src="_screenshots/tms_web_app_task_info.png" />](_screenshots/tms_web_app_task_info.png)
[<img alt="Tasks screen" width="400px" src="_screenshots/tms_web_app_tasks.png" />](_screenshots/tms_web_app_tasks.png)
[<img alt="Users screen" width="400px" src="_screenshots/tms_web_app_users.png" />](_screenshots/tms_web_app_users.png)
[<img alt="Profile screen" width="400px" src="_screenshots/tms_web_app_profile.png" />](_screenshots/tms_web_app_profile.png)

## Features

- Viewing the monthly schedule
- Authentication (register / login / reset forgotten password)
- Confirmation of account registration and password reset via e-mail
- Account registration only for allowed emails
- Add / edit / delete allowed emails
- Add / edit / delete users
- Add / edit / delete tasks (services)
- Full rights for administrators
- Limited rights for users
- Field validation
- Error display

## Technologies

- Dart
- Flutter

## Setup

Clone this repository to your computer and run command `flutter pub get` to install all the packages.  
Create `.env` file in the root of the project.
Create `API_URL` variable with link to backend server.  
If you run backend locally, set the following value:  
`API_URL=http://localhost:3000/`

## Test

To test `auth` and `task` packages, set connection string to backend and MongoDB in the following files:

```
auth/test/helpers.dart
task/test/helpers.dart
```

If you run backend locally, set the following value:  
`const String API_URL = "http://localhost:3000/";`

For database connection replace 'mongo_db_connection_string' with your MongoDB deployment connection string.  
`const String MONGO_URL = "mongo_db_connection_string";`

To run tests use Flutter documentation:  
https://docs.flutter.dev/cookbook/testing/unit/introduction#6-run-the-tests

## Launch

You can run project in web browser using command line or your IDE options.  
Use Flutter documentation:  
https://docs.flutter.dev/get-started/web#create-and-run

To start using the application you need to create collection `emails` in MongoDB. Then create document with the following data:

```
email: "your_email"
role: "admin"
```

Replace 'your_email' with your valid email address.  
Using provided email register in application, confirm registration, login and you can start using it.

## Inspiration

This project was based on tutorial:

- Island Coder876  
  _Full Stack Flutter Development_  
  https://www.youtube.com/playlist?list=PLFhJomvoCKC-HHwfZzIy2Mv59Uen88rqB
