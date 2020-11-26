const { Client } = require('pg');
const { config } = require('./config.json');

class DbConnection {
    constructor() {
        this.client = new Client(config);
        this.client.connect();
        console.log(this.client);
    }

    async query(sql, params) {
        const res = await this.client.query(sql, params);
        console.log(res.rows[0].message)
        return await client.end();
    }

} 

exports = {
    DbConnection: DbConnection
}