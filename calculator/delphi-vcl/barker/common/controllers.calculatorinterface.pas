unit controllers.calculatorinterface;

interface
uses interfaces.icalculatorinterface;

var
  FCalculatorController: ICalculator;
  procedure CreateCalculatorController(UpdateDisplayProc: TUpdateCalcDisplay);

implementation
uses classes.tcalculationinterface;

procedure CreateCalculatorController(UpdateDisplayProc: TUpdateCalcDisplay);
begin
  FCalculatorController := TCalculator.Create(UpdateDisplayProc);
end;


end.
