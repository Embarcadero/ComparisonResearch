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
    procedure DataModuleDestroy(Sender: TObject);
    procedure DataModuleCreate(Sender: TObject);
  private
    FTmpFilename: string;
    FTmpFile: TextFile;
    function IsWindowsDrivePath(Path: string): Boolean;
    function SearchTextToFilePattern(SearchText: string): string;
  public
    function GetFolderName(FolderPath: string): string;
    function GetSubFolders(Path: string): TArray<string>;
    function GetFilesData(Path, SearchText: string): TFilesData;
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
  Macapi.Helpers,
  Macapi.Foundation,
  Posix.Stdlib,
{$ELSEIF Defined(LINUX)}
  FMX.Types,
  Posix.Base,
  Posix.Errno,
  Posix.Fcntl,
{$ENDIF}
  System.IOUtils;

{$R *.dfm}

{$IFDEF LINUX}
type
  TStreamHandle = pointer;

function popen(const command: MarshaledAString; const _type: MarshaledAString): TStreamHandle; cdecl;
  external libc name _PU + 'popen';
function pclose(filehandle: TStreamHandle): int32; cdecl; external libc name _PU + 'pclose';
function fgets(buffer: pointer; Size: int32; Stream: TStreamHandle): pointer; cdecl; external libc name _PU + 'fgets';
function BufferToString(buffer: pointer; MaxSize: uint32): string;
var
  cursor: ^uint8;
  EndOfBuffer: nativeuint;
begin
  Result := '';
  if not assigned(buffer) then
    exit;
  cursor := buffer;
  EndOfBuffer := nativeuint(cursor) + MaxSize;
  while (nativeuint(cursor) < EndOfBuffer) and (cursor^ <> 0) do
  begin
    Result := Result + chr(cursor^);
    cursor := pointer(succ(nativeuint(cursor)));
  end;
end;
{$ENDIF}

procedure Tdm.DataModuleDestroy(Sender: TObject);
begin
  try
    CloseFile(FTmpFile);
  finally
    Erase(FTmpFile);
  end;
end;

procedure Tdm.DataModuleCreate(Sender: TObject);
begin
  FTmpFileName := TPath.GetTempFileName;
  AssignFile(FTmpFile, FTmpFileName);
end;

{ TDataModule2 }

function Tdm.GetFilesData(Path, SearchText: string): TFilesData;
{$IFDEF LINUX}
var
  Data: array[0..511] of uint8;
  Handle: TStreamHandle;
  AllDescriptions: string;
{$ENDIF}
begin
  var Names := TDirectory.GetFiles(Path, SearchTextToFilePattern(SearchText));
  SetLength(Result, Length(Names));
  for var i := Low(Names) to High(Names) do
    Result[i].ObtainInfo(Names[i]);
{$IFDEF LINUX}
  var AllNames: string;
  for var i := Low(Names) to High(Names) do
    AllNames := AllNames + Names[i] + sLineBreak;

  Rewrite(FTmpFile);
  Write(FTmpFile, AllNames);
  Flush(FTmpFile);

  Handle := popen(PAnsiChar(AnsiString('mimetype -d -b ' + FTmpFilename)),'r');
  if Handle = nil then
    Log.d('%d', [errno])
  else
  begin
    try
      while fgets(@Data, SizeOf(Data), Handle) <> nil do
        AllDescriptions := AllDescriptions + BufferToString(@Data[0], SizeOf(Data));
    finally
      pclose(Handle);
    end;
    AllDescriptions := AllDescriptions.TrimRight([#10]);
    var Descriptions := AllDescriptions.Split([sLineBreak]);
    Assert(High(Descriptions) = High(Result));
    for var i := Low(Descriptions) to High(Descriptions) do
      Result[i].Filetype := Descriptions[i];
  end;

{$ENDIF}
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
      var Dropfiles: PDropFiles := GlobalLock(Data);
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
    var FileURL := TNSUrl.Wrap(TNSUrl.OCCLass.fileURLWithPath(StrToNSStr(FilePath)));
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
    if SearchText.IndexOfAny(['*','?']) = -1 then
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
      var FileInfo : SHFILEINFO;
        SHGetFileInfo(PChar(ExtractFileExt(FullFileName)),
                      FILE_ATTRIBUTE_NORMAL,
                      FileInfo,
                      SizeOf(FileInfo),
                      SHGFI_TYPENAME or SHGFI_USEFILEATTRIBUTES
                      );
        Result := FileInfo.szTypeName;
    {$ELSEIF Defined(MACOS)}
      var pnsstr: Pointer;
      var URL := TNSUrl.Wrap(TNSUrl.OCCLass.fileURLWithPath(StrToNSStr(FullFilename)));

      if URL.getResourceValue(@pnsstr, NSURLLocalizedTypeDescriptionKey, nil) then
        Result := NSStrToStr(TNSString.Wrap(pnsstr))
      else
        Result := '';
    {$ELSEIF Defined(LINUX)}
      Result := ''; {getting file description through 'mimetype -d -b' for every file is very slow,
        so for Linux file descriptions are got in bulk}
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
