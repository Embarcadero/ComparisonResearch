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

  setSelectedWindow(window: Scwindow) {
    this.wins.setSelectedWindow(window);
    this.selectedWindow = this.wins.getSelectedWindow();
    console.log('selected: ', this.selectedWindow.name);
  }

  ngOnInit(): void {
    this.wins.ChangeDataEvent.subscribe((items)=>{
      this.scWindows = items;
      this.cd.detectChanges();
    })
    this.selectedWindow = this.wins.getSelectedWindow();
  }

}
