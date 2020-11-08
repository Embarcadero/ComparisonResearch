unit uDM;

interface

uses
  System.SysUtils, System.Classes, System.Actions, FMX.ActnList, FMX.StdActns;

type
  TDataModule2 = class(TDataModule)
    ActionList1: TActionList;
    FileExit1: TFileExit;
  private
    { Private declarations }
  public
    function GetSubFolders(Path: string): TArray<string>;
  end;

var
  DataModule2: TDataModule2;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

uses
  System.IOUtils;

{$R *.dfm}

{ TDataModule2 }

function TDataModule2.GetSubFolders(Path: string): TArray<string>;
begin
  Assert(Path.Length > 0);
  if (Path.Length <> 1) or not IsPathDelimiter(Path, High(Path)) then
  begin
  end
  else
  begin
    {$IFDEF MSWINDOWS}
      Result := TDirectory.GetLogicalDrives;
    {$ELSE}
      {$MESSAGE FATAL 'TODO: implement}
    {$ENDIF}
  end;
end;

end.
