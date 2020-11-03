const { app, desktopCapturer, BrowserWindow, ipcMain } = require('electron');
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
    height: 800,
  });

  mainWindow.loadURL(
    url.format({
      pathname: path.join(__dirname, '../dist/screenshot-history/index.html'),
      protocol: "file:",
      slashes: true
    })
  );
  // mainWindow.loadFile(path.join(__dirname, 'index.html'));

  // Open the DevTools.
  mainWindow.webContents.openDevTools();
  let windows = [];
  // mainWindow.webContents.send("getWindows", windows);
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

ipcMain.on("windowList", (event, test) => {
  console.log('--> ', test);
});
