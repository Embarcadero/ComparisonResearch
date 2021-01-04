const fs = require('fs');
const path = require("path");
const dirTree = require("directory-tree");

class FileService {

    constructor(ipcMain) {
        this.ipcMain = ipcMain;
    }

    runEvent() {
        this.ipcMain.on('getDirTree', async (event, path)=> {
            console.log('dirList loading ..');
            let dirList = await this.getDirTree(path);
            console.log('dirList: ', dirList);
            event.returnValue = dirList;
        })
        this.ipcMain.on('getFileDir', async (event, path)=> {
            let dirList = await this.getFileDirs(path);
            event.returnValue = dirList;
        })
    }

    async getDirTree(rootDir) {
        const dirtree = await dirTree(rootDir);
        return dirtree; 
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
                    isFile: fileStat.isFile(),
                    child: []
                };
                listDir.push(item);
                listDir = this.getDirsWithChild(rootDir + '/' + file, listDir);
            }
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

// let getList = async () => {
//     let  fileService = new FileService();
//     let res = await fileService.getDirTree('/Users/herux/Downloads');
//     console.log('res: ', JSON.stringify(res));
// }

// getList();

module.exports = {
    FileService: FileService
}