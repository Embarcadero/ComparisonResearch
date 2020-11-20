unit uDM;

interface

uses
  System.SysUtils, System.Classes, System.Actions,
  FMX.ActnList, FMX.StdActns;

type
  TFileData = record
    FullFilename: string;
    Filename: string;
    DateModified: TDateTime;
    Filetype: string;
    Size: Int64;
    const
      NoSizeInfo = -1;
    procedure ObtainInfo(const AFullFilename: string);
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
    procedure PutFileToClipboard(FilePath: string);
  end;

var
  dm: Tdm;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

uses
{$IFDEF MSWINDOWS}
  WinAPI.ShlObj,
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

procedure Tdm.PutFileToClipboard(FilePath: string);
{$IFDEF MSWINDOWS}
procedure WinPutFileToClipboard;
var
  Data: THandle;
  Dropfiles: PDropFiles;
begin
  FilePath := FilePath + #0#0;
  if not OpenClipboard(0) then
    RaiseLastOSError;
  try
    if not EmptyClipboard then
      RaiseLastOSError;
    Data := GlobalAlloc(GMEM_MOVEABLE or GMEM_ZEROINIT, SizeOf(TDropFiles) + Length(FilePath) * SizeOf(Char));
    if Data = 0 then
      RaiseLastOSError;
    try
      DropFiles := GlobalLock(Data);
      try
        DropFiles^.pFiles := SizeOf(TDropFiles);
        DropFiles^.fWide := True;
        Move(PChar(FilePath)^, (PByte(DropFiles) + SizeOf(TDropFiles))^, Length(FilePath) * SizeOf(Char));

        if SetClipboardData(CF_HDROP, Data) = 0 then
          RaiseLastOSError;
      finally
        GlobalUnlock(Data);
      end;
    except
      GlobalFree(Data);
      raise;
    end;
  finally
    if not CloseClipboard then
      RaiseLastOSError;
  end;

end;
{$ENDIF}
begin
{$IFDEF MSWINDOWS}
  WinPutFileToClipboard;
{$ENDIF}
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

procedure TFileData.ObtainInfo(const AFullFilename: string);
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
  FullFilename := TPath.GetFullPath(AFullFilename);
  Filename := TPath.GetFileName(FullFilename);
  DateModified := TFile.GetLastWriteTime(FullFilename);
  Size := GetFileSize;
  Filetype := GetFileTypeDescription;
end;

end.
