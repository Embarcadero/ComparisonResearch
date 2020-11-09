import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { CanvasmainComponent } from './canvasmain.component';

describe('CanvasmainComponent', () => {
  let component: CanvasmainComponent;
  let fixture: ComponentFixture<CanvasmainComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ CanvasmainComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(CanvasmainComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
