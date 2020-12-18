const fs = require('fs');
const path = require("path");

class FileService {

    constructor(ipcMain) {
        this.ipcMain = ipcMain;
    }

    runEvent() {
        this.ipcMain.on('getDirTree', async (event, path)=> {
            let dirList = getDirsWithChild(path);
            console.log('dirList: ', dirList);
            event.returnValue = dirList;
        })
        this.ipcMain.on('getFileDir', async (event, path)=> {
            let dirList = await this.getFileDirs(path);
            event.returnValue = dirList;
        })
    }

    getDirsWithChild(rootDir, listDir) {
        listDir = listDir || [];
        let files = fs.readdirSync(rootDir);
        files.forEach((file) => {
            let fileStat = fs.statSync(rootDir + '/' + file);
            if (fileStat.isDirectory()) {
                let item = {
                    name: file,
                    file: rootDir + '/' + file, 
                    size: fileStat.size, 
                    modified: fileStat.ctime, 
                    isDirectory: fileStat.isDirectory(), 
                    isFile: fileStat.isFile()
                };
                listDir.push(item);
                listDir = this.getDirsWithChild(rootDir + '/' + file, listDir);
            } /*else {
                listDir.push(path.join(__dirname, rootDir, "/", file));
            }*/
        })
        return listDir;
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
                if (stats.isDirectory()) {
                    res.push(item);
                    this.getDirs()
                }
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
    let res = await fileService.getDirsWithChild('/Users/herux/Downloads');
    console.log('res: ', res);
}

getList();

module.exports = {
    FileService: FileService
}