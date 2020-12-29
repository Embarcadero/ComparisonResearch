import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { HxtreeviewComponent } from './hxtreeview.component';

describe('HxtreeviewComponent', () => {
  let component: HxtreeviewComponent;
  let fixture: ComponentFixture<HxtreeviewComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ HxtreeviewComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(HxtreeviewComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
