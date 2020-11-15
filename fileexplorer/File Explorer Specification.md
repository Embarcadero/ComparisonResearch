# File Explorer
October 29, 2020

## Overview
The goal of the FileExplorer project is to build and learn from a generic file explorer. This is a prototype! The emphasis of this project is on the lessons learned during the development process and documentation phase. The end result does not require a huge amount of polish but should look reasonably similar and function as closely as possible unless otherwise noted in this specification.

The goal of building the File Explorer is to explore the strengths and weaknesses of the framework you are using. The app should be built once to figure out your approach.  Once complete, build the app again while recording your screen.  Finally, document the app creation process in a step-by-step manner (similar to a recipe - what would someone else need to know to build the app in its entirety - configuration, code, testing, etc.).

### Key Features
- File system access
- Platform APIs
- Treeview
- Grid

## Requirements
### Theme
The Calculator should feature a look similar to the below. Note the brighter color palette for number, digit, and sign buttons, darker pallet for operator/function buttons, and dark grey pallet for the display field.  The “equals” button is a cornflower blue shade.  All buttons but the equals button change to a darker grey shade when the mouse rolls over and becomes darker again when clicked.  The equals button has the same behavior but in blue shades.  
Note that the window and controls are semi transparent.
![](https://github.com/Embarcadero/ComparisonResearch/blob/main/fileexplorer/filebrowser.png)

### File System API
The browser should be able to get a directory listing and place it in a treeview. It should list the contents of each directory and be able to search recursively based on the current directory.
### Search Results
There is to be a Search bar at the top (see layout). Searching via the search bar does a recursive search starting in the current directory and displaying the results in the FileView.
### Layout
The File Explorer is broken down into two sections. The far left section is a standard treeview of directories starting at the root drive. It should have folder icons for each record. The folders are expandable in the treeview. The rest of the client should be taken up with the list of files in the selected directory. At the bottom there are tabs. Each tab will have it’s own treeview/fileview. There is a button at the  bottom right that allows you to create tabs.
Above the TreeView and the FileView there should be a Edit box on the left which shows the path of the current directory. The Edit box on the right side should be a search box that executes when it is focused and the Enter key is pressed. The results of the search should appear in the filelist area.

### FileList
The file list area should be 4 columns featuring the Name, Date Modified, Type, and Size of each file in the list.


## Deliverables
### Project Items

1. Complete source code for your working file explorer.  Include a compiled executable if applicable or instructions for executing the code if not.
2. A video capture of the second build process.  This must be in real-time (not sped up) and executed manually (without auto-typing or other speed features).  The intent is to get a realistic view of the effort required to make this file explorer by a competent programmer.
3. A document with step-by-step instructions that walk someone unfamiliar with your development environment, tools, and language through the process of building this file explorer to its full functionality.  This document can be a .docx, .pdf, or Google Document format.  Markdown usage is preferred.

### Iterative Feedback
Please provide feedback to us during the development process so we can help speed up the development. We have many many years of experience and are here to help you get the project done as fast as possible.

## Helpful Tips
### Delphi Specific
[File Associations](https://stackoverflow.com/questions/829843/how-to-get-icon-and-description-from-file-extension-using-delphi)


### Electron Specific

For security and flexibility's sake this application should be implemented with the main process and renderer processes in mind. The renderer processes would obtain file system information from the main process using [IPC](https://www.electronjs.org/docs/api/ipc-main). This allows the renderer processes to be sandboxed and disconnected from the file system.

[Drag and drop](https://www.electronjs.org/docs/tutorial/native-file-drag-drop) would likewise use the IPC approach.

The main process can access the file system using the standard node modules.
https://nodejs.org/api/fs.html
https://nodejs.org/api/path.html

If we need to monitor the file system for changes, [chokidar](https://www.npmjs.com/package/chokidar) is an excellent library.

Here are two similar projects. Check and see how they built it and then you can do something similar as far as the file system API calls. 
https://medium.com/quasar-framework/building-an-electron-file-explorer-with-quasar-and-vue-7bf94f1bbf6
https://github.com/hokein/electron-sample-apps/tree/master/file-explorer

#### Electron Forge

To abstract away some of the common headaches of distributing and updating an application. Whether it be through an "app store" or not.
[Electron Forge](https://www.electronforge.io) could be used as it is very easy to get started with and it provides a lot of features out of the box.
Updates can be published through either update.electronjs.org (if the application is public and meets all the criteria) or custom update servers.
[Electron Forge](https://www.electronforge.io) provides an easy to use system for either one (publish targets).

To get started:

```sh
npx create-electron-app file-explorer
```
