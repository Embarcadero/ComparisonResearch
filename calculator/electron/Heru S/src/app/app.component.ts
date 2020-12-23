import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent implements OnInit {
  title = 'Calculator';
  calc_result: number = 0;
  old_value: number = 0;
  operator: string = '';
  ce_clicked: boolean = false;

  number_click(newNumber: number) {
    if (this.operator == '') {
      if (this.calc_result == 0 && newNumber == 0) {
        this.calc_result = 0; 
      }else {
        this.calc_result = parseFloat(this.calc_result.toString() + newNumber.toString()); 
      }
    }else {
      if (!this.ce_clicked) {
        this.old_value = this.calc_result;
        this.calc_result = newNumber;
      }else{
        this.calc_result = newNumber;
      }
    }
  }

  kali_click() {
    this.operator = 'x';
  }

  tambah_click() {
    this.operator = '+';
  }

  min_click() {
    this.operator = '-';
  }

  samadengan_click() {
    console.log(this.calc_result + ' <> ' + this.old_value);
    switch (this.operator) {
      case '÷':
        this.calc_result = this.old_value / this.calc_result;
        break;
      case 'x':
          this.calc_result = this.old_value * this.calc_result;
          break;
      case '+':
          this.calc_result = this.old_value + this.calc_result;
          break;
      case '-':
          this.calc_result = this.old_value - this.calc_result;
          break;
      default:
        break;
    }
  }

  bagi_click() {
    this.operator = '÷';
  }

  kuadrat_click() {
    this.calc_result = Math.pow(this.calc_result, 2);
  }

  seperx_click() {
    this.calc_result = 1 / this.calc_result;
  }

  squareroot_click() {
    this.calc_result = Math.sqrt(this.calc_result);
  }

  plusminus_click() {
    this.calc_result = this.calc_result * (-1);
  }

  dot_click() {
    // number_click()
  }

  persen_click() {
    this.calc_result = this.calc_result / 100;
  }

  ce_click() {
    this.calc_result = 0;
    this.ce_clicked = true;
  }

  c_click() {
    this.calc_result = 0;
    this.operator = '';
  }

  back_click() {
    if (this.calc_result.toString().length == 1) {
      this.calc_result = 0;
      return;
    }
    let res = this.calc_result.toString().slice(this.calc_result.toString().length - 1);
    res = this.calc_result.toString().replace(res, '');
    this.calc_result = parseFloat(res); 
  }

  nol_click() {
    this.number_click(0);
  }

  satu_click() {
    this.number_click(1);
  }

  dua_click() {
    this.number_click(2);
  }

  tiga_click() {
    this.number_click(3);
  }

  pat_click() {
    this.number_click(4);
  }

  ima_click() {
    this.number_click(5);
  }

  nam_click() {
    this.number_click(6);
  }

  juh_click() {
    this.number_click(7);
  }

  pan_click() {
    this.number_click(8);
  }

  lan_click() {
    this.number_click(9);
  }

  ngOnInit() {

  }
}
