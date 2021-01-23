import { Component, OnInit, ChangeDetectorRef } from '@angular/core';
import { ComService } from '../com.service';
// import { NgxSpinnerService } from "ngx-spinner";
import { NgxLoadingSpinnerService } from '@k-adam/ngx-loading-spinner';

@Component({
  selector: 'app-toolbar',
  templateUrl: './toolbar.component.html',
  styleUrls: ['./toolbar.component.css']
})
export class ToolbarComponent implements OnInit {
  deletedDB: boolean = false;
  storageResult: number = 0.000;
  spinnerTitle: string;

  constructor(public comSvc: ComService, private cdr: ChangeDetectorRef, private spinnerService: NgxLoadingSpinnerService) { }

  dropTables() {
    this.deletedDB = this.comSvc.sendSync('dropTables');
  }

  fetchData() {
    this.storageResult = 0;
    this.spinnerService.show();
    this.spinnerTitle = 'Running Storage Test ... ';
    this.comSvc.send('fetchRSSnSave');
    this.comSvc.on('fetchRSSnSaveReply', (event, hrend) => {
      this.storageResult = hrend[0];
      this.spinnerService.hide();
      this.deletedDB = false;
      this.cdr.detectChanges();
    });
  }

  ngOnInit(): void { }

}
