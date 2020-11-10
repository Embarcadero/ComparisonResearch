const { ReadVarExpr } = require('@angular/compiler');
const { desktopCapturer, ipcMain } = require('electron');

class WinService {
    SCWindows = [];
    constructor(mainWindow) {
        this.mainWindow = mainWindow;
    }

    run = () => {
        this.mainWindow.webContents.on('did-finish-load', () => {
            setInterval(() => { 
                desktopCapturer.getSources({ types:['window', 'screen'], thumbnailSize:  {width: 480, height: 270}}).then(async sources => {
                    this.SCWindows = [];
                    for (let source of sources) {
                        let scWindow = {
                            name: source.name,
                            id: source.id,
                            dataUrl: source.thumbnail.toDataURL(),
                            display_id: source.display_id,
                            appIcon: source.appIcon
                        }
                        this.SCWindows.push(scWindow);
                    }
                    this.sendSCWindows();
                });
            }, 1000);
        });

        ipcMain.on('reqWindow', (event, name) => {
            this.getFullscreenScwindow(name,(scWindow) => {
                console.log('sendWindow: ', scWindow.name);
                event.returnValue = scWindow;
            });
        });
    }

    getFullscreenScwindow = (name, callback) => {
        desktopCapturer.getSources({ types:['window', 'screen'], thumbnailSize:  {width: 1920, height: 1080}}).then(sources => {
            for (let source of sources) {
                if (source.name === name) {
                    let scWindow = {
                        name: source.name,
                        id: source.id,
                        dataUrl: source.thumbnail.toDataURL(),
                        display_id: source.display_id,
                        appIcon: source.appIcon
                    }
                    return callback(scWindow);
                }
            }
        })
    }

    sendSCWindows = (name) => {
        this.mainWindow.webContents.send("getWindows", this.SCWindows);
    }

    sendSCWindow = (name) => {
        this.getFullscreenScwindow(name,(scWindow) => {
            this.mainWindow.webContents.send("getWindow", scWindow);
        })
    }

}

module.exports = {
    WinService: WinService
}