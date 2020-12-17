import { Component, OnInit } from '@angular/core';
// import { faFolder, faFolderOpen, faSquare, faCheckSquare, faCheck, faMinus } from '@fortawesome/free-solid-svg-icons';
import { ComService } from '../com.service';
import { Ifile } from '../ifile';

@Component({
  selector: 'app-menubar',
  templateUrl: './menubar.component.html',
  styleUrls: ['./menubar.component.css']
})
export class MenubarComponent implements OnInit {
  ifiles: Array<Ifile> = [];
  // public faFolder = faFolder;
  // public faFolderOpen = faFolderOpen;
  // public faSquare = faSquare;
  // public faCheckSquare = faCheckSquare;
  // public faMinus = faMinus;
  // public faCheck = faCheck;

  constructor(public comSvc: ComService) { }

  ngAfterViewInit(): void {
    console.log('ngAfterViewInit');
  }

  getDirs() {
    this.ifiles = this.comSvc.sendSync('getDirTree', '/Users/herux/Downloads');
    console.log('ifiles: ', this.ifiles);
  }

  ngOnInit(): void {
    this.getDirs();
  }

}
