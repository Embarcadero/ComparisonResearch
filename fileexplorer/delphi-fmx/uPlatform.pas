unit uPlatform;

interface

uses
  System.Types,
  uTypes;

procedure BulkObtainFiletypes(const Names: TStringDynArray; var FilesData: TFilesData; TmpFilename: string);

implementation

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
  System.IOUtils,
  System.SysUtils;

type
  TStreamHandle = pointer;

///  <summary>
///    Man Page: http://man7.org/linux/man-pages/man3/popen.3.html
///  </summary>
function popen(const command: MarshaledAString; const _type: MarshaledAString): TStreamHandle; cdecl; external libc name _PU + 'popen';

///  <summary>
///    Man Page: http://man7.org/linux/man-pages/man3/pclose.3p.html
///  </summary>
function pclose(filehandle: TStreamHandle): int32; cdecl; external libc name _PU + 'pclose';

///  <summary>
///    Man Page: http://man7.org/linux/man-pages/man3/fgets.3p.html
///  </summary>
function fgets(buffer: pointer; size: int32; Stream: TStreamHAndle): pointer; cdecl; external libc name _PU + 'fgets';

///  <summary>
///    Utility function to return a buffer of ASCII-Z data as a string.
///  </summary>
function BufferToString( Buffer: pointer; MaxSize: uint32 ): string;
var
  cursor: ^uint8;
  EndOfBuffer: nativeuint;
begin
  Result := '';
  if not assigned(Buffer) then begin
    exit;
  end;
  cursor := Buffer;
  EndOfBuffer := NativeUint(cursor) + MaxSize;
  while (NativeUint(cursor)<EndOfBuffer) and (cursor^<>0) do begin
    Result := Result + chr(cursor^);
    cursor := pointer( succ(NativeUInt(cursor)) );
  end;
end;

function GetFileTypes(ListFilename: string): TArray<string>;
var
  Handle: TStreamHandle;
  Data: array[0..511] of uint8;
  Output: string;
begin
  Handle := popen(PAnsiChar('mimetype -d -b -f ' + AnsiString(ListFilename)),'r');
  try
    while fgets(@data[0],Sizeof(Data),Handle)<>nil do begin
      Output := Output + BufferToString(@Data[0],sizeof(Data));
    end;
  finally
    pclose(Handle);
  end;
  Result := Output.Split([sLineBreak]);
  if Result[High(Result)] = '' then
    SetLength(Result, Length(Result) - 1);
end;


(*

{$IFDEF LINUX}
var
  Data: array[0..511] of uint8;
  Handle: TStreamHandle;
  AllDescriptions: string;
{$ENDIF}
{$IFDEF LINUX}
  var AllNames: string;
  for var i := Low(Names) to High(Names) do
    AllNames := AllNames + Names[i] + sLineBreak;

  Rewrite(FTmpFile);
  Write(FTmpFile, AllNames);
  Flush(FTmpFile);

  Handle := popen(PAnsiChar(AnsiString('mimetype -d -b -f ' + FTmpFilename)),'r');
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
    var Descriptions:TArray<string> := AllDescriptions.Split([sLineBreak]);
    if Descriptions[High(Descriptions)] = '' then
      SetLength(Descriptions, Length(Descriptions) - 1);
    Assert(High(Descriptions) = High(Result));
    for var i := Low(Descriptions) to High(Descriptions) do
      Result[i].Filetype := Descriptions[i];
  end;

{$ENDIF}

*)

procedure BulkObtainFiletypes(const Names: TStringDynArray; var FilesData: TFilesData; TmpFilename: string);
var
  Types: TArray<string>;
//  AllNames: string;
//  TmpFile: TextFile;
begin
//  for var i := Low(Names) to High(Names) do
//    AllNames := AllNames + Names[i] + sLineBreak;
  TFile.WriteAllLines(TmpFilename, Names);
  Types := GetFileTypes(TmpFilename);
  Assert(High(FilesData) = High(Types));
  for var i := Low(Types) to High(Types) do
    FilesData[i].Filetype := Types[i];
end;

end.
