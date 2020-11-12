import { Component, ViewChild, ElementRef, Input } from '@angular/core';
import { ScwinService } from '../scwin.service';

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

  constructor(private winSvc: ScwinService) { }

  loadImageToCanvas(base64Image) {
    this.context = this.canvasMain.nativeElement.getContext('2d');
    let image = new Image();
    image.onload = () => {
      this.context.drawImage(image, 10, 10, image.width, image.height);
    }
    image.src = base64Image;
  }

  applyNewSize(h, w) {
    this.context.canvas.width = w;
    this.context.canvas.height = h;
  }

  ngAfterViewInit(): void {
    this.loadImageToCanvas(this.dataUrl);
    this.winSvc.ChangeSizeEvent.subscribe( ()=>{ 
      console.log('newSize, ', this.winSvc.imageSize);
      this.applyNewSize(this.winSvc.imageSize.height, this.winSvc.imageSize.width);
    })
  }


}
