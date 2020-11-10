const { app, desktopCapturer, BrowserWindow } = require('electron');
const { WinService } = require('./win_service');
const path = require('path');
const url = require("url");

if (require('electron-squirrel-startup')) { 
  app.quit();
}

const createWindow = () => { 
  const mainWindow = new BrowserWindow({
    webPreferences: {
      nodeIntegration: true
    },
    width: 1080,
    height: 850,
  });

  mainWindow.loadURL(
    url.format({
      pathname: path.join(__dirname, '../dist/screenshot-history/index.html'),
      protocol: "file:",
      slashes: true
    })
  );

  // Open the DevTools.
  mainWindow.webContents.openDevTools();
  // 
  let winService = new WinService(mainWindow);
  winService.run();
};

app.on('ready', createWindow);
app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') {
    app.quit();
  }
});

app.on('activate', () => {
  if (BrowserWindow.getAllWindows().length === 0) {
    createWindow();
  }
});

