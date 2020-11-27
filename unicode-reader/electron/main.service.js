const { DbConnection } = require('./db.connection');
const { ipcMain } = require('electron');
let Parser = require('rss-parser');

class MainService {

    run = () => {
        this.dbConnection = new DbConnection();
        ipcMain.on('qryGetChannels', (event) => {
            let result = this.dbConnection.queryAsync('select * from channels');
            event.returnValue = result;
        });
    }

    readRSS = async () => {
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