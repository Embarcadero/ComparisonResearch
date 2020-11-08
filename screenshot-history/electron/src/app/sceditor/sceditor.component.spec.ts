import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { SceditorComponent } from './sceditor.component';

describe('SceditorComponent', () => {
  let component: SceditorComponent;
  let fixture: ComponentFixture<SceditorComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ SceditorComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(SceditorComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
