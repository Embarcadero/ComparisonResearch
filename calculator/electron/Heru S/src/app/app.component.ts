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
  lastoperator: string = '';
  operators: Array<string> = [];
  values: Array<number> = [];
  ce_clicked: boolean = false;

  number_click(newNumber: number) {
    this.calc_result = parseFloat(this.calc_result.toString() + newNumber.toString()); 
    console.log(newNumber);
    // console.log('this.operator: ', this.operator);
    // if (this.operators.length == 0) {
    //   if (this.calc_result == 0 && newNumber == 0) {
    //     this.calc_result = 0; 
    //   }else {
    //     this.calc_result = parseFloat(this.calc_result.toString() + newNumber.toString()); 
    //   }
    // }else {
    //   if (!this.ce_clicked) {
    //     this.old_value = this.calc_result;
    //     console.log('this.old_value: ', this.old_value);
    //     this.calc_result = newNumber;
    //   }else{
    //     this.calc_result = newNumber;
    //   }
    // }
  }

  kali_click() {
    this.values.push(this.calc_result);
    this.lastoperator = 'x';
    this.operators.push(this.lastoperator);
    this.calc_result = 0;
    console.log('values: ', this.values);
    console.log('operators: ', this.operators);
  }

  bagi_click() {
    this.values.push(this.calc_result);
    this.lastoperator = '÷';
    this.operators.push(this.lastoperator);
    this.calc_result = 0;
    console.log('values: ', this.values);
    console.log('operators: ', this.operators);
  }

  tambah_click() {
    this.values.push(this.calc_result);
    this.lastoperator = '+';
    this.operators.push(this.lastoperator);
    this.calc_result = 0;
    console.log('values: ', this.values);
    console.log('operators: ', this.operators);
  }

  min_click() {
    this.values.push(this.calc_result);
    this.lastoperator = '-';
    this.operators.push(this.lastoperator);
    this.calc_result = 0;
    console.log('values: ', this.values);
    console.log('operators: ', this.operators);
  }

  samadengan_click() {
    // 10 + 5 + 2 - 1 = 16
    let g = '';
    for (let i = 0; i < this.values.length; i++) {
      const value = this.values[i];
      let opr = this.operators[i];
      g = g + opr + value;
      console.log('==> ', g)
      switch (opr) {
        case '÷':
          this.calc_result = value / this.calc_result;
          break;
        case 'x':
          this.calc_result = value * this.calc_result;
          break;
        case '+':
          this.calc_result = value + this.calc_result;
          break;
        case '-':
          this.calc_result = value - this.calc_result;
          break;
      }
    }
    this.operators = [];
    this.values = [];
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
    this.operators = [];
    this.values = [];
    this.ce_clicked = true;
  }

  c_click() {
    this.operators = [];
    this.values = [];
    this.calc_result = 0;
    this.lastoperator = '';
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
