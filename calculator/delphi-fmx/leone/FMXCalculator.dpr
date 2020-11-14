program FMXCalculator;

uses
  System.StartUpCopy,
  FMX.Forms,
  FMXCalculatorLogic in 'FMXCalculatorLogic.pas' {Form1},
  Equation in 'Equation.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
