const { Client } = require('pg');
const { config } = require('./db.config.json');

class DbConnection {
    constructor() {
    }

    async checkCreateSchema() {
        // create table channels
        await this.queryAsync(
            'create table channels ( '+
            'id serial, '+
            'title varchar(1024) not null, '+
            'description text not null, '+
            'link varchar(2048) not null, '+
            'constraint channels_pk primary key (id) );'
        , '');
        // create table articles
        await this.queryAsync(
            'create table articles ( '+
            '   id serial, '+
            '   title varchar(1024) not null, '+
            '   description text not null, '+
            '   content text not null, '+
            '   link varchar(2048) not null, '+
            '   is_read boolean default false, '+
            '   timestamp timestamp default now(), '+
            '   channel integer not null, '+
            '   constraint articles_pk primary key (id), '+
            '   constraint channels_fk foreign key (channel) '+
            '   references channels (id) '+
            '   on delete cascade ); '
        , '');
        // create table articles
        // await this.queryAsync(
        //     'create table articles ( '+
        //     '    id serial, '+
        //     '    title varchar(1024) not null, '+
        //     '    content text not null, '+
        //     '    contentSnippet text, '+
        //     '    categories varchar(512), '+
        //     '    link varchar(2048) not null, '+
        //     '    pubDate date, '+
        //     '    content_encoded text, '+
        //     '    creator varchar(150), '+
        //     '    is_read boolean default false, '+
        //     '    timestamp timestamp default now(), '+
        //     '    channel integer not null, '+
        //     '    constraint articles_pk primary key (id), '+
        //     '    constraint channels_fk foreign key (channel) '+
        //     '        references channels (id) '+
        //     '        on delete cascade); ',
        // '');
    }

    async dropTables() {
        await this.queryAsync('DROP TABLE IF EXISTS articles');
        await this.queryAsync('DROP TABLE IF EXISTS channels');
    }

    async dropCreate() {
        await this.dropTables();
        await this.checkCreateSchema();
    }

    async queryAsync(sql, params) {
        let result;
        try {
            this.client = new Client(config);
            await this.client.connect();
            result = await this.client.query(sql, params);
        } catch (error) {
            console.error(error);
        } finally {
            this.client.end();
        }
        return result;
    }

    query(sql, params, callback) {
        this.client = new Client(config);
        this.client.connect();
        this.client.query(sql, params, (err, res) => {
            this.client.end();
            callback(err, res);
        })
    }

} 

// let con = new DbConnection();
// con.checkCreateDatabase_schema();

module.exports = {
    DbConnection: DbConnection
}