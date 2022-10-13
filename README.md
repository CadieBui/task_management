# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version
- Ruby: 3.0
* System dependencies

* Configuration

* Database creation
- Users:
> - id: uuid 
> - username: string
> - password: string（hash password）
> - isAdmin: boolean (default: false)
- Tasks:
> - id: uuid
> - title: string（text field）
> - content: text （text area field）
> - priority: integer; ENUM :HIGH, MEDIUM, LOW（select field）
> - status: integer; ENUM :PENDING, INPROGRESS, COMPLETED（select field）
> - startDate: dateTime（datetime picker）
> - endDate: dateTime（datetime picker）
> - label：integer; ENUM :WORK, PERSONAL, FAMILY, STUDY, BILL （select field）

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
