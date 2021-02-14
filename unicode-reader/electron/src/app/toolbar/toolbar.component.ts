import { Component, OnInit, ChangeDetectorRef, Output, EventEmitter } from '@angular/core';
import { ComService } from '../com.service';
import { environment } from './../../environments/environment.normal';
// import { NgxSpinnerService } from "ngx-spinner";
import { NgxLoadingSpinnerService } from '@k-adam/ngx-loading-spinner';

interface IEnvironment {
  production: boolean, 
  testbutton: boolean
}

@Component({
  selector: 'app-toolbar',
  templateUrl: './toolbar.component.html',
  styleUrls: ['./toolbar.component.css']
})
export class ToolbarComponent implements OnInit {
  deletedDB: boolean = false;
  storageBtn: boolean = false;
  retrBtn: boolean = false;
  storageResult: number = 0.000;
  retrievalResult: number = 0.000;
  spinnerTitle: string;
  channels = [];
  @Output() onAfterGetData = new EventEmitter<any>();
  environment:  IEnvironment;

  constructor(public comSvc: ComService, private cdr: ChangeDetectorRef, private spinnerService: NgxLoadingSpinnerService) { 
    this.environment = environment;
    console.log( 'environment: ', this.environment );
  }

  reloadData() {
    this.spinnerService.show();
    this.comSvc.send('fetchRSSnSave', false);
    this.comSvc.on('fetchRSSnSaveReply', (event) => {
      this.spinnerTitle = 'loading data.. ';
      this.spinnerService.hide();
      let dataResult = this.comSvc.sendSync('qryGetChannels');
      this.channels = dataResult;
      this.onAfterGetData.emit(this.channels);
      this.cdr.detectChanges();
      console.log('this.channels: ', this.channels);
    });
  }

  dropTables() {
    this.deletedDB = this.comSvc.sendSync('dropTables');
  }

  runStorageTest() {
    this.retrBtn = true;
    this.deletedDB=true;
    this.storageResult = 0;
    this.spinnerService.show();
    this.spinnerTitle = 'Running Storage Test ... ';
    this.comSvc.send('fetchRSSnSave', true);
    this.comSvc.on('fetchRSSnSaveReply', (event, hrTime) => {
      this.spinnerTitle = 'Storage Test SUCCESS!. ';
      this.storageResult = hrTime[0] + hrTime[1] * 1.0E-9;
      this.deletedDB = false;
      this.spinnerService.hide();
      this.retrBtn = false;
      this.cdr.detectChanges();
    });
  }

  runRetrievalTest() {
    this.storageBtn = true;
    this.deletedDB = true;
    let dataResult = this.comSvc.sendSync('qryGetChannelsAndArticles');
    this.channels = dataResult.channels;
    this.retrievalResult = dataResult.hrtime[0] + dataResult.hrtime[1] * 1.0E-9;
    console.log('this.retrievalResult: ', this.retrievalResult);
    this.onAfterGetData.emit(this.channels);
    this.storageBtn = false;
    this.deletedDB = false;
    this.cdr.detectChanges();
  }

  ngOnInit(): void {
    
   }

}
