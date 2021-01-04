import { Component, ElementRef } from '@angular/core';
import { Router } from '@angular/router';
import { ComService } from '../com.service';
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

  constructor(private onlyDir: OnlydirPipe, private router: Router) { }

  clickFolder(event, item) {
    event.stopPropagation();
    let liElem = event.target.parentElement;
    let iconElem = liElem.querySelector('i');
    let ulElem = liElem.querySelector('ul');
    if (iconElem.className == 'fas fa-folder') {
      iconElem.className = 'fas fa-folder-open';
      ulElem.className = 'active';
    }else{
      iconElem.className = 'fas fa-folder';
      ulElem.className = 'nested';
    }
    this.router.navigate(['listfile'], {queryParams: {path: item.path}});
  }

  setLoadData(ifiles: Ifile[]) {
    this.ifiles = ifiles;
    this.list = this.onlyDir.transform(this.ifiles);
  }
  

}
