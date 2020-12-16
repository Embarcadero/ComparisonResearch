import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'hxtreeview',
  templateUrl: './hxtreeview.component.html',
  styleUrls: ['./hxtreeview.component.css']
})
export class HxtreeviewComponent implements OnInit {
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
