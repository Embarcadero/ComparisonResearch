const { Client } = require('pg');
const { config } = require('./db.config.json');

class DbConnection {
    constructor() {}

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
        this.client.query(sql, params, (err, res) => {
            this.client.end();
            callback(err, res);
        })
    }

} 

module.exports = {
    DbConnection: DbConnection
}