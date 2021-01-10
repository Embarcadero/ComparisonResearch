unit uScreenshotHistory;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.UI.Intf,
  FireDAC.Comp.ScriptCommands, FireDAC.Stan.Util, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.VCLUI.Wait, FireDAC.Phys.SQLiteWrapper.Stat,
  Data.DB, FireDAC.Comp.Client, FireDAC.Comp.Script, FireDAC.Comp.DataSet,
  Math, System.UITypes, JPEG,
  Vcl.Menus, Vcl.ComCtrls, Vcl.WinXCtrls, Vcl.ExtDlgs;

type
  TUpdateType = (utInsert, utDelete, utUpdate);

  TMainForm = class(TForm)
    ScrollBox1: TScrollBox;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    Panel1: TPanel;
    btCrop: TButton;
    btCapture: TButton;
    UpdateQuery: TFDQuery;
    Query: TFDQuery;
    Script: TFDScript;
    Connection: TFDConnection;
    FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink;
    FP: TFlowpanel;
    ScrollBox2: TScrollBox;
    MainImage: TImage;
    PopupMenu: TPopupMenu;
    Delete1: TMenuItem;
    SplitView: TSplitView;
    btResize: TButton;
    btSave: TButton;
    TrackBar: TTrackBar;
    Label1: TLabel;
    lbZoomValue: TLabel;
    SavePictureDialog: TSavePictureDialog;
    procedure FormCreate(Sender: TObject);
    procedure FPResize(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btCaptureClick(Sender: TObject);
    procedure MainImageMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MainImageMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MainImageMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure btCropClick(Sender: TObject);
    procedure Delete1Click(Sender: TObject);
    procedure TrackBarChange(Sender: TObject);
    procedure btResizeClick(Sender: TObject);
    procedure SplitViewResize(Sender: TObject);
    procedure btSaveClick(Sender: TObject);
  private
    { Private declarations }
    procedure ResizeBitmap;
    procedure ImageOnClick(Sender: TObject);
    function IsEmptyPicture: boolean;
    procedure UpdateTable(UpdateType: TUpdateType; ID: integer = -1);
    procedure SetScrollBarRange; overload;
    procedure SetScrollBarRange(Image: TImage); overload;
    procedure DrawImage(IsInsert: boolean = False);
    procedure DrawImages;
    procedure DrawRect;
  public
    { Public declarations }
  end;

const
  SQLInsert = 'INSERT INTO SCREENSHOTTABLE (DATE, SCREENSHOT) VALUES (:DATE, :SCREENSHOT)';
  SQLDelete= 'DELETE FROM SCREENSHOTTABLE WHERE ID = :ID';
  SQLUpdate = 'UPDATE SCREENSHOTTABLE SET SCREENSHOT = :SCREENSHOT WHERE ID = :ID';


var
  MainForm: TMainForm;
  SourceJpg, TmpJpg: TJPEGImage;
  IsMouseDown, IsCropping: boolean;
  X0, Y0, X1, Y1, H, W:integer;
  Scale: Single;

implementation

{$R *.dfm}
procedure CropBitmap(InBitmap, OutBitMap : TBitmap; X, Y, W, H :Integer);
begin
  OutBitMap.PixelFormat := InBitmap.PixelFormat;
  OutBitMap.Width  := W;
  OutBitMap.Height := H;
  BitBlt(OutBitMap.Canvas.Handle, 0, 0, W, H, InBitmap.Canvas.Handle, x, y, SRCCOPY);
end;

function GetScreenShot: TGraphic;
var
  DC: HDC;
  Bmp: TBitmap;
begin
  Bmp := TBitmap.Create;
  try
    DC:=GetDC(GetDesktopWindow);
    try
      Bmp.Width:=GetDeviceCaps(DC, HORZRES);
      Bmp.Height:=GetDeviceCaps(DC, VERTRES);
      BitBlt(Bmp.Canvas.Handle, 0, 0, Bmp.Width, Bmp.Height, DC, 0, 0, SRCCOPY);
      Result := Bmp;
    finally
      ReleaseDC(GetDesktopWindow, DC);
    end;
  except
    Bmp.Free;
    raise;
  end;
end;

procedure LoadBitmapFromBlob(Bitmap: TJPEGImage; Blob: TBlobField);
var
  MS: TMemoryStream;
begin
  MS := TMemoryStream.Create;
  try
    Blob.SaveToStream(ms);
    MS.Position := 0;
    Bitmap.LoadFromStream(MS);
  finally
    MS.Free;
  end;
end;

procedure TMainForm.ResizeBitmap;
var
  Bmp: TBitmap;
  Rect: TRect;
begin
  Bmp:= TBitmap.Create;
  try
    Rect.Top := 0;
    Rect.Left := 0;
    if Scale > 0 then begin
      Rect.Right := Round(SourceJpg.Width * Scale);
      Rect.Bottom := Round(SourceJpg.Height * Scale);
    end
    else begin
      Rect.Right := Round(SourceJpg.Width / Abs(Scale));
      Rect.Bottom := Round(SourceJpg.Height / Abs(Scale));
    end;
    Bmp.SetSize(Rect.Right, Rect.Bottom);
    SetStretchBltMode(Bmp.Canvas.Handle, HALFTONE);
    Bmp.Canvas.StretchDraw(Rect, SourceJpg);
    TmpJpg.Assign(Bmp);
    MainImage.Picture.Assign(TmpJpg);
    SetScrollBarRange(MainImage);
  finally
    Bmp.Free;
  end;
end;

procedure TMainForm.ImageOnClick(Sender: TObject);
var
  TempImage: TImage;
begin
  TempImage := Sender as TImage;
  MainImage.Picture.Assign(TempImage.Picture);
  MainImage.Tag := TFlowPanel(TempImage.Parent).GetControlIndex(Sender as TImage);
  SetScrollBarRange(TempImage);
  if IsCropping then begin
    btCrop.Caption := 'Crop';
    IsCropping := False;
  end;
end;

function TMainForm.IsEmptyPicture: boolean;
begin
  Result := MainImage.Picture.Graphic = nil;
end;

procedure TMainForm.UpdateTable(UpdateType: TUpdateType; ID: integer = -1);
var
  MS: TMemoryStream;
begin
  case UpdateType of
    utInsert, utUpdate:
      if MainImage.Picture.Graphic <> nil then begin
        if UpdateType = utInsert then begin
          DrawImage(True);
          Application.ProcessMessages;
          MainForm.ImageOnClick(TImage(FP.Controls[FP.ControlCount - 1]));
          SetScrollBarRange;
          UpdateQuery.SQL.Text := SQLInsert;
          UpdateQuery.ParamByName('DATE').AsDate := Date;
        end
        else begin
          UpdateQuery.SQL.Text := SQLUpdate;
          UpdateQuery.ParamByName('ID').AsInteger := TImage(FP.Controls[MainImage.Tag]).Tag;;
        end;
        UpdateQuery.ParamByName('SCREENSHOT').DataType := ftBlob;
        MS := TMemoryStream.Create;
        try
          MainImage.Picture.Graphic.SaveToStream(MS);
          UpdateQuery.ParamByName('SCREENSHOT').AsStream := MS;
          UpdateQuery.ExecSQL;
          if UpdateType = utUpdate then begin
            TImage(FP.Controls[MainImage.Tag]).Picture.Assign(MainImage.Picture);
        end;
        finally
          Query.Refresh;
          Query.Last;
          if UpdateType = utInsert then
            TImage(FP.Controls[FP.ControlCount - 1]).Tag := Query.FieldByName('ID').AsInteger;
        end;
      end;
    utDelete:
      begin
        UpdateQuery.SQL.Text := SQLDelete;
        UpdateQuery.ParamByName('ID').AsInteger := ID;
        UpdateQuery.ExecSQL;
        Query.Refresh;
        SetScrollBarRange;
        MainImage.Picture := nil;
      end;
  end;
end;

procedure TMainForm.SetScrollBarRange;
var
 i, H: integer;
begin
  H := 0;
  for i := 0 to FP.ControlCount - 1 do
    H := Max(FP.Controls[i].BoundsRect.Bottom, H);
  ScrollBox1.VertScrollBar.Range := H;
  ScrollBox1.VertScrollBar.Position := ScrollBox1.VertScrollBar.Range - ScrollBox1.ClientHeight;
end;

procedure TMainForm.SetScrollBarRange(Image: TImage);
begin
  ScrollBox2.VertScrollBar.Range := Image.Picture.Height;
  ScrollBox2.HorzScrollBar.Range := Image.Picture.Width;
end;

procedure TMainForm.DrawImage(IsInsert: boolean = False);
var
  Pic: TJPEGImage;
  Image: TImage;
begin
    Pic := TJPEGImage.Create;
    try
      Image := TImage.Create(self);
      Image.Parent := FP;
      Image.AutoSize := False;
      Image.Width := 337;
      Image.Height := 225;
      Image.AlignWithMargins := True;
      Image.Proportional := True;
      Image.Stretch := True;
      if IsInsert then
        Image.Picture.Assign(MainImage.Picture)
      else begin
        LoadBitmapFromBlob(Pic, TBlobField(Query.FieldByName('screenshot')));
        Image.Picture.Assign(Pic);
        Image.Tag := Query.FieldByName('ID').AsInteger;
      end;

      Image.OnClick := ImageOnClick;
      Image.PopupMenu := PopupMenu;
    finally
      Pic.Free;
    end;
end;

procedure TMainForm.DrawImages;
begin
  if Query.RecordCount > 0 then
    repeat
      DrawImage;
      Query.Next;
    until Query.Eof;
end;

procedure TMainForm.DrawRect;
var
  Bmp: TBitmap;
begin
  bmp:= TBitmap.Create;
  try
    Bmp.Assign(SourceJpg);
    Bmp.Canvas.Brush.Style := bsClear;
    Bmp.Canvas.Pen.Width := 1;
    Bmp.Canvas.Pen.Color := clblack;
    Bmp.Canvas.Pen.Style := psDash;
    Bmp.Canvas.Rectangle(X0, Y0, X1, Y1);
    MainImage.Picture.Bitmap.Assign(Bmp);
  finally
    Bmp.Free;
  end;
end;

procedure TMainForm.MainImageMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if IsEmptyPicture or not IsCropping then begin
    IsMouseDown := False;
    Exit;
  end;

  IsMouseDown := True;
  if IsMouseDown then begin
    X0 := X;
    Y0 := Y;
  end;
end;

procedure TMainForm.MainImageMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if IsMouseDown then begin
    X1 := X;
    Y1 := Y;
    DrawRect;
  end;
end;

procedure TMainForm.MainImageMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  IsMouseDown := False;
end;

procedure TMainForm.btCropClick(Sender: TObject);
var
  Bmp: TBitmap;
begin
  if IsEmptyPicture then
    Exit;

  if not IsCropping then begin
    btCrop.Caption := 'Crop It';
    SourceJpg.Assign(MainImage.Picture.Graphic);
    IsCropping := True;
  end
  else begin
    btCrop.Caption := 'Crop';
    IsCropping := False;

    H := Abs(X1 - X0);
    W := Abs(Y1 - Y0);
    if (H = 0) or (W = 0) then
      Exit;

    if X1 < X0 then
      X0 := X1;
    if Y1 < Y0 then
      Y0 := Y1;

    Bmp := TBitmap.Create;
    try
      CropBitmap(MainImage.Picture.Bitmap, Bmp, X0 + 1, Y0 + 1, H - 2 , W - 2);
      TmpJpg.Assign(Bmp);
      MainImage.Picture.Assign(TmpJpg);
      SetScrollBarRange(MainImage);
      UpdateTable(utUpdate);
    finally
      Bmp.Free;
    end;
  end;
end;

procedure TMainForm.btCaptureClick(Sender: TObject);
var
  Desktop: TGraphic;
begin
    Desktop := nil;
    try
      Self.Hide;
      try
        Desktop := GetScreenShot;
      finally
        Self.Show;
      end;
      TmpJpg.Assign(Desktop);
      MainImage.Picture.Assign(TmpJpg);
      SetScrollBarRange(MainImage);
      UpdateTable(utInsert);
    finally
      Desktop.Free;
    end;
end;

procedure TMainForm.btResizeClick(Sender: TObject);
begin
    if IsEmptyPicture then
    Exit;

  if btResize.Caption = 'Resize' then begin
    SplitView.Open;
    btResize.Caption := 'Resize It';
  end
  else begin
    SplitView.Close;
    if Scale <> 0  then begin
      SourceJpg.Assign(MainImage.Picture.Graphic);
      ResizeBitmap;
      SetScrollBarRange(MainImage);
    end;
    btResize.Caption := 'Resize';
  end;
end;

procedure TMainForm.btSaveClick(Sender: TObject);
begin
  if IsEmptyPicture then
    Exit;

  SavePictureDialog.DefaultExt := GraphicExtension(TJPEGImage);
  SavePictureDialog.FileName:='';
  if SavePictureDialog.Execute then begin
    MainImage.Picture.Graphic.SaveToFile(SavePictureDialog.FileName);
  end;

end;

procedure TMainForm.SplitViewResize(Sender: TObject);
begin
  SplitView.Height := MainImage.Height;
end;

procedure TMainForm.TrackBarChange(Sender: TObject);
begin
  Scale :=  Math.RoundTo(TrackBar.Position/100, -1);
  if (Scale >= 0) then
    Scale := TrackBar.Position/100 + 1
  else
    Scale := TrackBar.Position/100 - 1;
  Scale := Math.RoundTo(Scale, -1);
  lbZoomValue.Caption := FloatToStrF(Scale, ffFixed, 1, 1) + 'X';
end;

procedure TMainForm.Delete1Click(Sender: TObject);
var
  ParentMenu: TMenu ;
  Component: TComponent ;
  Image: TImage;
begin
  ParentMenu := TMenuItem(Sender).GetParentMenu ;
  Component := TPopupMenu(ParentMenu).PopupComponent ;
  Image := TImage(Component);
  (Image.Parent as TFlowPanel).RemoveControl(Image);
  UpdateTable(utDelete, Image.Tag);
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  SourceJpg := TJPEGImage.Create;
  TmpJpg := TJPEGImage.Create;
  Connection.Params.Values['Database'] := ExtractFilePath(ParamStr(0)) + 'ScreenShot.db';
  try
    Query.Open;
  except
    on E: Exception do
      if Pos('no such table', E.Message) > 0 then
        Script.ExecuteAll;
  end;
  Query.Open;
  DrawImages;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  SourceJpg.Free;
  TmpJpg.Free;
end;

procedure TMainForm.FPResize(Sender: TObject);
begin
  SetScrollBarRange;
end;

end.
