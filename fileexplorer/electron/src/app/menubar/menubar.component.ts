import { Component, OnInit, ViewChild } from '@angular/core';
import { ComService } from '../com.service';
import { Ifile } from '../ifile';
import { HxtreeviewComponent } from '../hxtreeview/hxtreeview.component';
import { SharedService } from '../sharedservice';

@Component({
  selector: 'app-menubar',
  templateUrl: './menubar.component.html',
  styleUrls: ['./menubar.component.css']
})
export class MenubarComponent implements OnInit {
  ifiles: Array<Ifile> = [];
  @ViewChild(HxtreeviewComponent) treeview: HxtreeviewComponent;
  defaultPath: string = '';

  constructor(public comSvc: ComService, private sharedSvc: SharedService) {}

  clickDirTree(ev) {
    this.loadData(this.defaultPath);
  }

  loadData(path: string) {
    this.getDirs(path);
    this.treeview.setLoadData(this.ifiles);
  }

  getDirs(path) {
    this.ifiles = this.comSvc.sendSync('getDirTree', path).children;
  }

  getUserDir() {                      
    this.defaultPath = this.comSvc.sendSync('getUserDir') + '/Downloads/';
    this.sharedSvc.selectedPath = this.defaultPath;
  }

  ngAfterViewInit() {
    this.getUserDir();
    this.loadData(this.defaultPath);
  }

  ngOnInit(): void {}

}
