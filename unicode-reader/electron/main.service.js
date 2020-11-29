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
            this.dbConnection.query('select * from channels', [], (err, result)=>{
                event.returnValue = result.rows;
            });
        });
    }

    async readRSS(url){
        let parser = new Parser();
        let feed = await parser.parseURL(url);
        return feed;
    }

    async updateArticles(channelId){
                
    }

    async updateChannels() {
        for (let index = 0; index < this.feeds.length; index++) {
            const feed = this.feeds[index];
            let res = await this.dbConnection
                .queryAsync('insert into channels(title, description, link) '+
                            'values ($1::text, $2::text, $3::text) RETURNING *',
                            [feed.title, feed.description, feed.link]);
            this.updateArticles(res)
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