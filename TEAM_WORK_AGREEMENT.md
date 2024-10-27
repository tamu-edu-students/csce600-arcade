
# Team Working Agreement
## Team Information
- **Client:** Dr. Ritchey
- **Client Meetings:** Every Thursday, 4 PM - 5 PM, via Zoom
- **Developers:** Kanishk Chhabra, Nandinii Yeleswarapu, Tejas Singhal, Krishna Calindi, Junchao, Ze Sheng, Antonio
## Sprint - 1
- **Product Owner:** Tejas Singhal
- **Scrum Master:** Nandinii Yeleswarapu
## Sprint - 2
- **Product Owner:** Junchao Wu
- **Scrum Master:** Antonio Rosales
## Sprint - 3
- **Product Owner:** Krishna Calindi
- **Scrum Master:** Kanishk Chhabra
## Purpose
This agreement outlines the team's shared understanding of collaboration, communication, and delivery to ensure we meet our goals and provide value effectively. It reflects our commitment to the Scrum values: **Commitment**, **Focus**, **Openness**, **Respect**, and **Courage**.
## Key Values
### 1. **Commitment**
- Each team member is responsible for completing their assigned story points within the sprint.
- Team members ensure transparency by updating their tasks daily in the project management tool.
- Everyone commits to attending daily stand-ups, sprint planning, reviews, and retrospectives on time.
### 2. **Focus**
- We will concentrate on sprint goals, ensuring our efforts contribute directly to the current sprint backlog.
- During core collaboration hours, team members should minimize distractions and focus on assigned tasks.
### 3. **Openness**
- Progress will be shared openly during stand-ups, especially blockers that require team support.
- Transparent communication is encouraged, whether it's about issues, delays, or new ideas.
- All feedback is valuable. We will create an environment where all ideas and perspectives are heard and respected.
### 4. **Respect**
- Respect each team member's time by being punctual for meetings and providing timely updates on tasks.
- Ensure all voices are heard during meetings, promoting inclusivity and collaboration.
### 5. **Courage**
- Team members are encouraged to take on challenging tasks and continue learning.
- We will embrace constructive criticism and use it to improve our processes and outputs.
## Working Hours
- **Core Hours:** 4 PM - 10 PM (team members are expected to be available for collaboration).
- **Flexible Hours:** Outside core hours, team members may work at their convenience but must ensure sprint commitments are met.
## Communication Guidelines
- **Primary Tool:** Slack (for daily updates, queries, and informal communication).
- **Project Management:** Tasks and progress will be tracked using Jira.
- **Email:** Used for formal communication with external stakeholders (e.g., client).
- **Video Conferencing:** Slack Huddle for team meetings and daily stand-ups, Zoom for client meetings.
### Communication Expectations:
- **Slack:** Respond within 2 hours during core working hours.
- **Email:** Respond within 1 business day.
- **Stand-ups:** Attend daily at 10:00 AM CST, sharing progress, blockers, and plans for the day.
## Meetings
- **Daily Stand-up:** Focus on what was completed, upcoming tasks, and any blockers.
- **Client Meeting:** Thursdays, 4 PM - 5 PM via Zoom. Prepare key updates and questions in advance.
- **Sprint Review & Retrospective:** End of each sprint, typically on Fridays, 3 PM - 6 PM. Review what went well, and what didn't, and identify action points for improvement.
## Definition of Completion
- All tasks must meet the acceptance criteria outlined in the user story.
- Code must be reviewed and merged into the main branch, with relevant documentation updated.
- Feature deployment must be tested in the staging environment before presenting to the client.
## Tools and Resources
- **Code Repository:** GitHub (all code changes should follow GitFlow and include peer code reviews).
- **Deployed Application:** Regular updates are required to ensure the app reflects the current progress.
- **Project Management Tool:** Jira is used to track tasks, story points, and overall progress.
## Collaboration Practices
- Pair programming or team collaboration is encouraged for complex tasks.
- All features should undergo a review process before being merged into the codebase.
- If you encounter a blocker, communicate it early and seek assistance from team members or the Scrum Master.
## Risk and Escalation
- For unexpected risks or delays, promptly communicate with the Scrum Master or Product Owner.
- If a risk may affect delivery, it will be discussed during the next stand-up or relevant meeting.
## Client Feedback Process
- Feedback from the client, Dr. Ritchey, will be reviewed and incorporated into our sprint planning.
- Action points from the client meeting will be documented and shared with the team via Jira or Slack.
## SDLC for this project
1. `main` is the top level branch for this project and maintains the latest fully tested working
   copy of the codespace and should be deployable at any time.
2. When picking up a new ticket, checkout a new branch off of `main` and commit all your code to that branch
    a. When the code is ready, **ensure all acceptance and unit tests are passing for the whole project**,
       pull the latest version of `main`, merge `main` into your feature branch, resolve any merge conflicts,
       ensure build is successful then push your code to github and create a pull request.
   b. Assign a developer in the team to review the code
   c. Once reviewed, merge your feature branch back to `main` and delete your feature branch.
3. Everytime code is merged to the `main` branch, Acceptance tests and Unit tests will be run on
    on `main` to ensure we still have a woring copy of the code. If the tests fail, we fix the defects
    before any new feature work is picked up. If the tests run succesfully, we deploy `main` to Heroku.
4. When we are ready to deploy, we merge `main` into `prod` and CICD takes care of the deployment.
## Revisiting the Agreement
This working agreement is a living document. The team will review and adjust it at the start of each sprint during Sprint Planning to ensure it reflects our evolving needs.
---
Team Arcade is committed to upholding this agreement and collaborating effectively to deliver value to our client, Dr. Ritchey.
