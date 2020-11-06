import { Component, ChangeDetectorRef, OnInit } from '@angular/core';
import { ComService } from '../com.service';
// import { DomSanitizer } from '@angular/platform-browser';
import { ScwinService } from '../scwin.service';
import { Scwindow } from '../scwindow';

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.css']
})
export class HomeComponent implements OnInit {
  scWindows: Array<Scwindow> = [];

  constructor(private wins: ScwinService, private cd: ChangeDetectorRef) {}

  ngOnInit(): void {
    this.wins.ChangeDataEvent.subscribe((items)=>{
      this.scWindows = items;
      this.cd.detectChanges();
      // console.log(this.scWindows[0].dataUrl);
    })
  }

}
