# rails-change-tracker

Ever been working on a rails application and wondered "If I push this button or call this method, what *exactly* happens to the data in my database?" Sure, you can comb through the development log rails provides, but those are not formatted well and it's easy to miss important changes among everything else that is logged.

This application helps track updates, deletions, or additions to any active record models. Changes are logged in a separate table that is added to your current database. You'll have an easy to read, chronologically orderd table of every change that happens through active record.
