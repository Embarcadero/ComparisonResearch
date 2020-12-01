// Modules to control application life and create native browser window
const {app, BrowserWindow} = require('electron')
const {ipcMain, Menu, dialog, globalShortcut, nativeImage, Tray, webContents, screen} = require('electron')
const os = require('os');
const path = require('path');

// Keep a global reference of the window object, if you don't, the window will
// be closed automatically when the JavaScript object is garbage collected.
let mainWindow

function createWindow () {
  // Create the browser window.
  let ready = false;
  let loaded = false;

  if (os.type() === 'Linux') {
    let icoPath = path.resolve(__dirname, './$(IconFileLinux)');
    mainWindow = new BrowserWindow({ width: 0, height: 0, show: false, webPreferences: { nodeIntegration: true }, useContentSize: true, icon: icoPath})
  } else {
    mainWindow = new BrowserWindow({ width: 0, height: 0, show: false, webPreferences: { nodeIntegration: true }, useContentSize: true})
  }

  if ('$(Mode)' === 'Release') {
    Menu.setApplicationMenu(null);
  }

  // and load the index.html of the app.
  let prjPath = path.resolve(__dirname, './$(ProjectHTML)')
  mainWindow.loadFile(prjPath);

  // Avoid showing a blank window until the contents are loaded
  mainWindow.on('ready-to-show', function () {
    ready = true;
	if (loaded) {
      mainWindow.show()
	}
  })

  mainWindow.webContents.on('did-finish-load', function () {
    loaded = true;
	if (ready) {
      mainWindow.show()
	}
  })

   // Emitted when the window is closed.
  mainWindow.on('closed', function () {
    // Dereference the window object, usually you would store windows
    // in an array if your app supports multi windows, this is the time
    // when you should delete the corresponding element.
    mainWindow = null
  })
}

// This method will be called when Electron has finished
// initialization and is ready to create browser windows.
// Some APIs can only be used after this event occurs.
app.on('ready', createWindow)

// Quit when all windows are closed.
app.on('window-all-closed', function () {
  // On macOS it is common for applications and their menu bar
  // to stay active until the user quits explicitly with Cmd + Q
  if (process.platform !== 'darwin') {
    app.quit()
  }
})

app.on('activate', function () {
  // On macOS it's common to re-create a window in the app when the
  // dock icon is clicked and there are no other windows open.
  if (mainWindow === null) {
    createWindow()
  }
})

var commChannels = []

app.on('will-quit', () => {
  // Unregister all remaining shortcuts.
  globalShortcut.unregisterAll()
  ipcMain.removeAllListeners("ondragstart");
  commChannels.forEach((element) => {
    ipcMain.removeAllListeners(element);
  })
})

//IPC handlers

//Main menu
function getKeyByValue(object, value) {
  return Object.keys(object).find(key => object[key] === value);
}

ipcMain.handle("ipc-create-main-menu", (event, args) => {
  let buildMenu = args;

  function AssignClick(data) {
    data.forEach(function (element){
      for (elementItem in element) {
        if (elementItem == "submenu") {
          AssignClick(element[elementItem]);
        }
      }

      element.click = function(ev){
        mainWindow.webContents.send("ipc-handle-menu-click", ev.id);
      };
    });
  }

  AssignClick(buildMenu);
  let menu = Menu.buildFromTemplate(buildMenu);
  Menu.setApplicationMenu(menu);
});

//Popup menu
var popupMenus = {};

ipcMain.handle("ipc-create-popup-menu", (event, arr) => {
  let popupmenuSender = event.sender;
  let m = arr[0];

  function AssignClick(data) {
    data.forEach(function (element){
      for (elementItem in element) {
        if (elementItem == "submenu") {
          AssignClick(element[elementItem]);
        }
      }

      element.click = function(ev){
        let popupId = getKeyByValue(popupMenus, ev.menu);
        popupmenuSender.send("ipc-handle-popup-click" + popupId, element.id);
      };
    });
  }

  AssignClick(m);
  let popupmenu = Menu.buildFromTemplate(m);
  popupMenus[arr[1]] = popupmenu;
});

ipcMain.handle("ipc-popup-menu-popup", (event, arr) => {
  let bw = BrowserWindow.fromWebContents(event.sender);
  let popupmenu = popupMenus[arr[2]];
  popupmenu.popup({window: bw, x: arr[0], y: arr[1]});
  return true;
});

ipcMain.handle("ipc-close-popup-menu", (event, arg) => {
  let bw = BrowserWindow.fromWebContents(event.sender);
  let popupmenu = popupMenus[arg];
  popupmenu.closePopup({browserWindow: bw});
})

ipcMain.handle("ipc-remove-popup-menu", (event, arg) => {
  delete popupMenus[arg];
})

//Tray icon
var trayIcons = {};

ipcMain.handle("ipc-tray-create", (event, args) => {
  let trayicon;
  let nImg = new nativeImage.createFromDataURL(args[1]);
  let trayObj = trayIcons[args[0]];
  if (trayObj == undefined) {
    trayicon = new Tray(nImg);
    trayicon.on("click", (ev, bounds, position) => {
      let traySender = ev.sender;
      Object.keys(trayIcons).forEach((key, i) => {
        if (trayIcons[key].icon == traySender) {
          trayIcons[key].webContent.send("ipc-tray-click" + key);
        }
      })
    })
  } else {
    trayicon = trayObj.icon;
    trayicon.setImage(nImg);
  }
  trayicon.setToolTip(args[2]);
  if (args.length > 3) {
    trayicon.setContextMenu(popupMenus[args[3]]);
  }
  trayIcons[args[0]] = {icon: trayicon, webContent: event.sender};
})

ipcMain.handle("ipc-tray-destroy", (event, arg) => {
  trayIcons[arg].icon.destroy();
  delete trayIcons[arg];
})

//Dialogs

ipcMain.handle("ipc-dialog-opendialog-async", (event, args) => {
  let openDialogSender = event.sender;
  dialog.showOpenDialog(args).then((res) => {
    openDialogSender.send("ipc-dialog-opendialog-response", res);
  });
});

ipcMain.handle("ipc-dialog-savedialog-async", (event, args) => {
  let saveDialogSender = event.sender;
  dialog.showSaveDialog(args).then((res) => {
    saveDialogSender.send("ipc-dialog-savedialog-response", res);
  });
});

ipcMain.handle("ipc-dialog-messagebox-async", (event, args) => {
  let opt = args[0];
  opt.icon = nativeImage.createFromDataURL(args[1])
  let saveDialogSender = event.sender;
  dialog.showMessageBox(opt).then((res) => {
    saveDialogSender.send("ipc-dialog-messagebox-response", res);
  });
});

ipcMain.handle("ipc-dialog-errorbox", (event, args) => {
  dialog.showErrorBox(args[0], args[1]);
})

//Paths

ipcMain.handle("ipc-init-electronpath", (event) => {
  let resObj = new Object();
  resObj["appData"] = app.getPath("appData");
  resObj["appPath"] = app.getAppPath();
  resObj["desktop"] = app.getPath("desktop");
  resObj["documents"] = app.getPath("documents");
  resObj["downloads"] = app.getPath("downloads");
  resObj["exe"] = app.getPath("exe");
  resObj["home"] = app.getPath("home");
  resObj["music"] = app.getPath("music");
  resObj["pictures"] = app.getPath("pictures");
  resObj["temp"] = app.getPath("temp");
  resObj["userData"] = app.getPath("userData");
  resObj["videos"] = app.getPath("videos");
  return resObj;
})

//Window functions

ipcMain.handle("ipc-window-function-quit", (event) => {
  app.quit();
});

ipcMain.handle("ipc-window-function-close-devtools", (event) => {
  event.sender.closeDevTools();
});

ipcMain.handle("ipc-window-function-close", (event) => {
  BrowserWindow.fromWebContents(event.sender).close();
});

ipcMain.handle("ipc-window-function-copy", (event) => {
  event.sender.copy();
});

ipcMain.handle("ipc-window-function-copy-image", (event, args) => {
  event.sender.copyImageAt(args[0], args[1]);
});

ipcMain.handle("ipc-window-function-cut", (event) => {
  event.sender.cut();
});

ipcMain.handle("ipc-window-function-delete", (event) => {
  event.sender.delete();
});

ipcMain.handle("ipc-window-function-downloadurl", (event, args) => {
  event.sender.downloadURL(args);
});

ipcMain.handle("ipc-window-function-open-devtools", (event) => {
  event.sender.openDevTools();
});

ipcMain.handle("ipc-window-function-paste", (event) => {
  event.sender.paste();
});

ipcMain.handle("ipc-window-function-redo", (event) => {
  event.sender.redo();
});

ipcMain.handle("ipc-window-function-reload", (event) => {
  event.sender.reload();
});

ipcMain.handle("ipc-window-function-replace", (event, args) => {
  event.sender.replace(args);
});

ipcMain.handle("ipc-window-function-replace-misspelling", (event, args) => {
  event.sender.replaceMisspelling(args);
});

ipcMain.handle("ipc-window-function-select-all", (event) => {
  event.sender.selectAll();
});

ipcMain.handle("ipc-window-function-toggle-devtools", (event) => {
  event.sender.toggleDevTools();
});

ipcMain.handle("ipc-window-function-undo", (event) => {
  event.sender.undo();
});

ipcMain.handle("ipc-window-function-unselect", (event) => {
  event.sender.unselect();
});

//Global shortcut
ipcMain.handle("ipc-global-shortcut-register", (event, args) => {
  globalShortcut.register(args[0], () => {
    mainWindow.webContents.send("ipc-global-shortcut-invoked" + args[1]);
  })
});

//Drag and drop
var icons = {};

ipcMain.on("ondragstart", (ev, path) => {
  let pathToIcon = icons[ev.sender.id];
    if (pathToIcon !== '') {
      ev.sender.send("ipc-dragdrop-dragcallback");
      ev.sender.startDrag({
        file: path,
        icon: pathToIcon
      })
    }
});

ipcMain.handle("ipc-dragdrop-icon", (event, args) => {
  let iconPath = args;
  icons[event.sender.id] = iconPath;
});

ipcMain.handle("ipc-dragdrop-remove", (event) => {
  delete icons[event.sender.id];
})

//Browser window

ipcMain.handle("ipc-browserwindow-create", (event, args) => {
  let parentWindow = BrowserWindow.fromWebContents(event.sender);
  let didFinishLoad = false
  let readyToShow = false;
  let obj = args;
  let img = nativeImage.createFromDataURL(obj.icon);
  let bw = new BrowserWindow({parent: parentWindow, width: 0, height: 0, show: false, useContentSize: true, webPreferences: { nodeIntegration: true },
                              fullscreenable: obj.fullscreenable, fullscreen: obj.fullscreen, kiosk: obj.kiosk, resizable: obj.resizable,
                              minWidth: obj.minWidth, minHeight: obj.minHeight, modal: obj.modal, icon: img});

  bw.removeMenu();

  if (obj.maxHeight !== 0) {
    bw.setMaximumSize(bw.getMaximumSize()[0], obj.maxHeight);
  };

  if (obj.maxWidth !== 0) {
    bw.setMaximumSize(obj.maxWidth, bw.getMaximumSize()[1]);
  };

  if (obj.url !== '') {
    bw.loadURL(obj.url);
  };

  bw.on('show', (event) => {
    let senderBW = BrowserWindow.fromWebContents(event.sender.webContents);
    senderBW.getParentWindow().webContents.send('ipc-browserwindow-show-event' + event.sender.id);
  });

  bw.on('focus', (event) => {
    let senderBW = BrowserWindow.fromWebContents(event.sender.webContents);
    senderBW.getParentWindow().webContents.send('ipc-browserwindow-activate-event' + event.sender.id);
  });

  bw.on('hide', (event) => {
    let senderBW = BrowserWindow.fromWebContents(event.sender.webContents);
    senderBW.getParentWindow().webContents.send('ipc-browserwindow-hide-event' + event.sender.id);
  });

  bw.on('resize', (event) => {
    let senderBW = BrowserWindow.fromWebContents(event.sender.webContents);
    senderBW.getParentWindow().webContents.send('ipc-browserwindow-resize-event' + event.sender.id, [bw.getSize()[0], bw.getSize()[1]]);
  });

  bw.on('minimize', (event) => {
    let senderBW = BrowserWindow.fromWebContents(event.sender.webContents);
    senderBW.getParentWindow().webContents.send('ipc-browserwindow-minimize-event' + event.sender.id);
  });

  bw.on('maximize', (event) => {
    let senderBW = BrowserWindow.fromWebContents(event.sender.webContents);
    senderBW.getParentWindow().webContents.send('ipc-browserwindow-maximize-event' + event.sender.id);
  });

  bw.on('blur', (event) => {
    let senderBW = BrowserWindow.fromWebContents(event.sender.webContents);
    senderBW.getParentWindow().webContents.send('ipc-browserwindow-deactivate-event' + event.sender.id);
  });

  bw.on('enter-full-screen', (event) => {
    let senderBW = BrowserWindow.fromWebContents(event.sender.webContents);
    senderBW.getParentWindow().webContents.send('ipc-browserwindow-fullscreen-event' + event.sender.id);
  });

  bw.on('leave-full-screen', (event) => {
    let senderBW = BrowserWindow.fromWebContents(event.sender.webContents);
    senderBW.getParentWindow().webContents.send('ipc-browserwindow-exit-fullscreen-event' + event.sender.id);
  });

  bw.on('enter-html-full-screen', (event) => {
    let senderBW = BrowserWindow.fromWebContents(event.sender.webContents);
    senderBW.getParentWindow().webContents.send('ipc-browserwindow-fullscreen-event' + event.sender.id);
  });

  bw.on('leave-html-full-screen', (event) => {
    let senderBW = BrowserWindow.fromWebContents(event.sender.webContents);
    senderBW.getParentWindow().webContents.send('ipc-browserwindow-exit-fullscreen-event' + event.sender.id);
  });

  bw.once('ready-to-show', () => {
    readyToShow = true;
    if (didFinishLoad) {
      bw.show();
    };
  });

  bw.webContents.on('did-finish-load', (event) => {
    didFinishLoad = true;
    if (readyToShow) {
      bw.show();
    };
  });

  bw.on('close', (event) => {
    let senderBW = BrowserWindow.fromWebContents(event.sender.webContents);
    senderBW.getParentWindow().webContents.send('ipc-browserwindow-close-event' + event.sender.id);
    senderBW.getParentWindow().focus();
  });

  return bw.id;
});

ipcMain.handle("ipc-browserwindow-close", (event, args) => {
  BrowserWindow.fromId(args).close();
})

ipcMain.handle("ipc-browserwindow-force-close", (event, args) => {
  BrowserWindow.fromId(args).destroy();
})

ipcMain.handle("ipc-browserwindow-hide", (event, args) => {
  BrowserWindow.fromId(args).hide();
})

ipcMain.handle("ipc-browserwindow-load-url", (event, args) => {
  BrowserWindow.fromId(args[0]).loadURL(args[1]);
})

ipcMain.handle("ipc-browserwindow-message-to-channel", (event, args) => {
  BrowserWindow.fromId(args[0]).webContents.send(args[1], args[2]);
})

ipcMain.handle("ipc-browserwindow-set-fullscreen", (event, args) => {
  BrowserWindow.fromId(args[0]).setFullScreen(args[1]);
})

ipcMain.handle("ipc-browserwindow-set-fullscreenable", (event, args) => {
  BrowserWindow.fromId(args[0]).fullScreenable = args[1];
})

ipcMain.handle("ipc-browserwindow-set-kiosk", (event, args) => {
  BrowserWindow.fromId(args[0]).setKiosk(args[1]);
})

ipcMain.handle("ipc-browserwindow-set-maxsize", (event, args) => {
  BrowserWindow.fromId(args[0]).setMaximumSize(args[1], args[2]);
})

ipcMain.handle("ipc-browserwindow-set-minsize", (event, args) => {
  BrowserWindow.fromId(args[0]).setMinimumSize(args[1], args[2]);
})

ipcMain.handle("ipc-browserwindow-set-resizable", (event, args) => {
  BrowserWindow.fromId(args[0]).resizable = args[1];
})

ipcMain.handle("ipc-browserwindow-show", (event, args) => {
  let bw = BrowserWindow.fromId(args[0]);
  if (bw.isModal() == args[1]) {
    bw.show();
    return true;
  } else {
    bw.destroy();
    return false;
  }
})

//Electron form

ipcMain.handle("ipc-resize-window", (event, args) => {
  let x = (screen.getPrimaryDisplay().size.width - args[0]) / 2;
  let y = (screen.getPrimaryDisplay().size.height - args[1]) / 2;
  BrowserWindow.fromWebContents(event.sender).setContentBounds({ x: Math.round(x), y: Math.round(y), width: args[0], height: args[1] })
})

//IPC communication
var commWebContents = [];

ipcMain.handle("ipc-communication-to-parent", (event, args) => {
  let senderBW = BrowserWindow.fromWebContents(event.sender);
  senderBW.getParentWindow().webContents.send('from-child' + senderBW.id, args);
})

const shallowCompare = (obj1, obj2) =>
  Object.keys(obj1).length === Object.keys(obj2).length &&
  Object.keys(obj1).every(key => obj1[key] === obj2[key]);

ipcMain.handle("ipc-communication-remove", (event, args) => {
  let ind = -1;
  let commObj = {obj: event.sender, channel: args}
  commWebContents.forEach(function(element, i) {
    if (shallowCompare(element, commObj)) {
      ind = i;
    }
  })
  if (ind > -1) {
    commWebContents.splice(ind, 1);
  }
})

ipcMain.handle("ipc-communication-setup", (event, args) => {
  let included = false;
  let commObj = {obj: event.sender, channel: args};
  commWebContents.forEach(function(element) {
    if (shallowCompare(element, commObj)) {
      included = true;
    }
  })
  if (!included) {
    commWebContents.push(commObj);
  }
  let channel = args;
  //add listener ONCE
  if (ipcMain.listenerCount(channel) == 0) {
    ipcMain.on(channel, (ev, args) => {
      commChannels.push(channel);
      let toChannel = args[0];
      let msg = args[1];
      commWebContents.forEach(function(element) {
        if (element.channel == toChannel) {
          element.obj.send(toChannel, msg);
        }
      })
    })
  }
})

ipcMain.handle("ipc-init-os-type", (event) => {
  return os.type();
});

// In this file you can include the rest of your app's specific main process
// code. You can also put them in separate files and require them here.
