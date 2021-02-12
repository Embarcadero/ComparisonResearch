import { Component, OnInit, Input } from '@angular/core';

@Component({
  selector: 'app-menubar',
  templateUrl: './menubar.component.html',
  styleUrls: ['./menubar.component.css']
})
export class MenubarComponent implements OnInit {
  private _dataChannels: Array<any>;
  
  @Input() 
  set dataChannels(value: Array<any>) {
    console.log('menubar dataChannels: ', value);
    this._dataChannels = value;
  }

  get dataChannels(): Array<any> {
    return this._dataChannels;
  }

  constructor() { }

  ngOnInit(): void {
  }

}
