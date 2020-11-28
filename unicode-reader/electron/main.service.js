let Parser = require('rss-parser');

class MainService {

    constructor(dbConnection, ipcMain) {
        this.feeds = [
            {title: 'All Articles', description: '', link:'https://blogs.embarcadero.com/feed/'},
            {title: 'Embarcadero Japanese Blog', description: '', link: 'https://blogs.embarcadero.com/ja/feed/'},
            {title: 'Embarcadero German Blog', description: '', link: 'https://blogs.embarcadero.com/de/feed/'},
            {title: 'Embarcadero Russian Blog', description: '', link: 'https://blogs.embarcadero.com/ru/feed/'},
            {title: 'Embarcadero Portuguese Blog', description: '', link: 'https://blogs.embarcadero.com/pt/feed/'},
            {title: 'Embarcadero English Blog', description: '', link: 'https://blogs.embarcadero.com/es/feed/'}
        ]

        this.dbConnection = dbConnection;
        this.ipcMain = ipcMain;
    }

    runEvent(){
        this.ipcMain.on('qryGetChannels', (event) => {
            let result = this.dbConnection.queryAsync('select * from channels');
            event.returnValue = result;
        });
    }

    async readRSS(){
        let parser = new Parser();
        let feed = await parser.parseURL(this.feeds[4].url);
        console.log(feed.title);
        feed.items.forEach(item => {
            console.log(item.title + ':' + item.link)
        });
    }

    async updateChannels() {
        for (let index = 0; index < this.feeds.length; index++) {
            const feed = this.feeds[index];
            let res = await this.dbConnection
                .queryAsync('insert into channels(title, description, link) '+
                            'values ($1::text, $2::text, $3::text) RETURNING *',
                            [feed.title, feed.description, feed.link]);
            console.log('--> ',res);
        }
    }

    clearChannels() {
        this.dbConnection.queryAsync('delete from channels');
    }

}

// const { DbConnection } = require('./db.connection');
// let dbConnection = new DbConnection();
// let msvc = new MainService(dbConnection, null);
// msvc.readRSS();
// msvc.updateChannels();
// delete msvc;

module.exports = {
    MainService: MainService
}