const { app, ipcMain, BrowserWindow } = require('electron');
const { FileService } = require('./file.services');
const path = require('path');
const url = require("url");

const createWindow = async () => { 
  const mainWindow = new BrowserWindow({
    webPreferences: {
      nodeIntegration: true
    },
    width: 1500,
    height: 850,
  });

  mainWindow.loadURL(
    url.format({
      pathname: path.join(__dirname, './dist/file-explorer/index.html'),
      protocol: "file:",
      slashes: true
    })
  );

  // Open the DevTools.
  mainWindow.webContents.openDevTools();
  let fileService = new FileService(ipcMain);
  fileService.runEvent();
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

