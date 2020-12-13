const fs = require('fs');

class FileService {

    constructor() {}

    async getFileDirs(dir) {
        try {
            let items = await fs.readdirSync(dir);
            for (var i=0; i<items.length; i++) {
                var file = dir + '/' + items[i];
                let stats = await fs.statSync(file);
                console.log(file, ' - ' ,stats["size"], ' - ',stats.isDirectory());
            }       
        } catch (error) {
            console.log('error: ', error);
        }
    }

}

let  fileService = new FileService();
fileService.getFileDirs('/Users/herux/Downloads');

module.exports = {
    FileService: FileService
}