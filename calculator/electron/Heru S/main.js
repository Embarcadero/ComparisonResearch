const { app, BrowserWindow } = require('electron');
const path = require("path");
const url = require("url");

function createWindow () {
  const win = new BrowserWindow({
    width: 500,
    height: 485,
    vibrancy: 'ultra-dark',
    webPreferences: {
      nodeIntegration: true
    }
  })

  win.setOpacity(10);
  win.loadURL(
    url.format({
      pathname: path.join(__dirname, '/dist/calculator/index.html'),
      protocol: "file:",
      slashes: true
    })
  );
  win.webContents.openDevTools()
}

app.whenReady().then(createWindow)

app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') {
    app.quit()
  }
})

app.on('activate', () => {
  if (BrowserWindow.getAllWindows().length === 0) {
    createWindow()
  }
})