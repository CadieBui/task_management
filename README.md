# README

* Ruby version
> - Ruby: 3.0.0

* Database creation
- Users:
> - id: uuid 
> - username: string
> - password: string（hash password）
> - isAdmin: boolean (default: false)
- Tasks:
> - id: uuid
> - userId: uuid
> - title: string（text field）
> - content: text （text area field）
> - priority: integer; ENUM :HIGH, MEDIUM, LOW（select field）
> - status: integer; ENUM :PENDING, INPROGRESS, COMPLETED（select field）
> - startDate: dateTime（datetime picker）
> - endDate: dateTime（datetime picker）
> - label：integer; ENUM :WORK, PERSONAL, FAMILY, STUDY, BILL （select field）

* Deployment web url
> - https://task-management-tranning.herokuapp.com/

* Deployment method
> - Create Heroku ID
> - Connect to github
> - Choose app from github repo
> - Deploy branch
> - Install Heroku in local
> - Change Heroku version
> - Resolve Heroku error https://devcenter.heroku.com/articles/error-codes#h14-no-web-dynos-running
> - Run `rails db:migrate` from Heroku website console to generate db

* Website operation
> - On the task list page, there have all tasks, click the task title to open the task, and see the detail.
> - If you want to create a new task, click create new task button to go to create new task page, fill in the task title and content and then click submit to finish.
> - If you want to delete your task, from the task list page, click the task title to open the task, then click the delete button to delete your task
> - If you want to edit your task, from the task list page, click the task title to open the task, then click the edit button to edit your task