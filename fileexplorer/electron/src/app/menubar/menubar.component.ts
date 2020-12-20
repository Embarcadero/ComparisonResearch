import { Component, OnInit, ViewChild } from '@angular/core';
import { ComService } from '../com.service';
import { Ifile } from '../ifile';
import { HxtreeviewComponent } from '../hxtreeview/hxtreeview.component';

@Component({
  selector: 'app-menubar',
  templateUrl: './menubar.component.html',
  styleUrls: ['./menubar.component.css']
})
export class MenubarComponent implements OnInit {
  ifiles: Array<Ifile> = [];
  @ViewChild(HxtreeviewComponent) treeview: HxtreeviewComponent;

  constructor(public comSvc: ComService) {}

  clickDirTree(ev) {
    this.getDirs('/Users/herux');
    this.treeview.setLoadData(this.ifiles);
  }

  getDirs(path) {
    this.ifiles = this.comSvc.sendSync('getDirTree', path).children;
  }

  ngOnInit(): void {
  }

}
