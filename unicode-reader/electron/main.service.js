let Parser = require('rss-parser');

class MainService {

    constructor(dbConnection, ipcMain) {
        this.feeds = [
            {title: 'All Articles', description: 'All Articles', link:'https://blogs.embarcadero.com/feed/'},
            {title: 'Embarcadero Japanese Blog', description: 'Japanese Blog', link: 'https://blogs.embarcadero.com/ja/feed/'},
            {title: 'Embarcadero German Blog', description: 'German Blog', link: 'https://blogs.embarcadero.com/de/feed/'},
            {title: 'Embarcadero Russian Blog', description: 'Russian Blog', link: 'https://blogs.embarcadero.com/ru/feed/'},
            {title: 'Embarcadero Portuguese Blog', description: 'Portuguese Blog', link: 'https://blogs.embarcadero.com/pt/feed/'},
            {title: 'Embarcadero English Blog', description: 'English Blog', link: 'https://blogs.embarcadero.com/es/feed/'}
        ]

        this.dbConnection = dbConnection;
        this.ipcMain = ipcMain;
        this.loaded = false;
    }

    runEvent(){
        this.ipcMain.on('qryGetChannels', (event) => {
            this.dbConnection.query('select * from channels', [], (err, result)=>{
                console.log('channels: ', result);
                if (this.loaded && result) 
                    event.returnValue = result.rows;
                else
                    event.returnValue = [];
            });
        });

        this.ipcMain.on('qryGetArticles', (event, channelId) => {
            this.dbConnection.query('select * from articles where channel=$1', [channelId], (err, result)=>{
                console.log('articles: ', result);
                if (this.loaded) 
                    event.returnValue = result.rows;
                else
                    event.returnValue = [];
            });
        });
    }

    async readRSS(url){
        let parser = new Parser();
        let feed = await parser.parseURL(url);
        return feed;
    }

    async updateArticles(item, channelId){
        let result = await this.dbConnection
                .queryAsync('insert into articles(title, description, link, is_read, timestamp, channel) '+
                        'values ($1::text, $2::text, $3::text, $4::boolean, $5, $6) RETURNING *',
                        [item.title, item.summary, item.link, false, new Date(), channelId]);
        return result;
    }

    async updateChannels() {
        for (let index = 0; index < this.feeds.length; index++) {
            const feed = this.feeds[index];
            let result = await this.dbConnection
                .queryAsync('insert into channels(title, description, link) '+
                        'values ($1::text, $2::text, $3::text) RETURNING *',
                        [feed.title, feed.description, feed.link]);
            console.log('1b',index);
            let f = await this.readRSS(feed.link);
            console.log('2b',index);
            for (let j = 0; j < f.items.length; j++) {
                const item = f.items[j];
                console.log('1c',j);
                await this.updateArticles(item, result.rows[0].id);
                console.log('2c',j);
            }
        }
    }

    async clearChannels() {
        await this.dbConnection.queryAsync('delete from channels');
    }

    async clearArticles() {
        await this.dbConnection.queryAsync('delete from articles');
    }

    async reload() {
        await this.clearArticles();
        console.log('1a');
        await this.clearChannels();
        console.log('2a');
        await this.updateChannels();
        console.log('3a');
        this.loaded = true;
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