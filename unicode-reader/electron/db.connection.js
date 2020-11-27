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
        return await this.client.end();
    }

    query(sql, params, callback) {
        this.client.query(sql, params, (err, res) => {
            callback(err, res);
        })
    }

} 

// let dbCon = new DbConnection();
// dbCon.queryAsync('SELECT * from channels', []);

module.exports = {
    DbConnection: DbConnection
}