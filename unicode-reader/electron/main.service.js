let Parser = require('rss-parser');

class MainService {

    constructor(dbConnection, ipcMain) {
        this.feeds = [
            {id: 1, title: 'All Articles', description: 'All Articles', link:'https://blogs.embarcadero.com/feed/'},
            {id: 2, title: 'Embarcadero Japanese Blog', description: 'Japanese Blog', link: 'https://blogs.embarcadero.com/ja/feed/'},
            {id: 3, title: 'Embarcadero German Blog', description: 'German Blog', link: 'https://blogs.embarcadero.com/de/feed/'},
            {id: 4, title: 'Embarcadero Russian Blog', description: 'Russian Blog', link: 'https://blogs.embarcadero.com/ru/feed/'},
            {id: 5, title: 'Embarcadero Portuguese Blog', description: 'Portuguese Blog', link: 'https://blogs.embarcadero.com/pt/feed/'},
            {id: 6, title: 'Embarcadero English Blog', description: 'English Blog', link: 'https://blogs.embarcadero.com/es/feed/'}
        ]

        this.dbConnection = dbConnection;
        this.ipcMain = ipcMain;
        this.loaded = false;
    }

    runEvent(){
        this.ipcMain.on('qryGetChannels', (event) => {
            this.dbConnection.query('select * from channels', [], (err, result)=>{
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
        console.log('categories: ', item.categories);
        let result = await this.dbConnection
                .queryAsync('insert into articles(title, content, contentSnippet, categories, link, pubDate, content_encoded, creator, is_read, channel) '+
                        'values ($1::text, $2::text, $3::text, $4, $5, $6, $7, $8, $9, $10) RETURNING *',
                        [item.title, item.content, item.contentSnippet, JSON.stringify(item.categories), item.link, item.pubDate, item['content:encoded'], item.creator, false, channelId]);
        return result;
    }

    async updateChannels() {
        for (let index = 0; index < this.feeds.length; index++) {
            const feed = this.feeds[index];
            let result = await this.dbConnection
                .queryAsync('insert into channels(title, description, link) '+
                        'values ($1::text, $2::text, $3::text) RETURNING *',
                        [feed.title, feed.description, feed.link]);
            let f = await this.readRSS(feed.link);
            for (let j = 0; j < f.items.length; j++) {
                const item = f.items[j];
                await this.updateArticles(item, result.rows[0].id);
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
        await this.clearChannels();
        await this.updateChannels();
        console.log('loaded');
        this.loaded = true;
    }

    

}

module.exports = {
    MainService: MainService
}