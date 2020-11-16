unit uDM;

interface

uses
  System.SysUtils, System.Classes, System.Actions,
  FMX.ActnList, FMX.StdActns;

type
  TFileData = record
    Filename: string;
    DateModified: TDateTime;
    Filetype: string;
    Size: Int64;
    const
      NoSizeInfo = -1;
    procedure ObtainInfo(const FullFilename: string);
  end;

  TFilesData = TArray<TFileData>;

  Tdm = class(TDataModule)
    ActionList1: TActionList;
    FileExit1: TFileExit;
  private
    function IsWindowsDrivePath(Path: string): Boolean;
    function SearchTextToFilePattern(SearchText: string): string;
  public
    function GetFolderName(FolderPath: string): string;
    function GetSubFolders(Path: string): TArray<string>;
    function GetFilesData(Path, SearchText: string): TFilesData;
  end;

var
  dm: Tdm;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

uses
{$IFDEF MSWINDOWS}
  WinAPI.ShellAPI,
  WinAPI.Windows,
{$ENDIF}
  System.IOUtils;

{$R *.dfm}

{ TDataModule2 }

function Tdm.GetFilesData(Path, SearchText: string): TFilesData;
begin
  var Names := TDirectory.GetFiles(Path, SearchTextToFilePattern(SearchText));
  SetLength(Result, Length(Names));
  for var i := Low(Names) to High(Names) do
    Result[i].ObtainInfo(Names[i]);
end;

function Tdm.GetFolderName(FolderPath: string): string;
begin
  if (FolderPath = PathDelim) then
    Result := FolderPath
  else
    if IsWindowsDrivePath(FolderPath) then
      Result := Copy(FolderPath, 1, 2)
    else
      Result := TPath.GetFilename(FolderPath)
end;

function Tdm.GetSubFolders(Path: string): TArray<string>;
begin
  Assert(Path.Length > 0);
  if (TOsVersion.Platform <> pfWindows) or (Path.Length <> 1) or not IsPathDelimiter(Path, High(Path)) then
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
    {$ENDIF}
  end;
end;

function Tdm.IsWindowsDrivePath(Path: string): Boolean;
begin
  Result := (TOSVersion.Platform = pfWindows) and (Path.Length = 3) and
    Path.Contains(':\');
end;

function Tdm.SearchTextToFilePattern(SearchText: string): string;
begin
  if SearchText = '' then
    Result := '*'
  else
    if SearchText.IndexOfAny(['*','?']) = -1 then
      Result := SearchText
    else
      Result := '*' + SearchText + '*';
end;

{ TFileData }

procedure TFileData.ObtainInfo(const FullFilename: string);
  function GetFileSize: Int64;
  var S: TSearchRec;
  begin
    if FindFirst(FullFilename, faAnyFile, S) = 0 then
      Result := S.Size
    else
      Result := NoSizeInfo;
  end;
  function GetFileTypeDescription: string;
  begin
    {$IFDEF MSWINDOWS}
      var FileInfo : SHFILEINFO;
        SHGetFileInfo(PChar(ExtractFileExt(FullFileName)),
                      FILE_ATTRIBUTE_NORMAL,
                      FileInfo,
                      SizeOf(FileInfo),
                      SHGFI_TYPENAME or SHGFI_USEFILEATTRIBUTES
                      );
        Result := FileInfo.szTypeName;
    {$ELSE}
      {$MESSAGE ERROR 'TODO : implement for other platforms'}
    {$ENDIF}
  end;
begin
  Filename := TPath.GetFileName(FullFilename);
  DateModified := TFile.GetLastWriteTime(FullFilename);
  Size := GetFileSize;
  Filetype := GetFileTypeDescription;
end;

end.
