import { Pipe, PipeTransform } from '@angular/core';
import { Ifile } from './ifile';

@Pipe({name: 'showOnlyDir'})
export class OnlydirPipe implements PipeTransform {

    transform(dirTree: Ifile[]) {
        return dirTree.filter(ifile => {
            return ifile.type == 'directory';
        });
    }

}
