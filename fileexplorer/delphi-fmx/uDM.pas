unit uDM;

interface

uses
  System.SysUtils, System.Classes, System.Actions, FMX.ActnList, FMX.StdActns;

type
  TFileData = record
    FullFilename, Filename, Filetype: string;
    DateModified: TDateTime;
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
    function GetFilesData(Path, SearchText: string): TFilesData;
    function GetFolderName(FolderPath: string): string;
    function GetSubFolders(Path: string): TArray<string>;
    procedure PutFileToClipboard(FilePath: string);
    procedure ShellOpen(WhatToOpen: string);
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
{$ELSEIF Defined(MACOS)}
  Macapi.AppKit,
  Macapi.Foundation,
  Macapi.Helpers,
  Macapi.ObjectiveC,
  Posix.Stdlib,
{$ENDIF}
  System.IOUtils;

{$R *.dfm}

{ Tdm }

function Tdm.GetFilesData(Path, SearchText: string): TFilesData;
begin
  var Names := TDirectory.GetFiles(Path, SearchTextToFilePattern(SearchText));
  SetLength(Result, Length(Names));
  for var i := Low(Names) to High(Names) do
    Result[i].ObtainInfo(Names[i]);
end;

function Tdm.GetFolderName(FolderPath: string): string;
begin
  if FolderPath = PathDelim then
    Result := FolderPath
  else
    if IsWindowsDrivePath(FolderPath) then
      Result := Copy(FolderPath, 1, 2)
    else
      Result := TPath.GetFileName(FolderPath);
end;

function Tdm.GetSubFolders(Path: string): TArray<string>;
begin
  Assert(Path.Length > 0);
  if (TOSVersion.Platform <> pfWindows) or (Path.Length <> 1) or not IsPathDelimiter(Path, High(Path)) then
    if TDirectory.Exists(Path) then
      Result := TDirectory.GetDirectories(Path)
    else
      Result := nil
  else
    Result := TDirectory.GetLogicalDrives;
end;

function Tdm.IsWindowsDrivePath(Path: string): Boolean;
begin
  Result := (TOSVersion.Platform = pfWindows) and (Path.Length = 3) and Path.Contains(':\');
end;

procedure Tdm.PutFileToClipboard(FilePath: string);
begin
{$IFDEF MSWINDOWS}
  FilePath := FilePath + #0#0;
  if not OpenClipboard(0) then
    RaiseLastOSError;
  try
    if not EmptyClipboard then
      RaiseLastOSError;
    var Data: THandle := GlobalAlloc(GMEM_MOVEABLE or GMEM_ZEROINIT, SizeOf(TDropFiles) + Length(FilePath) * SizeOf(Char));
    if Data = 0 then
      RaiseLastOSError;
    try
      var DropFiles: PDropFiles := GlobalLock(Data);
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
{$ELSEIF Defined(MACOS)}
    var Pasteboard := TNSPasteboard.Wrap(TNSPasteboard.OCClass.generalPasteboard);
    var FileURL := TNSURL.Wrap(TNSURL.OCClass.fileURLWithPath(StrToNSStr(FilePath)));
    var fileArray := TNSArray.Wrap(TNSArray.OCClass.arrayWithObject(NSObjectToID(FileURL)));

    Pasteboard.clearContents;
    Pasteboard.writeObjects(fileArray);
{$ENDIF}
end;

function Tdm.SearchTextToFilePattern(SearchText: string): string;
begin
  if SearchText = '' then
    Result := '*'
  else
    if SearchText.IndexOfAny(['*', '?']) = -1 then
      Result := SearchText
    else
      Result := '*' + SearchText + '*';
end;

procedure Tdm.ShellOpen(WhatToOpen: string);
begin
  {$IFDEF MSWINDOWS}
    ShellExecute(0, 'OPEN', PChar(WhatToOpen), nil, nil, SW_SHOWNORMAL);
  {$ELSEIF Defined(MACOS)}
    _system(PAnsiChar('open ' + AnsiString(WhatToOpen)));
  {$ENDIF}
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
      var FileInfo: SHFILEINFO;
      SHGetFileInfo(PChar(ExtractFileExt(FullFilename)),
        FILE_ATTRIBUTE_NORMAL,
        FileInfo,
        SizeOf(FileInfo),
        SHGFI_TYPENAME or SHGFI_USEFILEATTRIBUTES);
      Result := FileInfo.szTypeName;
    {$ELSEIF Defined(MACOS)}
      var pnsstr: Pointer;
      var URL := TNSUrl.Wrap(TNSURL.OCClass.fileURLWithPath(StrToNSStr(FullFilename)));

      if URL.getResourceValue(@pnsstr, NSURLLocalizedTypeDescriptionKey, nil) then
        Result := NSStrToStr(TNSString.Wrap(pnsstr))
      else
        Result := '';
    {$ELSE}
      Result := '';
    {$ENDIF}
  end;
begin
  FullFilename := TPath.GetFullPath(AFullFilename);
  Filename := TPath.GetFileName(AFullFilename);
  DateModified := TFile.GetLastWriteTime(FullFilename);
  Size := GetFileSize;
  Filetype := GetFileTypeDescription;
end;

end.
