unit Calculator.Forms.Transparent;

interface

uses
  System.Classes, System.SysUtils, System.Types, System.UITypes,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Controls.Presentation, FMX.StdCtrls;

type

  /// Abstract class that makes descendant form instances transparent. Idea based on
  /// an interposer class, as suggested by
  /// https://stackoverflow.com/users/91299/rruz
  /// Mentioned at
  /// https://stackoverflow.com/questions/20699032/alphablend-in-firemonkey
  TTransparentForm = class abstract(FMX.Forms.TForm)
  private
    FAlphaBlend: Boolean;
    FAlphaBlendValue: Byte;
    FTransparentColor: Boolean;
    FTransparentColorValue: TColor;
    procedure SetAlphaBlend(const Value: Boolean);
    procedure SetAlphaBlendValue(const Value: Byte);
    procedure SetLayeredAttribs;
    procedure SetTransparentColor(const Value: Boolean);
    procedure SetTransparentColorValue(const Value: TColor);
  protected
    property AlphaBlend: Boolean read FAlphaBlend write SetAlphaBlend default False;
    property AlphaBlendValue: Byte read FAlphaBlendValue write SetAlphaBlendValue default 255;
    property TransparentColor: Boolean read FTransparentColor write SetTransparentColor default False;
    property TransparentColorValue: TColor read FTransparentColorValue write SetTransparentColorValue;
  public
    Constructor Create(AOwner: TComponent); override;
  end;

implementation

uses
  FMX.Platform.Win,
  Winapi.Windows,
  Vcl.Graphics;

type
  TSetLayeredWindowAttributes = function(Hwnd: THandle; crKey: COLORREF;
    bAlpha: Byte; dwFlags: DWORD): Boolean; stdcall;

var
  SetLayeredWindowAttributes: TSetLayeredWindowAttributes = nil;

  { TTransparentForm }
constructor TTransparentForm.Create(AOwner: TComponent);
begin
  inherited;
  SetLayeredWindowAttributes := GetProcAddress(GetModuleHandle(User32), 'SetLayeredWindowAttributes');
  FAlphaBlend := True;
  FAlphaBlendValue := 200;
  SetLayeredAttribs;
end;

procedure TTransparentForm.SetAlphaBlend(const Value: Boolean);
begin
  if FAlphaBlend <> Value then
  begin
    FAlphaBlend := Value;
    SetLayeredAttribs;
  end;
end;

procedure TTransparentForm.SetAlphaBlendValue(const Value: Byte);
begin
  if FAlphaBlendValue <> Value then
  begin
    FAlphaBlendValue := Value;
    SetLayeredAttribs;
  end;
end;

procedure TTransparentForm.SetTransparentColor(const Value: Boolean);
begin
  if FTransparentColor <> Value then
  begin
    FTransparentColor := Value;
    SetLayeredAttribs;
  end;
end;

procedure TTransparentForm.SetTransparentColorValue(const Value: TColor);
begin
  if FTransparentColorValue <> Value then
  begin
    FTransparentColorValue := Value;
    SetLayeredAttribs;
  end;
end;

procedure TTransparentForm.SetLayeredAttribs;
const
  cUseAlpha: array [Boolean] of Integer = (0, LWA_ALPHA);
  cUseColorKey: array [Boolean] of Integer = (0, LWA_COLORKEY);
var
  AStyle: Integer;
begin
  if not(csDesigning in ComponentState) and
    (Assigned(SetLayeredWindowAttributes)) then
  begin

    AStyle := GetWindowLong(WindowHandleToPlatform(Handle).Wnd, GWL_EXSTYLE);
    if FAlphaBlend or FTransparentColor then
    begin
      if (AStyle and WS_EX_LAYERED) = 0 then
        SetWindowLong(WindowHandleToPlatform(Handle).Wnd, GWL_EXSTYLE, AStyle or WS_EX_LAYERED);
      SetLayeredWindowAttributes(WindowHandleToPlatform(Handle).Wnd, ColorToRGB(FTransparentColorValue),
        FAlphaBlendValue,
        cUseAlpha[FAlphaBlend] or cUseColorKey[FTransparentColor]);
    end
    else
    begin
      SetWindowLong(WindowHandleToPlatform(Handle).Wnd, GWL_EXSTYLE, AStyle and not WS_EX_LAYERED);
      RedrawWindow(WindowHandleToPlatform(Handle).Wnd, nil, 0, RDW_ERASE or RDW_INVALIDATE or RDW_FRAME or
        RDW_ALLCHILDREN);
    end;
  end;
end;

end.
