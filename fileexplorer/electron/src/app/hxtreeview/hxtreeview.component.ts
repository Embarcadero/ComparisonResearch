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

  clickNode(event) {
    if (this.treeActive) {
      this.treeActive = false;
    } else {
      this.treeActive = true;
    }
  }

  ngOnInit(): void {
  }

}
