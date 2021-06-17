let Parser = require('rss-parser');

class MainService {
    constructor(dbConnection, ipcMain) {
        this.feeds = [
            {id: 1, title: 'Embarcadero English Blog', description: 'Blazing Fast Cross-Platform App Development Software', link:'https://blogs.embarcadero.com/feed/'},
            {id: 2, title: 'Embarcadero Japanese Blog', description: 'Japanese Blog', link: 'https://blogs.embarcadero.com/ja/feed/'},
            {id: 3, title: 'Embarcadero German Blog', description: 'German Blog', link: 'https://blogs.embarcadero.com/de/feed/'},
            {id: 4, title: 'Embarcadero Russian Blog', description: 'Russian Blog', link: 'https://blogs.embarcadero.com/ru/feed/'},
            {id: 5, title: 'Embarcadero Portuguese Blog', description: 'Portuguese Blog', link: 'https://blogs.embarcadero.com/pt/feed/'},
            {id: 6, title: 'Embarcadero Spanish Blog', description: 'Spanish Blog', link: 'https://blogs.embarcadero.com/es/feed/'},
            {id: 7, title: 'Machine Learning Mastery', description: 'Making developers awesome at machine learning', link: 'https://machinelearningmastery.com/feed/'},
            {id: 8, title: 'JavaScript Scene - Medium', description: 'JavaScript, software leadership, software development, and related technologies. - Medium', link: 'https://medium.com/feed/javascript-scene'},
            {id: 9, title: 'DailyJS - Medium', description: 'JavaScript news and opinion. - Medium', link: 'https://medium.com/feed/dailyjs'},
            {id: 10, title: 'Datanami', description: 'Data Science • AI • Advanced Analytics', link: 'https://www.datanami.com/feed/'},
            {id: 11, title: 'Microsoft Security', description: 'Expert coverage of cybersecurity topics', link: 'https://www.microsoft.com/security/blog/feed/'},
            {id: 12, title: 'Coding Is Like Cooking', description: 'by Emily Bache', link: 'http://coding-is-like-cooking.info/feed/'},
            {id: 13, title: 'RisingStack Engineering', description: 'Learn about Node.js, JavaScript & Mircoservices from the experts of RisingStack.', link: 'https://blog.risingstack.com/rss/'},
            {id: 14, title: 'The Art of Delphi Programming', description: 'Opinions, thoughts and ideas mostly related to Delphi Programming', link: 'https://www.uweraabe.de/Blog/feed/'},
            {id: 15, title: 'Learn Korean with Talk To Me In Korean', description: 'Books & Online Courses', link: 'https://talktomeinkorean.com/feed/'},
            {id: 16, title: 'The Crazy Programmer', description: 'Guides you through the simplest basics of C, C , Android, PHP, SQL and many more coding languages', link: 'http://www.thecrazyprogrammer.com/feed'},
            {id: 17, title: 'Web Damn', description: 'Tutorial focused on Web Development, PHP, CodeIgniter, jQuery, JavaScript, and MySQL', link: 'https://webdamn.com/feed/ '},
            {id: 18, title: 'MIT Technology Review', description: 'Leading the conversation about technologies that matter', link: 'https://www.technologyreview.com/feed/'},
            {id: 19, title: 'Stack Abuse', description: 'News, articles, and ideas for software engineers and web developers', link: 'https://stackabuse.com/rss/'},
            {id: 20, title: 'Programe Secure', description: 'Shares new programming related books and pdfs', link: 'https://programesecure.com/feed/'},
            {id: 21, title: 'Tutorial And Example', description: 'A Tutorial Website with Real Time Examples', link: 'https://www.tutorialandexample.com/feed/'},
            {id: 22, title: 'Fueled', description: 'Focus on development, design, and strategy to passionately pursue the bleeding, hairsplitting, cutting edge of mobile apps', link: 'https://fueled.com/feed/'},
            {id: 23, title: 'Hackaday', description: 'For the serious techie', link: 'https://hackaday.com/blog/feed/'},
            {id: 24, title: 'GeekWire', description: 'Tech news, commentary and other nerdiness from Seattle', link: 'https://www.geekwire.com/feed/'},
            {id: 25, title: 'Techquila', description: 'Your daily shot of PC, video-game, smartphone, entertainment, lifestyle and science news', link: 'https://www.techquila.co.in/feed/'} 
        ]

        this.dbConnection = dbConnection;
        this.ipcMain = ipcMain;
        this.loaded = false;
        this.withTestBtn = false;
    }

    runEvent(){
        // only for testing purpose
        // load all data from databases, and measure the speed
        this.ipcMain.on('qryGetChannelsAndArticles', (event) => {
            let hrstart = process.hrtime();
            this.dbConnection.query('select * from channels', [], (err, result)=>{
                let  channels = [];
                channels = result.rows;
                this.dbConnection.query('select  articles.id, articles.title, articles.description, articles.content, '+
                ' articles.link, articles.is_read, articles.timestamp, articles.channel, channels.link as channel_link, '+
                ' channels.title as channel_title from articles inner join channels ON channels.id = articles.channel '+
                ' order by articles.timestamp desc ', [], (err, result)=>{
                    let hrend = process.hrtime(hrstart);
                    let retObj = {};
                    let articles = [];
                    articles = result.rows;
                    retObj.channels = channels;
                    retObj.articles = articles;
                    retObj.hrtime = hrend;
                    console.log('retObj.articles: ', retObj.articles);
                    if (this.withTestBtn) {
                        this.createCombinedRSS(retObj.articles);
                    }
                    event.returnValue = retObj;
                });
            });
        });

        this.ipcMain.on('qryGetChannels', (event) => {
            this.dbConnection.query('select * from channels', [], (err, result)=>{
                event.returnValue = result.rows;
            });
        });

        this.ipcMain.on('qryGetArticles', (event, channelId) => {
            this.dbConnection.query('select * from articles where channel=$1', [channelId], (err, result)=>{
                if (channelId) {
                    event.returnValue = result.rows;
                }else{
                    event.returnValue = [];
                }
            });
        });

        this.ipcMain.on('dropTables', (event) => {
            this.dbConnection.dropTables();
            event.returnValue = true;
        });

        this.ipcMain.on('fetchRSSnSave', async (event, testBtn) => {
            this.withTestBtn = testBtn;
            await this.dbConnection.dropCreate();
            let hrRes = await this.updateChannels(this.withTestBtn);
            event.reply('fetchRSSnSaveReply', hrRes);
            // if (this.withTestBtn) {
                
            // }else{
            //     event.reply('fetchRSSnSaveReply', hrRes);
            // }
        });
    }

    async readRSS(url){
        let parser = new Parser();
        let feed = await parser.parseURL(url);
        return feed;
    }

    async updateArticles(item, channelId){
        let result = await this.dbConnection
                .queryAsync('insert into articles(title, description, content, link, timestamp, is_read, channel) '+
                        'values ($1::text, $2::text, $3::text, $4::text, $5, $6, $7) RETURNING *',
                        [item.title, item.content || '', item['content:encoded'] || '', item.link, item.pubDate, false, channelId]);
        return result;
    }

    async updateArticles2(item, channelId){
        let res = await this.dbConnection
            .queryPool('insert into articles(title, description, content, link, timestamp, is_read, channel) '+
                'values ($1::text, $2::text, $3::text, $4::text, $5, $6, $7) RETURNING *',
                [item.title, item.content || '', item['content:encoded'] || '', item.link, item.pubDate, false, channelId]);
        console.log('updateArticles2 res: ', res);    
    }

    async updateChannels() {
        let hrstart = process.hrtime();
        let c = 0;
        if (this.withTestBtn) {
            c = this.feeds.length;
        }else {
            c = 25;
        }
        for (let index = 0; index < c; index++) {
            const feed = this.feeds[index];
            console.log(index, ' link: ', feed.link, ' desc: ', feed.description, ' title: ', feed.title);
            console.log('feed --> ', feed.title);
            let result = await this.dbConnection
                .queryAsync('insert into channels(title, description, link) '+
                        'values ($1::text, $2::text, $3::text) RETURNING *',
                        [feed.title, feed.description, feed.link]);
            let f = await this.readRSS(feed.link);
            if (typeof result != 'undefined') {
                let id = result.rows[0].id;
                console.log('article of ', id);
                for (let j = 0; j < f.items.length; j++) {
                    const item = f.items[j];
                    console.log('item: ', item.title);
                    this.updateArticles2(item, id);                
                }
            }
        }
        let hrend = process.hrtime(hrstart);
        return hrend;
    }

    async clearChannels() {
        await this.dbConnection.queryAsync('delete from channels');
    }

    async clearArticles() {
        await this.dbConnection.queryAsync('delete from articles');
    }

    async reload() {
        await this.updateChannels();
        this.loaded = true;
    }

    createCombinedRSS (articles) {
        let path = require('path');
        let dirname = '';
        if (process.platform === 'darwin') {
            dirname = path.join(__dirname, '../../../../');
        }{
            dirname = path.join(__dirname, '../../');
        }
        

        let fs = require('fs');
        let fileName = dirname + '/combinedRSS.html';
        const htmlCreator = require('html-creator');
        const html = new htmlCreator([
            {
              type: 'head',
              content: [{ type: 'title', content: 'Combined RSS Feeds' }]
            },
            {
              type: 'body'
            }
          ]);
        for (let i = 0; i < articles.length; i++) {
            const article = articles[i];
            html.document.addElementToType('body', {
                type: 'h2',
                content: [
                    {
                    type: 'a',
                    attributes: { href: article.channel_link },
                    content: article.channel_name
                    },
                    {
                        type: '',
                        content: ' - '
                    },
                    {
                        type: 'a',
                        attributes: { href: article.link },
                        content: article.title
                    }
                ]
            });
            html.document.addElementToType('body', {
                type: 'h3',
                content: article.timestamp
            });
            html.document.addElementToType('body', {
                type: 'p',
                content: article.content
            });
            html.document.addElementToType('body', {
                type: 'br'
            });
            html.document.addElementToType('body', {
                type: 'hr'
            })            
        }

        html.renderHTMLToFile(fileName);
    }

}

// const { DbConnection } = require('./db.connection');
// let dbConnection = new DbConnection();
// let mainService = new MainService(dbConnection, null);
// mainService.createCombinedRSS();
// let init = async () => {
//     await dbConnection.dropCreate();
//     await mainService.reload();
// }

// init();

module.exports = {
    MainService: MainService
}