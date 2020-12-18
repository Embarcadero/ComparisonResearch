import { Component, OnInit, Input } from '@angular/core';
import { Ifile } from '../ifile';

@Component({
  selector: 'hxtreeview',
  templateUrl: './hxtreeview.component.html',
  styleUrls: ['./hxtreeview.component.css']
})
export class HxtreeviewComponent implements OnInit {
  @Input() ifiles: Array<Ifile> = [];
  treeActive: boolean = false;

  constructor() { }

  clickFolder(event, index) {
    let iconElem = event.target.querySelector('i');
    if (iconElem.className == 'fas fa-folder') {
      iconElem.className = 'fas fa-folder-open';
    }else{
      iconElem.className = 'fas fa-folder';
    }
  }

  ngOnInit(): void {
  }

}
