import { Component, OnInit } from '@angular/core';
import { ComService } from '../com.service';
import { SharedService } from '../sharedservice';

@Component({
  selector: 'app-toolbar',
  templateUrl: './toolbar.component.html',
  styleUrls: ['./toolbar.component.css']
})
export class ToolbarComponent implements OnInit {
  searchQ: string = '';

  constructor(public comSvc: ComService, private sharedSvc: SharedService) { }

  clickSearch() {
    console.log('clickSearch: ', this.searchQ, ' - ', this.sharedSvc.selectedPath);
    // this.comSvc.sendSync('findFiles', path);
  }

  ngOnInit(): void {
  }

}
