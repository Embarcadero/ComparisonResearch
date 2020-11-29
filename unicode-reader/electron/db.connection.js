const { Client } = require('pg');
const { config } = require('./db.config.json');

class DbConnection {
    constructor() {
        this.client = new Client(config);
    }

    async queryAsync(sql, params) {
        await this.client.connect();
        const res = await this.client.query(sql, params);
        // console.log(res.rows);
        await this.client.end();
        return res;
    }

    query(sql, params, callback) {
        this.client.query(sql, params, (err, res) => {
            callback(err, res);
            this.client.end();
        })
    }

} 

module.exports = {
    DbConnection: DbConnection
}