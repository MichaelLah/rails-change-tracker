# rails-change-tracker

Ever been working on a rails application and wondered "If I push this button or call this method, what *exactly* happens to the data in my database?" Sure, you can comb through the development log rails provides, but those are not formatted well and it's easy to miss important changes among everything else that is logged.

This application helps track updates, deletions, or additions to any active record models. Changes are logged in a separate table that is added to your current database. You'll have an easy to read, chronologically orderd table of every change that happens through active record.

### Usage
#### Setup
- Ensure mysql is running on port 3306
- Run the setup command found in the bash script in this repository
```bash
./rails-tracker.sh setup
```
- When prompted to, provied the location of your rails application you want to track, as well as the location of this repository. For example
```bash 
/Users/your_username/Documents/projects/my-rails-project
/Users/your_username/Documents/projects/rails-change-tracker
```
#### Starting tracking
To start tracking changes in your rails project, run the following command:
```bash
./rails-tracker.sh start
```
This will do the following:
- Create a table in your database called `tracking`.
- Swap out your `application_record.rb` file with a custom one.

Now, all changes to any active record models will be listed in the `tracking` table!

#### Stopping tracking
To stop tracking changes, run the following:
```bash
./rails-tracker.sh stop
```
This will drop the `tracking` table, as well as replace the `application_record.rb` file with the default one that comes with any rails application.
