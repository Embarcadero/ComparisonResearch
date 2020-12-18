program FMXFileExplorer;

uses
  System.StartUpCopy,
  FMX.Forms,
  uMain in 'uMain.pas' {Form1},
  uDM in 'uDM.pas' {dm: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(Tdm, dm);
  Application.Run;
end.
