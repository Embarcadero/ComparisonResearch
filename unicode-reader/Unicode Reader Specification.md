# GitHub Recent Explorer
October 29, 2020

## Overview
The goal of the Unicode Reader is to build an RSS reader that brings in multiple RSS feeds which contain diverse Unicode characters and save the individual posts to a table in a PostgreSQL database. The posts can then be viewed and read in the Unicode Reader. This is a prototype! The emphasis of this project is on the lessons learned during the development process and documentation phase. The end result does not require a huge amount of polish but should look reasonably similar and function as closely as possible unless otherwise noted in this specification.

The goal of building the Unicode Reader is to explore the strengths and weaknesses of the framework you are using. The app should be built once to figure out your approach.  Once complete, build the app again while recording your screen.  Finally, document the app creation process in a step-by-step manner (similar to a recipe - what would someone else need to know to build the app in its entirety - configuration, code, testing, etc.).

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

### Feeds Schema
```
-- ----------------------------
-- Table structure for rssfeeds
-- ----------------------------

    FieldDefs = <
      item
        Name = 'Id'
        DataType = ftAutoInc
      end
      item
        Name = 'DateTime'
        DataType = ftDateTime
      end
      item
        Name = 'Title'
        DataType = ftWideString
        Size = 512
      end
      item
        Name = 'Link'
        DataType = ftWideString
        Size = 1024
      end
      item
        Name = 'Description'
        DataType = ftWideMemo
      end
      item
        Name = 'Author'
        DataType = ftWideString
        Size = 256
      end
      item
        Name = 'Guid'
        DataType = ftWideString
        Size = 512
      end
      item
        Name = 'Feed'
        DataType = ftWideString
        Size = 128
      end>
```
### Posts Schema

```
SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for rsscontent
-- ----------------------------
DROP TABLE IF EXISTS `rsscontent`;
CREATE TABLE `rsscontent` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `title` varchar(1024) DEFAULT NULL,
  `tstamp` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `description` mediumtext,
  `link` varchar(1024) DEFAULT NULL,
  `source` varchar(255) DEFAULT NULL,
  `hash` varchar(255) DEFAULT NULL,
  `viewed` int DEFAULT '0',
  `rank` int DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniquehash` (`hash`)
) ENGINE=InnoDB AUTO_INCREMENT=1577 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
SET FOREIGN_KEY_CHECKS=1;
```

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
### Electron Specific
The data layer of this application should be implemented with the main process and a renderer process in mind. For raw access to the data layer the [pg library](https://www.npmjs.com/package/pg) is the de facto standard.
