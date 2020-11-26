import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { MenuleftComponent } from './menuleft.component';

describe('MenuleftComponent', () => {
  let component: MenuleftComponent;
  let fixture: ComponentFixture<MenuleftComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ MenuleftComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(MenuleftComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
