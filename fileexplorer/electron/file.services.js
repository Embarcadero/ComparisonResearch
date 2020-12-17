const fs = require('fs');

class FileService {

    constructor(ipcMain) {
        this.ipcMain = ipcMain;
    }

    runEvent() {
        this.ipcMain.on('getDirTree', async (event, path)=> {
            let dirList = await this.getDirs(path);
            console.log('dirList: ', dirList);
            event.returnValue = dirList;
        })
        this.ipcMain.on('getFileDir', async (event, path)=> {
            let dirList = await this.getFileDirs(path);
            event.returnValue = dirList;
        })
    }

    async getDirs(dir) {
        let res = [];
        try {
            let items = await fs.readdirSync(dir);
            for (var i=0; i < items.length; i++) {
                var file = dir + '/' + items[i];
                let stats = await fs.statSync(file);
                let item = {
                    name: items[i],
                    file: file, 
                    size: stats.size, 
                    modified: stats.ctime, 
                    isDirectory: stats.isDirectory(), 
                    isFile: stats.isFile()};
                if (stats.isDirectory()) 
                    res.push(item);
            }       
        } catch (error) {
            console.log('error: ', error);
        }
        return res;
    }

    async getFileDirs(dir) {
        let res = [];
        try {
            let items = await fs.readdirSync(dir);
            for (var i=0; i < items.length; i++) {
                var file = dir + '/' + items[i];
                let stats = await fs.statSync(file);
                // console.log(file, ' - ' ,stats["size"], ' - ',stats.isDirectory());
                let item = {
                    file: file, 
                    size: stats.size, 
                    modified: stats.ctime, 
                    isDirectory: stats.isDirectory(), 
                    isFile: stats.isFile()};
                res.push(item);
            }       
        } catch (error) {
            console.log('error: ', error);
        }
        return res;
    }

}

let getList = async () => {
    let  fileService = new FileService();
    let res = await fileService.getFileDirs('/Users/herux/Downloads');
    console.log('res: ', res);
}

getList();

module.exports = {
    FileService: FileService
}