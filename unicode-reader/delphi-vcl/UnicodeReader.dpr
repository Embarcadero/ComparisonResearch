program UnicodeReader;

uses
  Vcl.Forms,
  uUnicodeReader in 'uUnicodeReader.pas' {MainForm},
  Vcl.Themes,
  Vcl.Styles,
  uDM in 'uDM.pas' {DM: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Windows10 Blue Whale');
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TDM, DM);
  Application.Run;
end.
