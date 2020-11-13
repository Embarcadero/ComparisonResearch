**Created in Delphi using RAD Studio 10.4.1**

# Windows 10 Calculator Clone - Delphi Instructions

## Setup
1. Open RAD Studio.  Click File->New->Multi-Device Application - Delphi
2. Press Cntl+Shift+S to save all files.  Save the .pas file as *"FMXCalculatorLogic"* and the project as *"Calculator"*.
3. Click File->New->Unit - Delphi.  Save this unit as *"Equation.pas"*

## Visual Interface

### Semi-transparent form
1. In the Design window, select *Form1* in the Structure menu, click *Events* in the Object Inspector, and double click next to the ***OnCreate*** action.
2. Paste the following code into the generated TForm1.FormCreate procedure:
```
var     h : HWND;
        aStyle : integer;
        alphaValue : byte;
begin
  h := WindowHandleToPlatform(self.Handle).Wnd;
  AStyle := GetWindowLong(h, GWL_EXSTYLE);
  SetWindowLong(h, GWL_EXSTYLE, AStyle or WS_EX_LAYERED);

  AlphaValue := 240;
  SetLayeredWindowAttributes(h, 0, alphaValue, LWA_ALPHA);
```




## Calculator Logic

### Equation Class
Paste the following code into *Equation.pas*.
```
unit Equation;

interface

uses System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Dialogs, StrUtils;


type

  Operations = (Addition, Subtraction, Multiplication, Division, Reciprocal,
                Square, SquareRoot, Percentage, Nothing);

  type ComplexOperand = record
        Value : Real;
        Ops : array of Operations;
  end;

  type Element = record
        Complex : Boolean;
        Operand : ComplexOperand;
        Operation : Operations;

  end;


  TEquation = class(TObject)

    private
       equation : array of Element;
       lastOperandComplex : Boolean;

       function solveComplexOperand (op : ComplexOperand; index : Integer; num : Real) : Real;
       function printElement ( elem : Element; index : integer ) : String;

    public
        constructor Create();
        procedure clear();
        procedure addElement(num : Real; op : Operations);
        procedure addComplexElement(num : Real; op : Operations);
        procedure repeatLast(currentOperand : Real);
        function solveEquation (lastOperand : Real; finalSolution : Boolean) : Real;
        function printEquation () : String;
        function getLength () : Integer;
        function getValueLast() : Real;
  end;

implementation


  constructor TEquation.Create();
  begin
    SetLength(equation, 0);
    lastOperandComplex := false;
  end;


  {*
    Erase the current equation without memory leaks
  *}
  procedure TEquation.clear();
  begin
        for var i := Low(equation) to High(equation) do
                SetLength(equation[i].Operand.Ops, 0);
        SetLength(equation, 0);
        lastOperandComplex := false;
  end;


  {*
    Add a new element.  Special case: last operand was complex so the operation
    is all the must be added.
  *}
  procedure TEquation.addElement(num : Real; op : Operations);
  begin
        // Add operation to the last element - known to be complex
        if lastOperandComplex then
        begin
          equation[Length(equation)-1].Operation := op;
          ShowMessage (printEquation());
        end

        // New element entirely
        else
        begin
          var newElem : Element;
          newElem.Complex := false;
          newElem.Operand.Value := num;
          newElem.Operation := op;

          SetLength(equation, Length(equation) + 1);
          equation[Length(equation) - 1] := newElem;
        end;

        lastOperandComplex := false;
  end;


  {*
    Chain complex operators (reciprocal, sq, sqrt) onto the last operand
  *}
  procedure TEquation.addComplexElement(num : Real; op : Operations);
  var
        eqLen : Integer;
  begin
        // Second complex operator in a row - add to last
        if lastOperandComplex then
        begin
          Insert(op, equation[High(equation)].Operand.Ops, 0);
          equation[High(equation)].Operation := Operations.Nothing;
        end

        // Completely new element
        else
        begin
          var newElem : Element;
          var newOperand : ComplexOperand;
          newElem.Complex := true;
          newOperand.Value := num;
          SetLength(newOperand.Ops, 1);
          newOperand.Ops[0] := op;
          newElem.Operand := newOperand;
          newElem.Operation := Operations.Nothing;

          eqLen := Length(equation);
          SetLength(equation, eqLen + 1);
          equation[eqLen] := newElem;
        end;

        lastOperandComplex := true;
  end;


  procedure TEquation.repeatLast(currentOperand : Real);
  begin

    var repeatElement := equation[High(equation)];
    repeatElement.Operand.Value := currentOperand;
    SetLength(repeatElement.Operand.Ops, 0);
    SetLength(equation, 1);
    equation[0] := repeatElement;

  end;


  function TEquation.getValueLast() : Real;
  begin
    result := 0.0;

    if Length(equation) > 0 then
      result := solveComplexOperand(equation[High(equation)].Operand, 0, 0);
  end;


  function TEquation.solveEquation (lastOperand : Real; finalSolution : Boolean) : Real;
  begin

    var nextOp := Operations.Nothing;
    var eqResult := 0.0;
    var elemOperand : Real;

    for var i := 0 to High(equation) do
    begin

      if equation[i].Complex then
        elemOperand := solveComplexOperand(equation[i].Operand, 0, eqResult)
      else
        elemOperand := equation[i].Operand.Value;

      if i > 0 then
      begin
        case nextOp of

         Addition: eqResult := eqResult + elemOperand;
         Subtraction: eqResult := eqResult - elemOperand;
         Multiplication: eqResult := eqResult * elemOperand;
         Division:
         begin
            if equation[i].Operand.Value <> 0 then
               eqResult := eqResult / elemOperand
            else
               raise Exception.Create('Cannot divide by zero');
         end;
        end;
      end
      else
        eqResult := elemOperand;

      nextOp := equation[i].Operation;
    end;

    if finalSolution then
    begin
      case nextOp of

       Addition: eqResult := eqResult + lastOperand;
       Subtraction: eqResult := eqResult - lastOperand;
       Multiplication: eqResult := eqResult * lastOperand;
       Division:
       begin
          if lastOperand <> 0 then
             eqResult := eqResult / lastOperand
          else
             raise Exception.Create('Cannot divide by zero');
       end;

       Nothing: eqResult := lastOperand;
      end;
    end;

    result := eqResult;

  end;

  {*
     Poor-man's recursion with index
  *}
  function TEquation.solveComplexOperand (op : ComplexOperand; index : Integer; num : Real) : Real;
  begin

    result := op.Value;

    if index < Length(op.Ops) then
    begin
      case op.Ops[index] of
        Reciprocal : result := 1 / solveComplexOperand (op, index + 1, num);
        Square : result := Sqr(solveComplexOperand (op, index + 1, num));
        SquareRoot : result := Sqrt(solveComplexOperand (op, index + 1, num));
        Percentage : result := num * (op.Value / 100);
      end;
    end;
  end;


  function TEquation.printEquation () : String;
  begin
   var collector := '';

   for var i := Low(equation) to High(equation) do
     collector := collector + ' ' + printElement(equation[i], 0);

    result := collector;
  end;

  {*
    Poor-man's recursion using an index because I can't figure out how to copy
    arrays passed as parameters.
  *}
  function TEquation.printElement ( elem : Element; index : integer ) : String;
  begin

    result := '';

    // Simple operand
    if not elem.Complex then
    begin
      result := FloatToStr(elem.Operand.Value);
      case elem.Operation of
       Addition :  result := result + ' +';
       Subtraction :  result := result + ' -';
       Multiplication :  result := result + ' ×';
       Division :  result := result + ' ÷';
      end;
    end

    else
    begin
      // Base case for complex operand
      if Length(elem.Operand.Ops) = index then
      begin
          //ShowMessage ('printElement base case.  Operand value: ' + FloatToStr(elem.Operand.Value));
          result := FloatToStr(elem.Operand.Value);
      end

      // Recurse over complex operands
      else
      begin
        case elem.Operand.Ops[index] of
         Reciprocal : result := '1/( ' + printElement(elem, index + 1) + ')';
         Square :  result := 'sqr( ' + printElement(elem, index + 1) + ')';
         SquareRoot : result := '√( ' + printElement(elem, index + 1) + ')';
         Percentage : result := printElement(elem, index + 1) + '%';
        end;

      end;
    end;
  end;


function TEquation.getLength () : Integer;
begin
  result := Length(equation);
end;

end.
```

### FMXCalculatorLogic Private Members
Paste the following code into the *private* section of the *FMXCalculatorLogic* type description:

```
{ Private declarations }
    calcState : State;
    equation : TEquation;
    lastOperand : Real;


    procedure updateEquationLabel();
    procedure addElementToEquation (num : Real; op : Operations );
    procedure updateOperator(op : Operations);
    procedure repeatLastElement ();
```
Paste the following code into the *FMXCalculatorLogic* file below the *implementation* keyword.

```
procedure TForm1.updateEquationLabel();
begin
  lblEquation.Text := equation.printEquation();
end;

{*
  Add operand/operator according to calculator state.
*}
procedure TForm1.updateOperator(op : Operations);
begin

  // Special case - use result of last calculation as first operand
  if calcState = State.Solved then
  begin
    equation.clear();
    calcState := State.InputFirstDigit;
  end;


  if (calcState <> State.Error) and ((calcState <> State.InputFirstDigit)) then
  begin

    var partialSolution : String;
    partialSolution := '0';

    addElementToEquation(StrToFloat(lblAnswer.Text), op);

    // Calculate partial solution if more than one operand
    try
      partialSolution := FloatToStr(equation.solveEquation(0, false));
    except
      partialSolution := 'Cannot divide by zero';
      calcState := State.Error;
    end;


    updateEquationLabel();
    lblAnswer.Text := partialSolution;

    if calcState <> State.Error then
      calcState := State.InputFirstDigit;
  end

  // Special case for complex operands
  else if (calcState = State.InputFirstDigit) and
     ((op = Operations.Reciprocal) or (op = Operations.Square) or
      (op = Operations.SquareRoot) or (op = Operations.Percentage))  then
  begin

    var partialSolution : String;
    partialSolution := '0';

    addElementToEquation(StrToFloat(lblAnswer.Text), op);

    // Calculate partial solution if more than one operand
    try
      partialSolution := FloatToStr(equation.solveEquation(0, false));
    except
      partialSolution := 'Cannot divide by zero';
      calcState := State.Error;
    end;


    updateEquationLabel();
    lblAnswer.Text := partialSolution;

    if calcState <> State.Error then
      calcState := State.InputFirstDigit;
  end;
end;


procedure TForm1.addElementToEquation (num : Real; op : Operations );
begin
  //ShowMessage ('Adding operator');
  if (op = Operations.Addition) or (op = Operations.Subtraction) or
        (op = Operations.Multiplication) or (op = Operations.Division) then
    equation.addElement(num, op)
  else
    equation.addComplexElement(num, op);
end;

procedure TForm1.repeatLastElement ();
begin
    //ShowMessage ('repeatLastElement lblAnswer: ' + lblAnswer.Text);
    if equation.getLength() > 0 then
    begin
      equation.repeatLast(StrtoFloat(lblAnswer.Text));
      lblAnswer.Text := FloatToStr(lastOperand);
      updateEquationLabel();
      calcState := State.InputFollowingDigits;
    end
    else
      calcState := Solved;
end;
```

### FMXCalculatorLogic Setup
1. Make sure the *uses* statements should include the following units:
```
System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Controls.Presentation, StrUtils, FMX.Ani, FMX.Effects, fmx.platform.win,
  winapi.windows, FMX.Objects, Equation;
```
2. Add the calcluator *State* enum to the *type* clause.
`State = (InputFirstDigit, InputFollowingDigits, Solved, Error);`
3. Add `procedure resetCalculator(Sender: TObject);` to the *public* declarations in the *type* section.
4. Paste the *resetCalculator* implementation below into the *implementation* section of *FMXCalculatorLogic.pas*.
```
{*
   Reset the calculator or remove digits/operands
*}
procedure TForm1.resetCalculator(Sender: TObject);
begin
  lblAnswer.Text := '0';
  lblEquation.Text := '';
  lastOperand := 0;
  calcState := State.InputFirstDigit;
  equation.clear();
end;
```
