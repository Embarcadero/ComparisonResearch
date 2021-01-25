program UnicodeReader;

uses
  System.StartUpCopy,
  FMX.Forms,
  uUnicodeReader in 'uUnicodeReader.pas' {MainForm},
  uDM in 'uDM.pas' {DM: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TDM, DM);
  Application.Run;
end.

