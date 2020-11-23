unit fCalcMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects;

type
{$SCOPEDENUMS ON}
  TCalcOperator = (None, Ajouter { + } , Soustraire { - } , Multiplier { * } ,
    Diviser { / } , Equal { = } );
  TCalcDirectOperator = (Square, RootSquare, Inverse, Percent);
{$SCOPEDENUMS OFF}

  TfrmCalcMain = class(TForm)
    gplButtons: TGridPanelLayout;
    lblCalculs: TLabel;
    lblResult: TLabel;
    btnPourcent: TButton;
    btnCE: TButton;
    btnC: TButton;
    btnBackspace: TButton;
    btnInverse: TButton;
    btnSquare: TButton;
    btnSquareRoot: TButton;
    btnDiv: TButton;
    btn7: TButton;
    btn8: TButton;
    btn9: TButton;
    btnMul: TButton;
    btn4: TButton;
    btn5: TButton;
    btn6: TButton;
    btnDec: TButton;
    btn1: TButton;
    btn2: TButton;
    btn3: TButton;
    btnAdd: TButton;
    btnOppose: TButton;
    btn0: TButton;
    btnDot: TButton;
    btnEqual: TButton;
    StyleBook1: TStyleBook;
    rDisplay: TRectangle;
    rOpacityOn: TPath;
    rOpacityOff: TPath;
    rOpacity: TRectangle;
    lbackground: TLayout;
    procedure NumberButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure btnPourcentClick(Sender: TObject);
    procedure btnCEClick(Sender: TObject);
    procedure btnCClick(Sender: TObject);
    procedure btnBackspaceClick(Sender: TObject);
    procedure btnInverseClick(Sender: TObject);
    procedure btnSquareClick(Sender: TObject);
    procedure btnSquareRootClick(Sender: TObject);
    procedure btnDivClick(Sender: TObject);
    procedure btnMulClick(Sender: TObject);
    procedure btnDecClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnEqualClick(Sender: TObject);
    procedure btnDotClick(Sender: TObject);
    procedure btnOpposeClick(Sender: TObject);
    procedure rOpacityClick(Sender: TObject);
  private
    { Déclarations privées }
    CurTotal: string; // current total
    CurTotalCalc: string; // actual operation
    CurPosNeg: string; // + or -
    PrevValue: string; // = curValue after Equal
    CurValue: string; // current value
    CurOperator: TCalcOperator;
    FAppOpacity: boolean; // current operation
    procedure TapNumber(AValue: byte);
    procedure TapOperator(AOperator: TCalcOperator);
    procedure TapDirectOperator(AOperator: TCalcDirectOperator);
    procedure TapBackspace;
    procedure TapCE;
    procedure TapC;
    procedure TapDot;
    procedure TapPlusMinus;
    procedure InitCalculator;
    procedure ChangeDisplayedResult(AValue: string);
    procedure ChangeDisplayedCalcul(ACalcul: string);
    procedure CalcTotal(AValue: string; OpStringToAdd: string = '');
    procedure SetAppOpacity(const Value: boolean);
    property AppOpacity: boolean read FAppOpacity write SetAppOpacity;
  public
    { Déclarations publiques }
    DecimalSeparator: Char;
  end;

var
  frmCalcMain: TfrmCalcMain;

implementation

{$R *.fmx}

uses
  System.Character, System.Threading, FMX.Ani;

{ TfrmCalcMain }

procedure TfrmCalcMain.btnAddClick(Sender: TObject);
begin
  TapOperator(TCalcOperator.Ajouter);
end;

procedure TfrmCalcMain.btnBackspaceClick(Sender: TObject);
begin
  TapBackspace;
end;

procedure TfrmCalcMain.btnCClick(Sender: TObject);
begin
  TapC;
end;

procedure TfrmCalcMain.btnCEClick(Sender: TObject);
begin
  TapCE;
end;

procedure TfrmCalcMain.btnDecClick(Sender: TObject);
begin
  TapOperator(TCalcOperator.Soustraire);
end;

procedure TfrmCalcMain.btnDivClick(Sender: TObject);
begin
  TapOperator(TCalcOperator.Diviser);
end;

procedure TfrmCalcMain.btnDotClick(Sender: TObject);
begin
  TapDot;
end;

procedure TfrmCalcMain.btnEqualClick(Sender: TObject);
begin
  TapOperator(TCalcOperator.Equal);
end;

procedure TfrmCalcMain.btnInverseClick(Sender: TObject);
begin
  TapDirectOperator(TCalcDirectOperator.Inverse);
end;

procedure TfrmCalcMain.btnMulClick(Sender: TObject);
begin
  TapOperator(TCalcOperator.Multiplier);
end;

procedure TfrmCalcMain.btnOpposeClick(Sender: TObject);
begin
  TapPlusMinus;
end;

procedure TfrmCalcMain.btnPourcentClick(Sender: TObject);
begin
  TapDirectOperator(TCalcDirectOperator.Percent);
end;

procedure TfrmCalcMain.btnSquareClick(Sender: TObject);
begin
  TapDirectOperator(TCalcDirectOperator.Square);
end;

procedure TfrmCalcMain.btnSquareRootClick(Sender: TObject);
begin
  TapDirectOperator(TCalcDirectOperator.RootSquare);
end;

procedure TfrmCalcMain.CalcTotal(AValue: string; OpStringToAdd: string = '');
var
  v, t: extended;
begin
  if AValue.IsEmpty or (AValue = '-') then
    exit;
  if OpStringToAdd.IsEmpty then
    OpStringToAdd := AValue;
  if CurTotalCalc.IsEmpty then
  begin
    CurTotalCalc := AValue;
    CurTotal := AValue;
    ChangeDisplayedCalcul(CurTotalCalc + ' =');
    ChangeDisplayedResult(CurTotal);
  end
  else
  begin
    try
      v := AValue.ToExtended;
    except
      v := 0;
    end;
    try
      t := CurTotal.ToExtended;
    except
      t := 0;
    end;
    case CurOperator of
      TCalcOperator.Ajouter:
        begin
          CurTotalCalc := CurTotalCalc + ' + ' + OpStringToAdd;
          CurTotal := (t + v).ToString;
        end;
      TCalcOperator.Soustraire:
        begin
          CurTotalCalc := CurTotalCalc + ' - ' + OpStringToAdd;
          CurTotal := (t - v).ToString;
        end;
      TCalcOperator.Multiplier:
        begin
          CurTotalCalc := '(' + CurTotalCalc + ') * ' + OpStringToAdd;
          CurTotal := (t * v).ToString;
        end;
      TCalcOperator.Diviser:
        if (v <> 0) then
        begin
          CurTotalCalc := '(' + CurTotalCalc + ') / ' + OpStringToAdd;
          CurTotal := (t / v).ToString;
        end;
    end;
    ChangeDisplayedCalcul(CurTotalCalc + ' =');
    ChangeDisplayedResult(CurTotal);
  end;
end;

procedure TfrmCalcMain.ChangeDisplayedCalcul(ACalcul: string);
begin
  lblCalculs.Text := ACalcul;
end;

procedure TfrmCalcMain.ChangeDisplayedResult(AValue: string);
begin
  if AValue.IsEmpty or (AValue = CurPosNeg) then
    lblResult.Text := '0'
  else
    lblResult.Text := AValue;
end;

procedure TfrmCalcMain.FormCreate(Sender: TObject);
begin
  AppOpacity := false;
  DecimalSeparator := TFormatSettings.Create.DecimalSeparator;
  btnSquare.Text := 'x²';
  btnSquareRoot.Text := '√x';
  btnBackspace.Text := #$232B;
  InitCalculator;
end;

procedure TfrmCalcMain.FormKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
var
  btn: TButton;
  num: integer;
  ctrl: TFmxObject;
  i: integer;
begin
  btn := nil;
  if KeyChar.IsDigit then
  begin
    num := trunc(KeyChar.GetNumericValue);
    for i := 0 to gplButtons.Children.Count - 1 do
    begin
      ctrl := gplButtons.Children[i];
      if (ctrl is TButton) and ((ctrl as TButton).tag = num + 100) then
      begin
        btn := (ctrl as TButton);
        break;
      end;
    end;
    TapNumber(num);
  end
  else if (Key = vkBack) then
  begin
    btn := btnBackspace;
    TapBackspace;
  end
  else if (Key = vkReturn) or (KeyChar = '=') then
  begin
    btn := btnEqual;
    TapOperator(TCalcOperator.Equal);
  end
  else if (Key = vkDelete) then
  begin
    btn := btnCE;
    TapCE;
  end
  else
    case KeyChar of
      '+':
        begin
          btn := btnAdd;
          TapOperator(TCalcOperator.Ajouter);
        end;
      '-':
        begin
          btn := btnDec;
          TapOperator(TCalcOperator.Soustraire);
        end;
      '*':
        begin
          btn := btnMul;
          TapOperator(TCalcOperator.Multiplier);
        end;
      '/':
        begin
          btn := btnDiv;
          TapOperator(TCalcOperator.Diviser);
        end;
      '%':
        begin
          btn := btnPourcent;
          TapDirectOperator(TCalcDirectOperator.Percent);
        end;
      '.', ',':
        begin
          btn := btnDot;
          TapDot;
        end;
    end;
  if assigned(btn) then
  begin
    tanimator.AnimateFloat(btn, 'Opacity', 0.5, 0.1);
    tanimator.AnimateFloatDelay(btn, 'Opacity', 1, 0.1, 0.15);
  end;
end;

procedure TfrmCalcMain.InitCalculator;
begin
  lblCalculs.Text := '';
  lblResult.Text := '';
  CurTotal := '0';
  CurTotalCalc := '';
  CurValue := '';
  PrevValue := '';
  CurPosNeg := '';
  CurOperator := TCalcOperator.None;
  ChangeDisplayedCalcul('');
  ChangeDisplayedResult('0');
end;

procedure TfrmCalcMain.NumberButtonClick(Sender: TObject);
begin
  if (Sender is TButton) then
    TapNumber((Sender as TButton).Text.tointeger);
end;

procedure TfrmCalcMain.rOpacityClick(Sender: TObject);
begin
  AppOpacity := not AppOpacity;
end;

procedure TfrmCalcMain.SetAppOpacity(const Value: boolean);
begin
  FAppOpacity := Value;
  rOpacityOn.Visible := not FAppOpacity;
  rOpacityOff.Visible := FAppOpacity;
  if FAppOpacity then
  begin
    Transparency := true;
    lbackground.opacity := 0.8;
  end
  else
  begin
    Transparency := false;
    lbackground.opacity := 1;
  end;
end;

procedure TfrmCalcMain.TapBackspace;
begin
  CurValue := CurValue.Substring(0, CurValue.Length - 1);
  ChangeDisplayedResult(CurPosNeg + CurValue);
end;

procedure TfrmCalcMain.TapC;
begin
  InitCalculator;
end;

procedure TfrmCalcMain.TapCE;
begin
  if CurValue.IsEmpty then
    TapC
  else
  begin
    CurPosNeg := '';
    CurValue := '';
    ChangeDisplayedResult(CurPosNeg + CurValue);
  end;
end;

procedure TfrmCalcMain.TapDirectOperator(AOperator: TCalcDirectOperator);
var
  v: extended;
begin
  // if lblCalculs.Text.EndsWith('=') then
  if CurValue.IsEmpty then
    if CurTotal.StartsWith('-') then
    begin
      CurPosNeg := '-';
      CurValue := CurTotal.Substring(1);
    end
    else
    begin
      CurPosNeg := '';
      CurValue := CurTotal;
    end;
  if CurValue.IsEmpty then
    CurValue := '0';
  try
    v := CurValue.ToExtended;
  except
    v := 0;
  end;
  case AOperator of
    TCalcDirectOperator.RootSquare:
      begin
        CurValue := sqrt(v).ToString;
        // CalcTotal(CurValue, v.ToString + '²');
      end;
    TCalcDirectOperator.Square:
      begin
        CurValue := (v * v).ToString;
        // CalcTotal(CurValue, '√' + v.ToString);
      end;
    TCalcDirectOperator.Inverse:
      begin
        if (v <> 0) then
          CurValue := (1 / v).ToString;
        // CalcTotal(CurValue, '1/' + v.ToString);
      end;
    TCalcDirectOperator.Percent:
      begin
        CurValue := (v / 100).ToString;
        // ChangeDisplayedResult(CurValue);
      end;
  end;
  ChangeDisplayedResult(CurValue);
end;

procedure TfrmCalcMain.TapDot;
begin
  if CurValue.IsEmpty then
    CurValue := '0';
  if (CurValue.IndexOf(DecimalSeparator) < 0) then
  begin
    CurValue := CurValue + DecimalSeparator;
    ChangeDisplayedResult(CurPosNeg + CurValue);
  end;
end;

procedure TfrmCalcMain.TapNumber(AValue: byte);
var
  NewValue: extended;
begin
  if CurValue = '0' then
    CurValue := AValue.ToString
  else
    CurValue := CurValue + AValue.ToString;
  try
    NewValue := CurValue.ToExtended;
  except
    TapBackspace;
  end;
  ChangeDisplayedResult(CurPosNeg + CurValue);
end;

procedure TfrmCalcMain.TapOperator(AOperator: TCalcOperator);
begin
  if AOperator = TCalcOperator.None then
    ChangeDisplayedCalcul(CurTotalCalc)
  else if AOperator = TCalcOperator.Equal then
  begin
    if (CurOperator in [TCalcOperator.Ajouter, TCalcOperator.Soustraire,
      TCalcOperator.Multiplier, TCalcOperator.Diviser]) then
    begin
      if (not CurValue.IsEmpty) then
      begin
        CalcTotal(CurPosNeg + CurValue);
        PrevValue := CurPosNeg + CurValue;
        CurPosNeg := '';
        CurValue := '';
      end
      else if (not PrevValue.IsEmpty) then
        CalcTotal(PrevValue);
    end;
  end
  else
  begin
    if lblCalculs.Text.EndsWith('=') then
    begin
      if CurValue.IsEmpty then
      begin
        CurValue := CurTotal;
        CurPosNeg := '';
      end;
      CurOperator := TCalcOperator.None;
      CurTotalCalc := '';
      CurTotal := '';
    end;
    CalcTotal(CurPosNeg + CurValue);
    PrevValue := CurPosNeg + CurValue;
    CurPosNeg := '';
    CurValue := '';
    CurOperator := AOperator;
    case CurOperator of
      TCalcOperator.Ajouter:
        ChangeDisplayedCalcul(CurTotalCalc + ' +');
      TCalcOperator.Soustraire:
        ChangeDisplayedCalcul(CurTotalCalc + ' -');
      TCalcOperator.Multiplier:
        ChangeDisplayedCalcul('(' + CurTotalCalc + ') *');
      TCalcOperator.Diviser:
        ChangeDisplayedCalcul('(' + CurTotalCalc + ') /');
    end;
  end;
end;

procedure TfrmCalcMain.TapPlusMinus;
begin
  if CurValue.IsEmpty then
    if lblCalculs.Text.EndsWith('=') then
      CurValue := CurTotal
    else
      CurValue := '0';
  if CurPosNeg.IsEmpty then
    CurPosNeg := '-'
  else
    CurPosNeg := '';
  ChangeDisplayedResult(CurPosNeg + CurValue);
end;

end.
