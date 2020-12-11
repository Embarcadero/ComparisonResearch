unit uTypes;

interface

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
