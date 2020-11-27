const { DbConnection } = require('./db.connection');
const { ipcMain } = require('electron');

class MainService {

    run = () => {
        this.dbConnection = new DbConnection();
        ipcMain.on('qryGetChannels', (event) => {
            let result = this.dbConnection.queryAsync('select * from channels');
            event.returnValue = result;
        });
    }

}

module.exports = {
    MainService: MainService
}