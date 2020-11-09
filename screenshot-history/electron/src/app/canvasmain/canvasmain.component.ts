import { Component, ViewChild, ElementRef, Input } from '@angular/core';

@Component({
  selector: 'app-canvasmain',
  templateUrl: './canvasmain.component.html',
  styleUrls: ['./canvasmain.component.css']
})
export class CanvasmainComponent {
  @ViewChild('canvasmain')
  canvasMain: ElementRef<HTMLCanvasElement>;
  public context: CanvasRenderingContext2D;
  @Input() dataUrl: string;

  constructor() { }

  loadImageToCanvas(base64Image) {
    this.context = this.canvasMain.nativeElement.getContext('2d');
    let image = new Image();
    image.onload = () => {
      this.context.drawImage(image, 0, 0);
    }
    image.src = base64Image;
  }

  ngAfterViewInit(): void {
    this.loadImageToCanvas(this.dataUrl);
  }


}
