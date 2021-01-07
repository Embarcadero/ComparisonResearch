import { Component, OnInit } from '@angular/core';
import { ComService } from '../com.service';

@Component({
  selector: 'app-toolbar',
  templateUrl: './toolbar.component.html',
  styleUrls: ['./toolbar.component.css']
})
export class ToolbarComponent implements OnInit {
  searchQ: string = '';

  constructor(public comSvc: ComService) { }

  searchFile() {
    this.comSvc.sendSync('findFiles', path);
  }

  ngOnInit(): void {
  }

}
