program Calculator;

uses
  System.StartUpCopy,
  FMX.Forms,
  fCalcMain in 'fCalcMain.pas' {frmCalcMain};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmCalcMain, frmCalcMain);
  Application.Run;
end.
