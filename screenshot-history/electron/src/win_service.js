const { desktopCapturer } = require('electron');

class WinService {
    SCWindows = [];
    constructor(mainWindow) {
        this.mainWindow = mainWindow;
    }

    run = () => {
        this.mainWindow.webContents.on('did-finish-load', () => {
            setInterval(() => { 
                desktopCapturer.getSources({ types:['window', 'screen'] }).then(async sources => {
                    this.SCWindows = [];
                    for (let source of sources) {
                        let win = {
                            name: source.name,
                            id: source.id,
                            // thumbnail: source.thumbnail,
                            display_id: source.display_id,
                            appIcon: source.appIcon
                        }
                        this.SCWindows.push(win);
                    }
                    this.sendSCWindows();
                });
            }, 1000);
        });
    }

    sendSCWindows = () => {
        // console.log('this.SCWindows: ', this.SCWindows);
        this.mainWindow.webContents.send("getWindows", this.SCWindows);
    }
}

module.exports = {
    WinService: WinService
}