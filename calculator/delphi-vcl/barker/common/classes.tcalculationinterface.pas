unit classes.tcalculationinterface;

interface

uses interfaces.icalculatorinterface;

{
  Developer: Ian Barker
           https://about.me/IanBarker
           https://www.codedotshow.com/blog
}

type TCalculator = Class(TInterfacedObject, ICalculator)
private
  FDisplayValue, FCurrentValue, FTotal, FHistory: string;
  FUpdateDisplay: TUpdateCalcDisplay;
  FOperator: TOperatorType;
  FIsError:  boolean;
  procedure SetCalcDisplay(TheValue: TUpdateCalcDisplay);
  procedure PerformCalculation;
  function GetCurrentTotal: string;
  function GetHistory: string;
  procedure DoDisplayUpdate;
  procedure ClearValues;
public
  constructor Create(const UpdateDisplayProc: TUpdateCalcDisplay);
  procedure NumberPressed(const Digit: Char);
  procedure OperatorPressed(const OperatorType: TOperatorType);
  procedure EqualsPressed;
  procedure BackSpacePressed;
  procedure ChangeSign;
  procedure DecimalPointPressed;
  procedure ClearPressed;
  property UpdateDisplay: TUpdateCalcDisplay write SetCalcDisplay;
  property History: string read GetHistory;
  property CurrentTotal: string read GetCurrentTotal;
end;

implementation
uses System.SysUtils, System.StrUtils;

{ TCalculator }

procedure TCalculator.BackSpacePressed;

  procedure RemoveSomething(var TheValue: string);
  begin
    if TheValue.Length > 1 then
      TheValue := LeftStr(TheValue, Pred(TheValue.Length))
    else
      TheValue := '0';
  end;

begin
  RemoveSomething(FCurrentValue);
  RemoveSomething(FHistory);
  FDisplayValue := FCurrentValue;
  DoDisplayUpdate;
end;

procedure TCalculator.ChangeSign;

  procedure ChangeTheSign(var TheValue: string);
  begin
    if Pos('-', TheValue) = 0 then
      TheValue := '-' + TheValue;
  end;

begin
  if not FIsError then
  begin
    ChangeTheSign(FCurrentValue);
    FDisplayValue := FCurrentValue;
    DoDisplayUpdate;
  end;
end;

procedure TCalculator.ClearPressed;
begin
  ClearValues;
  DoDisplayUpdate;
end;


procedure TCalculator.ClearValues;
begin
  FTotal        := '';
  FCurrentValue := '';
  FHistory      := '';
  FDisplayValue := '0';
  FOperator     := None;
  FIsError      := False;
end;

constructor TCalculator.Create(const UpdateDisplayProc: TUpdateCalcDisplay);
begin
  if not Assigned(UpdateDisplayProc) then
    raise Exception.Create('UpdateDisplayProc can''t blank')
  else
    FUpdateDisplay := UpdateDisplayProc;
  ClearValues;
end;

procedure TCalculator.DecimalPointPressed;

  procedure AddDecimal(var TheValue: string);
  var
    sAdd: string;
  begin
    if Pos('.', TheValue) = 0 then  // Don't do it if there is a decimal in there already
      if TheValue.Length = 0 then
        sAdd := '0.'
      else
        sAdd := '.';
    TheValue := Concat(TheValue, sAdd);
    FHistory := Concat(FHistory, ' ', sAdd);
  end;

begin
  if not FIsError then
  begin
    AddDecimal(FCurrentValue);
    FDisplayValue := FCurrentValue;
    DoDisplayUpdate;
  end;
end;

procedure TCalculator.DoDisplayUpdate;
begin
  if Assigned(FUpdateDisplay) then
    FUpdateDisplay;
end;

procedure TCalculator.EqualsPressed;
begin
  if not FIsError then
    if FCurrentValue.Length > 0 then
      if FOperator <> None then
      begin
        FHistory      := Concat(FHistory, ' = ');
        PerformCalculation;
        FCurrentValue := '';
        FOperator     := None;
      end;
end;

function TCalculator.GetCurrentTotal: string;
begin
  Result := FDisplayValue;
end;

function TCalculator.GetHistory: string;
begin
  Result := FHistory;
end;

procedure TCalculator.NumberPressed(const Digit: Char);
begin
  if FIsError or (FCurrentValue.Length = 0) or SameText(FCurrentValue, '0') then
    begin
      FCurrentValue := Concat('', Digit);
      if not FIsError  then
        FHistory := TrimLeft(Concat(FHistory, ' ', FCurrentValue));
    end
  else
    begin
      FCurrentValue := Concat(FCurrentValue, Digit);
      FHistory      := Concat(FHistory, Digit);
    end;
  FDisplayValue := FCurrentValue;
  DoDisplayUpdate;
end;

procedure TCalculator.OperatorPressed(const OperatorType: TOperatorType);
begin
  if not FIsError then
    if FOperator <> OperatorType then
    begin
      if FTotal.Length = 0 then
        begin
          FOperator     := OperatorType;
          if FCurrentValue.Length > 0 then
          begin
            FTotal        := FCurrentValue;
            FCurrentValue := '';
          end;
        end
      else
        begin
          EqualsPressed;
          FOperator     := OperatorType;
        end;
      FDisplayValue := TOperatorText[OperatorType];
      FHistory := Concat(FHistory,  ' ', FDisplayValue, ' ');
    end;
  DoDisplayUpdate;
end;

procedure TCalculator.PerformCalculation;
var
  dResult, dLeft, dRight: Double;
begin
  if FOperator <> None then
  begin
    dResult := 0.0;
    if (FCurrentValue.Length > 0) and (not FIsError) then
    begin
      try
        if FTotal.Length = 0 then
          dLeft := 0.0
        else
          dLeft := StrToFloat(FTotal);
        dRight := StrToFloat(FCurrentValue);
        case FOperator of
          Add:
            dResult := dLeft + dRight;
          Subtract:
            dResult := dLeft - dRight;
          Divide:
            dResult := dLeft / dRight;
          Multiply:
            dResult := dLeft * dRight;
        else
          begin
            //Percent, OneOverX, XSquared, SquareRootX
            FIsError      := True;
            FOperator     := None;
            FCurrentValue := 'E';
            FHistory      := 'Can''t do that at the moment!';
          end;
        end;
      except
        on E: EConvertError do
        begin
          FIsError      := True;
          FTotal        := 'E';
          FCurrentValue := '';
          FHistory      := 'Error';
          FOperator     := None;
        end;
      end;
      if not FIsError then
      begin
        FTotal   := FormatFloat('0.#', dResult);
        FHistory := Concat(FHistory, ' ', FTotal);
      end;
      FCurrentValue := '';
      FOperator     := None;
      FDisplayValue := FTotal;
      DoDisplayUpdate;
    end;
  end;
end;

procedure TCalculator.SetCalcDisplay(TheValue: TUpdateCalcDisplay);
begin
  FUpdateDisplay := TheValue;
end;

end.
