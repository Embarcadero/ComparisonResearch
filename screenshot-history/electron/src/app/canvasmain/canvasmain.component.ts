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
  croping: boolean = false;
  lastMouseX: number = 0;
  lastMouseY: number = 0;
  canvasX: number = 0;
  canvasY: number = 0;
  mouseDown: boolean = false;
  mouseX: number = 0;
  mouseY: number = 0;

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
    });
    this.winSvc.StartCropEvent.subscribe(()=>{
      this.croping = true;
      console.log('StartCropEvent: ', this.croping);
    });
    this.canvasX = this.canvasMain.nativeElement.offsetLeft;
    this.canvasY = this.canvasMain.nativeElement.offsetTop;
  }

  doMouseDown(event): void {
    console.log('mousedown: X -> ', event.clientX, ' Y -> ', event.clientY, ' offset:', this.canvasMain.nativeElement.offsetLeft);
    this.lastMouseX = event.clientX - this.canvasX;
    this.lastMouseY = event.clientY - this.canvasY;
    this.mouseDown = true;
  }

  doMouseUp(event): void {
    this.mouseDown = false;
  }

  doMouseMove(event): void {
    this.mouseX = event.clientX - this.canvasX;
    this.mouseY = event.clientY - this.canvasY;
    if (this.mouseDown) {
      this.context.clearRect(0, 0, this.canvasMain.nativeElement.width, this.canvasMain.nativeElement.height);
      this.context.beginPath();
      let width = this.mouseX - this.lastMouseX;
      let height= this.mouseY = this.lastMouseY;
      this.context.rect(this.lastMouseX,  this.lastMouseY, width, height);
      this.context.strokeStyle = 'black';
      this.context.lineWidth = 10;
      this.context.stroke();
    }
  }

}
