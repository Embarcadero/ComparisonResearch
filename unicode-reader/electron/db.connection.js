const { Client } = require('pg');
const { config } = require('./db.config.json');

class DbConnection {
    constructor() {
        this.client = new Client(config);
        this.client.connect();
    }

    async queryAsync(sql, params) {
        const res = await this.client.query(sql, params);
        console.log(res.rows)
        return res; //await this.client.end();
    }

    query(sql, params, callback) {
        this.client.query(sql, params, (err, res) => {
            callback(err, res);
        })
    }

} 

module.exports = {
    DbConnection: DbConnection
}