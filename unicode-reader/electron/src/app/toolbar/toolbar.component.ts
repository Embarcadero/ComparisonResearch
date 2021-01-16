import { Component, OnInit } from '@angular/core';
import { ComService } from '../com.service';

@Component({
  selector: 'app-toolbar',
  templateUrl: './toolbar.component.html',
  styleUrls: ['./toolbar.component.css']
})
export class ToolbarComponent implements OnInit {
  deletedDB: boolean = false;

  constructor(public comSvc: ComService) { }

  dropTables() {
    this.deletedDB = this.comSvc.sendSync('dropTables');
  }

  ngOnInit(): void {
  }

}
