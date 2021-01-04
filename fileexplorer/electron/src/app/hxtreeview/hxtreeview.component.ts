import { Component } from '@angular/core';
import { Ifile } from '../ifile';
import { OnlydirPipe } from '../onlydir';

@Component({
  selector: 'hxtreeview',
  templateUrl: './hxtreeview.component.html',
  styleUrls: ['./hxtreeview.component.css']
})
export class HxtreeviewComponent {
  ifiles: Array<Ifile> = [];
  list: Array<Ifile> = [];

  constructor(private onlyDir: OnlydirPipe) { }

  clickFolder(event, index) {
    let ulElem = event.target.nextSibling;
    let iconElem = event.target.querySelector('i');
    if (iconElem.className == 'fas fa-folder') {
      iconElem.className = 'fas fa-folder-open';
      ulElem.className = 'active';
    }else{
      iconElem.className = 'fas fa-folder';
      ulElem.className = 'nested';
    }
  }

  setLoadData(ifiles: Ifile[]) {
    this.ifiles = ifiles;
    this.list = this.onlyDir.transform(this.ifiles);
  }

}