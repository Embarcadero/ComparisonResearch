const { app, ipcMain, BrowserWindow } = require('electron');
const { MainService } = require('./main.service');
const { DbConnection } = require('./db.connection');
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
  mainWindow.setMenu(null);

  mainWindow.loadURL(
    url.format({
      pathname: path.join(__dirname, './dist/unicode-reader/index.html'),
      protocol: "file:",
      slashes: true
    })
  );

  // Open the DevTools.
  // mainWindow.webContents.openDevTools();

  let dbConnection = new DbConnection();
  let mainService = new MainService(dbConnection, ipcMain);
  mainService.runEvent();
  let init = async () => {
      await dbConnection.dropCreate();
  }  
  init();
};

if (process.platform === 'linux') {
  app.disableHardwareAcceleration();
}
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

