import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { SortbyinputComponent } from './sortbyinput.component';

describe('SortbyinputComponent', () => {
  let component: SortbyinputComponent;
  let fixture: ComponentFixture<SortbyinputComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ SortbyinputComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(SortbyinputComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
