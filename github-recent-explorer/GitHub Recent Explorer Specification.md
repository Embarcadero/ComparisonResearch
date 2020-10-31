# GitHub Recent Explorer
October 29, 2020

## Overview
The goal of the GitHub Recent Explorer project is to build a REST client for GitHub that displays the most recent projects that have been created in the last week by language. This is a prototype! The emphasis of this project is on the lessons learned during the development process and documentation phase. The end result does not require a huge amount of polish but should look reasonably similar and function as closely as possible unless otherwise noted in this specification.

The goal of building the GitHub Recent Explorer is to explore the strengths and weaknesses of the framework you are using. The app should be built once to figure out your approach.  Once complete, build the app again while recording your screen.  Finally, document the app creation process in a step-by-step manner (similar to a recipe - what would someone else need to know to build the app in its entirety - configuration, code, testing, etc.).

## Requirements
### Theme
The GitHub Recent Explorer should feature a look similar to the below with a two tone theme.

![](https://github.com/Embarcadero/ComparisonResearch/blob/main/github-recent-explorer/githubRecentExplorer.png)

### Layout
The GitHub Recent Explorer project is broken down into two sections. The far left section which is a list of programming languages with a search field at the top. The search field should combine with the language to create the search string (see the API). The rest of the client area should be taken up with the results of the search. The results don’t need to look exactly like they are displayed. Just something similar.
The hamburger menu should show and hide the sidebar. There are two filter fields at the top right for changing the sort and the starting date of the created filter.

### GitHub API
This API snippet is PHP but is the endpoint we want to use. 
```
‘https://api.github.com/search/repositories?q=language:Pascal+created:'.date('Y-m-d', mktime(0, 0, 0, date("m"), date("d")-7, date("Y"))).'T00:00:00-07:00..'.date('Y-m-d').'T00:00:00-07:00&sort=stars&order=desc’
```
GitHub API documentation is found [here](https://docs.github.com/en/free-pro-team@latest/rest/reference/search).

### Simple REST App
The GitHub Recent Explorer is a sample REST application with 1-2 REST calls to GitHub. It makes the calls and displays the results.


## Deliverables
### Project Items

1. Complete source code for your working REST app.  Include a compiled executable if applicable or instructions for executing the code if not.
2. A video capture of the second build process.  This must be in real-time (not sped up) and executed manually (without auto-typing or other speed features).  The intent is to get a realistic view of the effort required to make this REST app by a competent programmer.
3. A document with step-by-step instructions that walk someone unfamiliar with your development environment, tools, and language through the process of building this REST app to its full functionality.  This document can be a .docx, .pdf, or Google Document format.  Markdown usage is preferred.


### Iterative Feedback
Please provide feedback to us during the development process so we can help speed up the development. We have many many years of experience and are here to help you get the project done as fast as possible.

## Helpful Tips
### Electron Specific
Browsing public repositories could be implemented as a pure sandboxed web app using the fetch API.

#### Electron Forge

To abstract away some of the common headaches of distributing and updating an application. Whether it be through an "app store" or not.
[Electron Forge](https://www.electronforge.io) could be used as it is very easy to get started with and it provides a lot of features out of the box.
Updates can be published through either update.electronjs.org (if the application is public and meets all the criteria) or custom update servers.
[Electron Forge](https://www.electronforge.io) provides an easy to use system for either one (publish targets).

To get started:

```sh
npx create-electron-app github-recent-explorer
```
