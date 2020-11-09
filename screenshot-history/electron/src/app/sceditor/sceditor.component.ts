import { Component, OnInit } from '@angular/core';
import { ScwinService } from '../scwin.service';

@Component({
  selector: 'app-sceditor',
  templateUrl: './sceditor.component.html',
  styleUrls: ['./sceditor.component.css']
})
export class SceditorComponent implements OnInit {

  constructor(private winsvc: ScwinService) { }

  ngOnInit(): void {
    console.log('this.winsvcL ', this.winsvc.getSelectedWindow().name);
  }

}
