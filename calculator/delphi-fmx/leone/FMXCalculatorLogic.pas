unit FMXCalculatorLogic;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Controls.Presentation, StrUtils, FMX.Ani, FMX.Effects, fmx.platform.win,
  winapi.windows, FMX.Objects, Equation;

type

  State = (InputFirstDigit, InputFollowingDigits, Solved, Error);


  TForm1 = class(TForm)
    panelInput: TPanel;
    panelAnswer: TPanel;
    btnCE: TButton;
    btnSubtract: TButton;
    btn2: TButton;
    btn3: TButton;
    btnAdd: TButton;
    btnChangeSign: TButton;
    btn0: TButton;
    btnDecimal: TButton;
    btnEquals: TButton;
    btnBackspace: TButton;
    btnClear: TButton;
    btnDivide: TButton;
    btn7: TButton;
    btn8: TButton;
    btn9: TButton;
    btnMultiply: TButton;
    btn4: TButton;
    btn5: TButton;
    btn6: TButton;
    btn1: TButton;
    lblEquation: TLabel;
    lblAnswer: TLabel;
    GridPanelLayout1: TGridPanelLayout;
    StyleBook1: TStyleBook;
    btnPercent: TButton;
    btnReciprocal: TButton;
    btnSquare: TButton;
    btnSquareRoot: TButton;
    procedure FormShow(Sender: TObject);
    procedure digitClick(Sender: TObject);
    procedure btnChangeSignClick(Sender: TObject);

    procedure btnDecimalClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnSubtractClick(Sender: TObject);
    procedure btnMultiplyClick(Sender: TObject);
    procedure btnDivideClick(Sender: TObject);
    procedure btnEqualsClick(Sender: TObject);
    procedure btnBackspaceClick(Sender: TObject);
    procedure btnCEClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnReciprocalClick(Sender: TObject);
    procedure btnSquareClick(Sender: TObject);
    procedure btnSquareRootClick(Sender: TObject);
    procedure btnPercentClick(Sender: TObject);
    procedure resetCalculator(Sender: TObject);

  private
    { Private declarations }
    calcState : State;
    equation : TEquation;
    lastOperand : Real;


    procedure updateEquationLabel();
    procedure addElementToEquation (num : Real; op : Operations );
    procedure updateOperator(op : Operations);
    procedure repeatLastElement ();

  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}
{$R *.LgXhdpiPh.fmx ANDROID}

{*
  Make the calculator semi-transparent like the Windows Calculator
*}
procedure TForm1.FormCreate(Sender: TObject);
var     h : HWND;
        aStyle : integer;
        alphaValue : byte;
begin
  h := WindowHandleToPlatform(self.Handle).Wnd;
  AStyle := GetWindowLong(h, GWL_EXSTYLE);
  SetWindowLong(h, GWL_EXSTYLE, AStyle or WS_EX_LAYERED);

  AlphaValue := 240;
  SetLayeredWindowAttributes(h, 0, alphaValue, LWA_ALPHA);
end;


{*
   Set initial calculator state
*}
procedure TForm1.FormShow(Sender: TObject);
begin
  equation := TEquation.Create();
  resetCalculator(Sender);
end;


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


procedure TForm1.btnBackspaceClick(Sender: TObject);
begin
  if calcState = State.Solved then
  begin
    lblEquation.Text := '';
    equation.clear();
  end
  else if calcState <> State.Error then
  begin
    if lblAnswer.Text.Length = 1 then
      lblAnswer.Text := '0'
    else
      lblAnswer.Text := lblAnswer.Text.Substring(0, lblAnswer.Text.Length - 1);
  end;
end;


procedure TForm1.btnCEClick(Sender: TObject);
begin
  if calcState = State.Solved then
    resetCalculator(Sender)
  else
  begin
    lblAnswer.Text := '0';
    calcState := State.InputFirstDigit;
  end;
end;



procedure TForm1.updateEquationLabel();
begin
  lblEquation.Text := equation.printEquation();
end;


{*
   Accumulate digit input in the main label field.  Specific logic to replace
   '0' with a digit, to handle a decimal place correctly in the event of '0.x',
   and to continue calculating with the result from a previous calculation.
*}
procedure TForm1.digitClick(Sender: TObject);
var
  operand : Real;
begin
  if calcState = State.Solved then
    resetCalculator(Sender);


  if calcState = State.InputFollowingDigits then
  begin
    operand := StrtoFloat(lblAnswer.Text);

    if lblAnswer.Text.Contains('.') then
      lblAnswer.Text := lblAnswer.Text + (Sender as TButton).Text
    else if operand = 0 then
      lblAnswer.Text := (Sender as TButton).Text
    else
      lblAnswer.Text := lblAnswer.Text + (Sender as TButton).Text;
  end
  else if calcState = State.InputFirstDigit then
  begin
    lblAnswer.Text := (Sender as TButton).Text;
    calcState := State.InputFollowingDigits;
  end;
end;


{*
  Add a decimal place (not more than one).
*}
procedure TForm1.btnDecimalClick(Sender: TObject);
begin
  if calcState <> State.Error then
  begin

    if calcState = State.Solved then
      resetCalculator(Sender);

    if calcState = State.InputFirstDigit then
    begin
      lblAnswer.Text := '0.';
      calcState := State.InputFollowingDigits;
    end;

    if (RightStr(lblAnswer.Text, 1) <> '.') and
    (not lblAnswer.Text.Contains('.')) then
      lblAnswer.Text := lblAnswer.Text + (Sender as TButton).Text;
  end;
end;


{*
  Change the sign of the current operand.
*}
procedure TForm1.btnChangeSignClick(Sender: TObject);
begin
  if calcState <> State.Error then
  begin
    var operand := -(StrtoFloat(lblAnswer.Text));

    if operand <> 0 then
      lblAnswer.Text := FormatFloat('0.#########', operand);
  end;
end;



{*
   Mathematical operations with two operands - Add the current operand and the
   operation to the list of equation elements.
*}
procedure TForm1.btnAddClick(Sender: TObject);
begin
  updateOperator(Operations.Addition);
end;

procedure TForm1.btnSquareClick(Sender: TObject);
begin
  updateOperator(Operations.Square);
end;

procedure TForm1.btnSquareRootClick(Sender: TObject);
begin
  updateOperator(Operations.SquareRoot);
end;

procedure TForm1.btnSubtractClick(Sender: TObject);
begin
  updateOperator(Operations.Subtraction);
end;

procedure TForm1.btnMultiplyClick(Sender: TObject);
begin
  updateOperator(Operations.Multiplication);
end;

procedure TForm1.btnReciprocalClick(Sender: TObject);
begin
  updateOperator(Operations.Reciprocal);
end;

procedure TForm1.btnPercentClick(Sender: TObject);
begin
  updateOperator(Operations.Percentage);
end;

procedure TForm1.btnDivideClick(Sender: TObject);
begin
  updateOperator(Operations.Division);
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

  if (op = Operations.Addition) or (op = Operations.Subtraction) or
        (op = Operations.Multiplication) or (op = Operations.Division) then
    equation.addElement(num, op)
  else
    equation.addComplexElement(num, op);
end;



{*
  Calculate the equation entered.
        One operand - output the only number given.
        Two operands - output the result of the calculation
  Change state to Solved to allow for next calculation.
*}
procedure TForm1.btnEqualsClick(Sender: TObject);
var
  eqResult : Real;
begin

  if calcState = State.Solved then
        repeatLastElement();

  if calcState = State.InputFirstDigit then
  begin
    if (equation.getLength() = 0) then
    begin
      lblEquation.Text := lblAnswer.Text + ' =';
      calcState := State.Solved;
    end
    else
    begin
      lastOperand := StrtoFloat(lblAnswer.Text);
      eqResult := equation.solveEquation(0, false);
      lblEquation.Text := FloatToStr(eqResult) + ' =';
      lblAnswer.Text := FloatToStr(eqResult);
      calcState := State.Solved;
    end;
  end

  else if (calcState <> State.Error) and (calcState <> Solved) then
  begin
    lastOperand := StrtoFloat(lblAnswer.Text);

    try
      eqResult := equation.solveEquation (lastOperand, true);
    except
      lblAnswer.Text := 'Cannot divide by zero';
      calcState := State.Error;
    end;


    if (calcState <> State.Error) then
    begin
      lblAnswer.Text := FloatToStr(eqResult);
      lblEquation.Text := lblEquation.Text + ' ' + FloattoStr(lastOperand) + ' =';
      calcState := State.Solved;
    end;

  end;
end;


procedure TForm1.repeatLastElement ();
begin

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

end.
