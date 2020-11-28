let Parser = require('rss-parser');

class MainService {

    constructor(dbConnection, ipcMain) {
        this.dbConnection = dbConnection;
        this.ipcMain = ipcMain;
    }

    run(){
        ipcMain.on('qryGetChannels', (event) => {
            let result = this.dbConnection.queryAsync('select * from channels');
            event.returnValue = result;
        });
    }

    async readRSS(){
        let parser = new Parser();
        let feed = await parser.parseURL('https://blogs.embarcadero.com/ja/feed/');
        console.log(feed.title);
    }

}

let msvc = new MainService();
msvc.readRSS();

module.exports = {
    MainService: MainService
}