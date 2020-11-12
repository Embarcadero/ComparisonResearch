import { Component, OnInit, Input } from '@angular/core';
import { NgbActiveModal, NgbModal } from '@ng-bootstrap/ng-bootstrap';
import { ScwinService } from '../scwin.service';

@Component({
  selector: 'ngbd-modal-content',
  template: `
    <div class="modal-header">
      <h4 class="modal-title">Resize Dialog</h4>
      <button type="button" class="close" aria-label="Close" (click)="activeModal.dismiss('Cross click')">
        <span aria-hidden="true">&times;</span>
      </button>
    </div>
    <div class="modal-body">
      <div>
        <div class="form-group row">
          <label class="col-sm-2 col-form-label">Height</label>
          <div class="col-sm-10">
            <input type="number" #heightSize class="form-control" placeholder="new height">
          </div>
        </div>
        <div class="form-group row">
          <label class="col-sm-2 col-form-label">Width</label>
          <div class="col-sm-10">
            <input type="number" #widthtSize class="form-control" placeholder="new width">
          </div>
        </div>
      </div>
    </div>
    <div class="modal-footer">
      <button type="button" class="btn btn-outline-dark" (click)="applyResize(heightSize.value, widthtSize.value)">Apply</button>
    </div>
  `
})

export class NgbdModalContent {
  @Input() name;

  constructor(public activeModal: NgbActiveModal, private winSvc: ScwinService) {}

  applyResize(h, w) {
    this.winSvc.newSize({height:Number(h), width:Number(w)});
    this.activeModal.close('Close click');
  }
}

@Component({
  selector: 'app-toolbar',
  templateUrl: './toolbar.component.html',
  styleUrls: ['./toolbar.component.css']
})
export class ToolbarComponent implements OnInit {
  constructor(private modalService: NgbModal) {}

  showResizeDialog(): void {
    const modalRef = this.modalService.open(NgbdModalContent);
    modalRef.componentInstance.name = 'World';
  }

  ngOnInit(): void {
    
  }

}
