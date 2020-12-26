const fs = require('fs');
const path = require("path");
const dirTree = require("directory-tree");
const { fdir } = require("fdir");

class FileService {

    constructor(ipcMain) {
        this.ipcMain = ipcMain;
    }

    runEvent() {
        this.ipcMain.on('getDirTree', async (event, path)=> {
            console.log('dirList loading ..');
            let dirList = await this.getDirTree(path);
            // console.log('dirList: ', dirList);
            event.returnValue = dirList;
            // this.getDirTree2(path, (files)=>{
            //     console.log('dirList loading ..', files);
            //     event.returnValue = files;
            // })
        })
        this.ipcMain.on('getFileDir', async (event, path)=> {
            let dirList = await this.getFileDirs(path);
            // console.log('dirList: ', dirList);
            event.returnValue = dirList;
        })
    }

    getDirTree2(rootDir, callback) {
        const api = new fdir().withFullPaths().crawl(rootDir);
        api.withPromise().then((files) => {
            callback(files);
        });
    }

    async getDirTree(rootDir) {
        let depth = 0;
        const dirtree = await dirTree(rootDir, depth);
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
                    path: file, 
                    name: items[i],
                    size: stats.size, 
                    modified: stats.ctime, 
                    extension: '',
                    type: () => {
                        if (stats.isDirectory())
                            return 'directory';
                        else
                            return 'file';
                    },
                    isDirectory: stats.isDirectory(), 
                    isFile: stats.isFile(),
                    children: []};
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
                let filetype = '';
                if (stats.isDirectory())
                    filetype = 'directory';
                if (stats.isFile())
                    filetype = 'file';
                let item = {
                    path: file, 
                    name: items[i],
                    size: stats.size, 
                    modified: stats.ctime, 
                    extension: '',
                    type: filetype,
                    isDirectory: stats.isDirectory(), 
                    isFile: stats.isFile(),
                    children: []
                };
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