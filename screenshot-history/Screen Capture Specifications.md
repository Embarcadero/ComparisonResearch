# Screen Capture
October 29, 2020

## Overview
The goal of the Screen Capture project is to build an application that lets the user capture a screen of their choice, resize and crop the captures, and save or export the result.  This application will also show the user a history of recent captures with timestamps and allow for them to be loaded and modified.  This is a prototype! The emphasis of this project is on the lessons learned during the development process and documentation phase. The end result does not require a huge amount of polish but should look reasonably similar and function as closely as possible unless otherwise noted in this specification.
The goal of building the Screen Capture app is to explore the strengths and weaknesses of the framework you are using. The app should be built once to figure out your approach.  Once complete, build the app again while recording your screen.  Finally, document the app creation process in a step-by-step manner (similar to a recipe - what would someone else need to know to build the app in its entirety - configuration, code, testing, etc.).

### Key Features
- Platform API screen access
- Transparent Window (on Windows)
- File system access
- Image manipulation

## Requirements
### Layout
The Screenshot App will show available screens to capture on the top third of the window.  Any screen the user selects will be displayed in the lower two-thirds of the window.  Once the user presses the capture button, the application will change into an editor with buttons that enable resizing, cropping, saving, and exporting.  At any point, the user can select a toolbar option to view their recent capture history which will replace the current screen view in the top third of the window and allow the user to scroll through time stamped captures and select one for editing/saving/exporting.


### Theme
The Screenshot App should look similar to the window shown below. 

![](https://github.com/Embarcadero/ComparisonResearch/blob/main/screenshot-history/screencap.png)


## Deliverables
### Project Items

1. Complete source code for your working Screen Capture app.  Include a compiled executable if applicable or instructions for executing the code if not.
2. A video capture of the second build process.  This must be in real-time (not sped up) and executed manually (without auto-typing or other speed features).  The intent is to get a realistic view of the effort required to make this Screen Capture app by a competent programmer.
3. A document with step-by-step instructions that walk someone unfamiliar with your development environment, tools, and language through the process of building this Screen Capture app to its full functionality.  This document can be a .docx, .pdf, or Google Document format.  Markdown usage is preferred.



### Iterative Feedback
Please provide feedback to us during the development process so we can help speed up the development. We have many many years of experience and are here to help you get the project done as fast as possible.

## Helpful Tips

### Delphi Specific

Screenshot:

<https://stackoverflow.com/questions/22430706/delphi-7-screenshot-without-capturing-form-windows-8-dwm-exe>

Store images in TFDMemTable Blob:

<https://stackoverflow.com/questions/13863169/load-and-save-image-from-blob-field-in-delphi-using-firebird>

Crop Image:

<https://stackoverflow.com/questions/34226133/how-to-draw-a-selection-rectangle-between-onmousedown-and-onmouseup>

<https://stackoverflow.com/questions/9183524/delphi-how-do-i-crop-a-bitmap-in-place>

Resize Image:

<https://www.thoughtco.com/resize-an-image-creating-thumbnail-graphics-1058071>

Save To File:

<http://docwiki.embarcadero.com/Libraries/Sydney/en/Vcl.ExtDlgs.TSavePictureDialog>

### Electron Specific

The data layer of this application should be implemented with the main process and a renderer process in mind.
For the data access portion of the application the [SQLite](https://www.npmjs.com/package/sqlite) library provides a lot of flexibility. It uses a promise based API and wraps any implementation of your choice.

[This GitHub repo](https://github.com/hokein/electron-sample-apps/tree/master/desktop-capture) can be used for code reference. 

[Semi transparency window demo](https://www.electronjs.org/apps/glass-browser) can be used for code reference.

#### Electron Forge

To abstract away some of the common headaches of distributing and updating an application. Whether it be through an "app store" or not.
[Electron Forge](https://www.electronforge.io) could be used as it is very easy to get started with and it provides a lot of features out of the box.
Updates can be published through either update.electronjs.org (if the application is public and meets all the criteria) or custom update servers.
[Electron Forge](https://www.electronforge.io) provides an easy to use system for either one (publish targets).

To get started:

```sh
npx create-electron-app screenshot-history
```
