const { desktopCapturer } = require('electron');

type SCWindow = {
    name: string
}

export class WinService {
    SCWindows: Array<SCWindow>;
    constructor() {

    }

    getSCWindows = (mainWindow) => {
        mainWindow.webContents.on('did-finish-load', () => {
            desktopCapturer.getSources({ types:['window', 'screen'] }).then(async sources => {
                for (let source of sources) {
                    console.log("Window name " + source);
                    this.SCWindows.push(source);
                }
            });
        });
    }
}