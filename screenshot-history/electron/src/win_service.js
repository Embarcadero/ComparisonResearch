const { desktopCapturer } = require('electron');

class WinService {
    SCWindows = [];
    constructor(mainWindow) {
        this.mainWindow = mainWindow;
    }

    run = () => {
        this.mainWindow.webContents.on('did-finish-load', () => {
            setInterval(() => { 
                desktopCapturer.getSources({ types:['window', 'screen'], thumbnailSize:  {width: 1920, height: 1080}}).then(async sources => {
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
    }

    sendSCWindows = () => {
        this.mainWindow.webContents.send("getWindows", this.SCWindows);
    }

}

module.exports = {
    WinService: WinService
}