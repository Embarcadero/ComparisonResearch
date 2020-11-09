unit uDM;

interface

uses
  System.SysUtils, System.Classes, System.Actions, FMX.ActnList, FMX.StdActns;

type
  Tdm = class(TDataModule)
    ActionList1: TActionList;
    FileExit1: TFileExit;
  private
    function IsWindowsDrivePath(Path: string): Boolean;
  public
    function GetFilename(Path: string): string;
    function GetSubFolders(Path: string): TArray<string>;
  end;

var
  dm: Tdm;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

uses
  System.IOUtils;

{$R *.dfm}

{ TDataModule2 }

function Tdm.GetFilename(Path: string): string;
begin
  if (Path = PathDelim) then
    Result := Path
  else
    if IsWindowsDrivePath(Path) then
      Result := Copy(Path, 1, 2)
    else
      Result := TPath.GetFileName(Path)
end;

function Tdm.GetSubFolders(Path: string): TArray<string>;
begin
  Assert(Path.Length > 0);
  if (Path.Length <> 1) or not IsPathDelimiter(Path, High(Path)) then
    try
      Result := TDirectory.GetDirectories(Path);
    except
      on E: EDirectoryNotFoundException do
        Result := nil
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

function Tdm.IsWindowsDrivePath(Path: string): Boolean;
begin
  Result := (TOSVersion.Platform = pfWindows) and (Path.Length = 3) and
    Path.Contains(':\');
end;

end.
