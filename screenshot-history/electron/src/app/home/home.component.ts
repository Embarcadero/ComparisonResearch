import { Component, ChangeDetectorRef, OnInit } from '@angular/core';
import { ScwinService } from '../scwin.service';
import { Scwindow } from '../scwindow';

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.css']
})
export class HomeComponent implements OnInit {
  scWindows: Array<Scwindow> = [];
  selectedWindow: Scwindow;

  constructor(
    private wins: ScwinService, 
    private cd: ChangeDetectorRef
    ) {}

  setSelectedWindow(window: Scwindow): void {
    this.selectedWindow = window;
    console.log('selected: ', this.selectedWindow);
  }

  ngOnInit(): void {
    this.wins.ChangeDataEvent.subscribe((items)=>{
      this.scWindows = items;
      this.cd.detectChanges();
    })
  }

}
