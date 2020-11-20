program Calculator;

uses
  System.StartUpCopy,
  FMX.Forms,
  Calculator.Forms.Main in 'Calculator.Forms.Main.pas' {FormMain},
  Calculator.Forms.Transparent in 'Calculator.Forms.Transparent.pas',
  Calculator.Engine in 'Calculator.Engine.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
