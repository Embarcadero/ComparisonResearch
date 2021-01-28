# Unicode Reader
October 29, 2020

## Overview
The goal of the Unicode Reader is to build an RSS reader that brings in multiple RSS feeds which contain diverse Unicode characters and save the individual posts to a table in a PostgreSQL database. The posts can then be viewed and read in the Unicode Reader. This is a prototype! The emphasis of this project is on the lessons learned during the development process and documentation phase. The end result does not require a huge amount of polish but should look reasonably similar and function as closely as possible unless otherwise noted in this specification.

The goal of building the Unicode Reader is to explore the strengths and weaknesses of the framework you are using. The app should be built once to figure out your approach.  Once complete, build the app again while recording your screen.  Finally, document the app creation process in a step-by-step manner (similar to a recipe - what would someone else need to know to build the app in its entirety - configuration, code, testing, etc.).

### Key Features
- Database Usage
- XML Parsing
- Unicode Character IO

### PostgreSQL
The PostgreSQL database should be installed on the same machine as the desktop client. The RSS reader should be loading from localhost. The drivers should all be correctly configured to support Unicode and the database and tables should also be configured to support Unicode.

### Default Feeds
https://blogs.embarcadero.com/feed/

https://blogs.embarcadero.com/ja/feed/

https://blogs.embarcadero.com/de/feed/

https://blogs.embarcadero.com/ru/feed/

https://blogs.embarcadero.com/pt/feed/

https://blogs.embarcadero.com/es/feed/

## Schemas
The schemas aren’t set in stone. If you think something doesn’t make sense or needs to be changed (added or removed), let us know so we can keep the schema in sync across different platforms.

### Channels Schema

```sql
create table channels (
    id serial,
    title varchar(1024) not null,
    description text not null,
    link varchar(2048) not null,
    constraint channels_pk primary key (id)
);
```

### Articles Schema

```sql
create table articles (
    id serial,
    title varchar(1024) not null,
    description text not null,
    link varchar(2048) not null,
    is_read boolean default false,
    timestamp timestamp default now(),
    channel integer not null,
    constraint articles_pk primary key (id),
    constraint channels_fk foreign key (channel)
        references channels (id)
        on delete cascade
);
```

### Login Info
Username: postgres
Password: postgres
Server: 127.0.0.1
DBName: postgres (or just the default?)

## Requirements
### Layout
The Unicode Reader is broken down into three sections. The left section contains the list of feeds. The middle section contains the list of posts from the selected Feed (or All Feeds if selected). The left and middle sections are a fixed width. The right section takes up the rest of the client and displays the contents of the post itself. In theory the contents of the post should be loaded into an HTML frame since they will contain HTML. It should not load the URL of the post but load the post itself. Any links should open in the Desktop browser (target=_blank).


### Light And Dark Theme
The Unicode Reader should offer a Light theme and a Dark theme. The Dark theme should be default.

![](https://github.com/Embarcadero/ComparisonResearch/blob/main/unicode-reader/unicodeReaderDark.png "Dark Theme")

![](https://github.com/Embarcadero/ComparisonResearch/blob/main/unicode-reader/unicodeReaderLight.png "Light Theme")

## Deliverables
### Project Items

1. Complete source code for your working Unicode Reader.  Include a compiled executable if applicable or instructions for executing the code if not.
2. A video capture of the second build process.  This must be in real-time (not sped up) and executed manually (without auto-typing or other speed features).  The intent is to get a realistic view of the effort required to make this Unicode Reader by a competent programmer.
3. A document with step-by-step instructions that walk someone unfamiliar with your development environment, tools, and language through the process of building this Unicode Reader to its full functionality.  This document can be a .docx, .pdf, or Google Document format.  Markdown usage is preferred.



### Iterative Feedback
Please provide feedback to us during the development process so we can help speed up the development. We have many many years of experience and are here to help you get the project done as fast as possible.

## Helpful Tips

### Delphi Specific

Can review code form here which already aggregates RSS feeds into a TFDMemTable.
<https://github.com/FMXExpress/Cross-Platform-Samples/tree/master/95-NewsReaderApp>

### Electron Specific

The data layer of this application should be implemented with the main process and a renderer process in mind. For raw access to the data layer the [pg library](https://www.npmjs.com/package/pg) is the de facto standard.

#### Electron Forge

To abstract away some of the common headaches of distributing and updating an application. Whether it be through an "app store" or not.
[Electron Forge](https://www.electronforge.io) could be used as it is very easy to get started with and it provides a lot of features out of the box.
Updates can be published through either update.electronjs.org (if the application is public and meets all the criteria) or custom update servers.
[Electron Forge](https://www.electronforge.io) provides an easy to use system for either one (publish targets).

To get started:

```sh
npx create-electron-app unicode-reader
```


---
# Post-development Modifications

After working Unicode Readers were finished and analysis began, Embarcadero project managers realized they were unable to test important aspects of each framework’s database implementation performance.  The following tests were specified to measure framework speed in database storage and retrieval assuming the PostgreSQL database performance remained constant between applications.   

## Test #1 - Database Storage
This test will measure the performance of the framework’s database storage implementation.  Network usage time will be eliminated by monitoring using a separate network monitoring tool and the database performance will be assumed equivalent for each application.
The test will start with a database configured with many RSS channels (20+) and an empty articles table. 

Test steps:
1. Start a timer.
2. Download and store all articles available from all RSS feeds in the database.
3. Stop the timer and display the elapsed time.
 
## Test #2 - Database Retrieval
This test will measure the performance of the framework’s database query implementation by touching each record in the articles table and saving them to a flat file with simple HTML.  The database performance is assumed to be equivalent for each application and the output file operations are basic in order to reveal differences in database access implementation efficiency through completion time disparities.

The output file should be named combinedRSS.html and adhere to the following format:
```
<!DOCTYPE html>
<html>
<head>
<title>Combined RSS Feeds</title>
</head>
 
<body>
<h2><a href="channel link">Channel Name</a> - <a href="article link">Article Title</a></h2>
<h3>Date</h3>
<p>Article content</p>
<br>
<hr>
 
<h2><a href="channel link">Channel Name</a> - <a href="article link">Article Title</a></h2>
<h3>Date</h3>
<p>Article content</p>
<br>
<hr>
 
<h2><a href="channel link">Channel Name</a> - <a href="article link">Article Title</a></h2>
<h3>Date</h3>
<p>Article content</p>
<br>
<hr>
</body>
</html>
```

The test will start with a database configured with many RSS channels (20+) and a populated articles table from Test 1. 

Test steps:
1. Start a timer.
2. Access each article in the database.
3. Sort articles in reverse chronological order.
4. Concatenate articles and save as combinedRSS.html in the executable directory.
5. Stop the timer and display the elapsed time.
 
## GUI Modifications
Add a button and timer for each test to the top bar of the application.  If able in less than an hour, add a button to “reset” the database according to the given SQL script that drops and re-initiates tables.  See the following image for a mockup of the modified Unicode Reader.

![Unicode Reader with Tests](https://github.com/Embarcadero/ComparisonResearch/blob/main/unicode-reader/Unicode%20Reader%20mockup%20with%20test%20buttons.PNG)
