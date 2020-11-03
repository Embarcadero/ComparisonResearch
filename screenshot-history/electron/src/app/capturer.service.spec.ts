import { TestBed } from '@angular/core/testing';

import { CapturerService } from './capturer.service';

describe('CapturerService', () => {
  let service: CapturerService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(CapturerService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
