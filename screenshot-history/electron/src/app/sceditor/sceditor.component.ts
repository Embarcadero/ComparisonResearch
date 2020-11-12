import { Component, OnInit, Input } from '@angular/core';
import { ScwinService } from '../scwin.service';

@Component({
  selector: 'app-sceditor',
  templateUrl: './sceditor.component.html',
  styleUrls: ['./sceditor.component.css']
})
export class SceditorComponent implements OnInit {
  dataUrl: string;
  constructor(private winsvc: ScwinService) { }

  ngOnInit(): void {
    this.dataUrl = this.winsvc.getSelectedWindow().dataUrl;
  }

}
