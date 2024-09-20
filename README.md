# csce600-arcade
This repository is associated with all the code for the Arcade project for the CSCE600 course in Fall2024

## Project Summary
This project aims to create an open source gaming platform that allows users to create accounts, play games,
track performance and maintain streaks.

### List of supported games and functionality
<add_as_developed>

## SDLC for this project
1. `main` is the top level branch for this project and maintains the latest fully tested working
   copy of the codespace and should be deployable at any time.
2. When picking up a new ticket, checkout a new branch off of `main` and commit all your code to that branch
    a. When the code is ready, **ensure all acceptance and unit tests are passing for the whole project**,
       pull the latest version of `main`, merge `main` into your feature branch, resolve any merge conflicts,
       ensure build is successful then push your code to github and create a pull request.
   b. Assign two developers in the team to review the code
   c. Once reviewed, merge your feature branch back to `main` and delete your feature branch.
3. Everytime code is merged to the `main` branch, Acceptance tests and Unit tests will be run on
    on `main` to ensure we still have a woring copy of the code. If the tests fail, we fix the defects
    before any new feature work is picked up. If the tests run succesfully, we deploy `main` to Heroku.

## Software dependencies and version
**Ruby** - 3.3.4
**Rails** - 7.2.1
**Rack** - 3.1.7

