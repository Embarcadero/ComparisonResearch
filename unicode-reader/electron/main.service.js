let Parser = require('rss-parser');

class MainService {
    constructor(dbConnection, ipcMain) {
        this.feeds = [
            {id: 1, title: 'All Articles', description: 'All Articles', link:'https://blogs.embarcadero.com/feed/'},
            {id: 2, title: 'Embarcadero Japanese Blog', description: 'Japanese Blog', link: 'https://blogs.embarcadero.com/ja/feed/'},
            {id: 3, title: 'Embarcadero German Blog', description: 'German Blog', link: 'https://blogs.embarcadero.com/de/feed/'},
            {id: 4, title: 'Embarcadero Russian Blog', description: 'Russian Blog', link: 'https://blogs.embarcadero.com/ru/feed/'},
            {id: 5, title: 'Embarcadero Portuguese Blog', description: 'Portuguese Blog', link: 'https://blogs.embarcadero.com/pt/feed/'},
            {id: 6, title: 'Embarcadero Spanish Blog', description: 'Spanish Blog', link: 'https://blogs.embarcadero.com/es/feed/'},
            // 
            {id: 7, title: 'DelphiFeeds.com', description: 'All Delphi blogs in one place', link: 'https://www.delphifeeds.com/feed/'},
            {id: 8, title: 'BeginEnd.net Recent Posts', description: 'BeginEnd.net aggregated posts for the last 7 days', link: 'https://www.beginend.net/api/recent.rss.dws'},
            // {id: 9, title: 'AI Trends', description: 'The Business and Technology of Enterprise AI', link: 'https://www.aitrends.com/feed/'},
            {id: 10, title: 'TechCrunch', description: 'Startup and Technology News', link: 'https://techcrunch.com/feed/'},
            {id: 11, title: 'VentureBeat', description: 'Transformative tech coverage that matters', link: 'https://venturebeat.com/feed/'},
            {id: 12, title: 'Machine Learning Mastery', description: 'Making developers awesome at machine learning', link: 'https://machinelearningmastery.com/feed/'},
            {id: 13, title: 'JavaScript Scene - Medium', description: 'JavaScript, software leadership, software development, and related technologies. - Medium', link: 'https://medium.com/feed/javascript-scene'},
            // {id: 14, title: 'DailyJS - Medium', description: 'JavaScript news and opinion. - Medium', link: 'https://medium.com/feed/dailyjs'},
            {id: 15, title: 'Effective Software Design', description: 'Doing the right thing.', link: 'https://effectivesoftwaredesign.com/feed/'},
            {id: 16, title: 'Datanami', description: 'Data Science • AI • Advanced Analytics', link: 'https://www.datanami.com/feed/'},
            {id: 17, title: 'Communications of the ACM: Artificial Intelligence', description: 'The latest news, opinion and research in artificial intelligence, from Communications online.', link: 'https://cacm.acm.org/browse-by-subject/artificial-intelligence.rss'},
            {id: 18, title: 'Communications of the ACM: Security', description: 'The latest news, opinion and research in security, from Communications online.', link: 'https://cacm.acm.org/browse-by-subject/security.rss'},
            {id: 19, title: 'BleepingComputer', description: 'BleepingComputer - All Stories', link: 'https://www.bleepingcomputer.com/feed/'},
            {id: 20, title: 'Microsoft Security', description: 'Expert coverage of cybersecurity topics', link: 'https://www.microsoft.com/security/blog/feed/'},
            {id: 21, title: 'The Hacker News', description: 'Most trusted, widely-read independent cybersecurity news source for everyone; supported by hackers and IT professionals ', link: 'http://feeds.feedburner.com/TheHackersNews?format=xml'},
            // // {id: 22, title: 'SmartData Collective', description: 'News & Analysis on Big Data, the Cloud, BI and Analytics', link: 'https://www.smartdatacollective.com/feed/'},
            // {id: 23, title: 'Artificial Intelligence News -- ScienceDaily', description: 'Artificial Intelligence News. Everything on AI including futuristic robots with artificial intelligence, computer models of human intelligence and more.', link: 'https://www.sciencedaily.com/rss/computers_math/artificial_intelligence.xml'},
            // {id: 24, title: 'Hacking News -- ScienceDaily', description: 'Hacking and computer security. Read today s research news on hacking and protecting against codebreakers. New software, secure data sharing, and more.', link: 'https://www.sciencedaily.com/rss/computers_math/hacking.xml'},
            // {id: 25, title: 'Quantum Computers News -- ScienceDaily', description: 'Quantum Computer Research. Read the latest news in developing quantum computers.', link: 'https://www.sciencedaily.com/rss/computers_math/quantum_computers.xml'},
            // {id: 26, title: 'Distributed Computing News -- ScienceDaily', description: 'Distributed computing and computer grids. From supercomputers to computer grids, browse innovations from computer programmers and scientists around the world.', link: 'https://www.sciencedaily.com/rss/computers_math/distributed_computing.xml'},
            // {id: 27, title: 'SANS Internet Storm Center, InfoCON: green', description: 'SANS Internet Storm Center - Cooperative Cyber Security Monitor', link: 'https://isc.sans.edu/rssfeed_full.xml'},
            {id: 28, title: 'Cary Jensen "Lets Get Technical"', description: 'Technical discussions related to software development. Particular attention is paid to Delphi development. Also expect a healthy dose of database-related content, including SQL, data modeling, and general database design.', link: 'http://feeds.feedburner.com/CaryJensenLetsGetTechnical?format=xml'},
            {id: 29, title: 'Coding Is Like Cooking', description: 'by Emily Bache', link: 'http://coding-is-like-cooking.info/feed/'},
            {id: 30, title: 'Google Online Security Blog', description: 'The latest news and insights from Google on security and safety on the Internet.', link: 'http://feeds.feedburner.com/GoogleOnlineSecurityBlog'},
            {id: 31, title: 'Modern Software Design', description: 'Serhiy Perevoznyk blog', link: 'https://perevoznyk.wordpress.com/feed/'},
            {id: 32, title: 'RisingStack Engineering - Node.js Tutorials & Resources', description: 'Learn about Node.js, JavaScript & Mircoservices from the experts of RisingStack.', link: 'https://blog.risingstack.com/rss/'},
            {id: 33, title: 'The Art of Delphi Programming', description: 'Opinions, thoughts and ideas mostly related to Delphi Programming', link: 'https://www.uweraabe.de/Blog/feed/'},
            {id: 34, title: 'Learn Korean with Talk To Me In Korean', description: 'Books & Online Courses', link: 'https://talktomeinkorean.com/feed/'},
            {id: 35, title: 'Fluent Arabic', description: 'The Quranic Arabic Blog', link: 'https://www.fluentarabic.net/feed/'},
            {id: 36, title: 'Aftenposten Title', description: 'Aftenposten RSS Service', link: 'https://www.aftenposten.no/rss'},
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

    // async updateArticles(item, channelId){
    //     let result = await this.dbConnection
    //             .queryAsync('insert into articles(title, content, contentSnippet, categories, link, pubDate, content_encoded, creator, is_read, channel) '+
    //                     'values ($1::text, $2::text, $3::text, $4, $5, $6, $7, $8, $9, $10) RETURNING *',
    //                     [item.title, item.content, item.contentSnippet, JSON.stringify(item.categories), item.link, item.pubDate, item['content:encoded'], item.creator, false, channelId]);
    //     return result;
    // }

    async updateChannels() {
        let hrstart = process.hrtime();
        let c = 0;
        if (this.withTestBtn) {
            c = this.feeds.length;
        }else {
            c = 6;
        }
        for (let index = 0; index < c; index++) {
            const feed = this.feeds[index];
            console.log(index, ' link: ', feed.link, ' desc: ', feed.description, ' title: ', feed.title);
            console.log('feed --> ', feed);
            let result = await this.dbConnection
                .queryAsync('insert into channels(title, description, link) '+
                        'values ($1::text, $2::text, $3::text) RETURNING *',
                        [feed.title, feed.description, feed.link]);
            let f = await this.readRSS(feed.link);
            let id = result.rows[0].id;
            console.log('article of ', id);
            for (let j = 0; j < f.items.length; j++) {
                const item = f.items[j];
                console.log('item: ', item);
                await this.updateArticles(item, id);
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