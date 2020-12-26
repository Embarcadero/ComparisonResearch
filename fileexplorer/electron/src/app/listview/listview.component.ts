import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { ComService } from '../com.service';
import { Ifile } from '../ifile';

@Component({
  selector: 'app-listview',
  templateUrl: './listview.component.html',
  styleUrls: ['./listview.component.css']
})
export class ListviewComponent implements OnInit {
  ifiles: Array<Ifile>;
  constructor(private route: ActivatedRoute, public comSvc: ComService) { }

  ngOnInit(): void {
    this.route.queryParams
      .subscribe(params => {
          this.ifiles = this.comSvc.sendSync('getFileDir', params.path);
      });
  }

}
