unit forms.almstylecalculator;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, scControls, Vcl.ExtCtrls,
  scStyleManager, scStyledForm, scGPControls;

{
  Developer: Ian Barker
           https://about.me/IanBarker
           https://www.codedotshow.com/blog
}

type TActivePanel = record
  SelectedPanel: TPanel;
  OriginalColor: TColor;
end;

type
  TVCLCalculatorForm = class(TForm)
    scStyledForm1: TscStyledForm;
    scStyleManager1: TscStyleManager;
    TopPanel: TscPanel;
    Panel1: TscPanel;
    HistoryLabel: TscLabel;
    Panel2: TscPanel;
    CurrentValueLabel: TscLabel;
    FunctionsPanel: TscPanel;
    ButtonsPanel: TscGPPanel;
    scGPButton1: TscGPButton;
    scGPButton2: TscGPButton;
    scGPButton3: TscGPButton;
    scGPButton4: TscGPButton;
    scGPButton5: TscGPButton;
    scGPButton6: TscGPButton;
    scGPButton7: TscGPButton;
    scGPButton8: TscGPButton;
    scGPButton9: TscGPButton;
    scGPButton10: TscGPButton;
    scGPButton11: TscGPButton;
    scGPButton12: TscGPButton;
    scGPButton13: TscGPButton;
    scGPButton14: TscGPButton;
    scGPButton15: TscGPButton;
    scGPButton16: TscGPButton;
    scGPButton17: TscGPButton;
    scGPButton18: TscGPButton;
    scGPButton19: TscGPButton;
    scGPButton20: TscGPButton;
    scGPButton21: TscGPButton;
    scGPButton22: TscGPButton;
    scGPButton23: TscGPButton;
    scGPButton24: TscGPButton;
    WindowCaptionPanel: TscGPPanel;
    CloseButton: TscGPGlyphButton;
    MinButton: TscGPGlyphButton;
    MaxButton: TscGPGlyphButton;
    scLabel1: TscGPLabel;
    scGPButton25: TscGPButton;
    scGPButton26: TscGPButton;
    scGPButton27: TscGPButton;
    scGPButton28: TscGPButton;
    scGPButton29: TscGPButton;
    BGPanel: TscGPPanel;
    scGPSizeBox1: TscGPSizeBox;
    procedure AppGotFocus(Sender: TObject);
    procedure AppLostFocus(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure MaxButtonClick(Sender: TObject);
    procedure MinButtonClick(Sender: TObject);
    procedure NumberClick(Sender: TObject);
    procedure scGPButton1Click(Sender: TObject);
    procedure scGPButton2Click(Sender: TObject);
    procedure scGPButton3Click(Sender: TObject);
    procedure scGPButton4Click(Sender: TObject);
    procedure scGPButton5Click(Sender: TObject);
    procedure scGPButton6Click(Sender: TObject);
    procedure scGPButton7Click(Sender: TObject);
    procedure scGPButton8Click(Sender: TObject);
    procedure scGPButton12Click(Sender: TObject);
    procedure scGPButton16Click(Sender: TObject);
    procedure scGPButton20Click(Sender: TObject);
    procedure scGPButton21Click(Sender: TObject);
    procedure scGPButton23Click(Sender: TObject);
    procedure scGPButton24Click(Sender: TObject);
    procedure scLabel1MouseDown(Sender: TObject; Button: TMouseButton;      Shift: TShiftState; X, Y: Integer);
    procedure scStyledForm1DWMClientMaximize(Sender: TObject);
    procedure scStyledForm1DWMClientRestore(Sender: TObject);
    procedure scStyledForm1BeforeChangeScale(Sender: TObject);
    procedure scStyledForm1ChangeScale(AScaleFactor: Double);
    procedure scStyledForm1StyleChanged(Sender: TObject);
  private
    FActivePanel: TActivePanel;
    procedure SizeControls;
    procedure UpdateDisplay;
    procedure SetCaptions;
    procedure MatchWindowsTheme;
  end;

var
  VCLCalculatorForm: TVCLCalculatorForm;

implementation

{$R *.dfm}

uses System.StrUtils,
     controllers.calculatorinterface,
     interfaces.icalculatorinterface,
     WindowsDarkMode;


const
  cFunctionButtons = [1..8, 12, 16, 20];
  cNumberButtons   = [9..11, 13..15, 17..19, 21..23];
  cFormStartHeight = 509;
  cFormStartWidth  = 517;


{ TVCLCalculatorForm }

procedure TVCLCalculatorForm.AppGotFocus(Sender: TObject);
begin
  // Make form go semi-transparent
  AlphaBlend         := True;
  BGPanel.FrameColor := clActiveBorder;
end;

procedure TVCLCalculatorForm.AppLostFocus(Sender: TObject);
begin
  // Make form go opaque
  AlphaBlend         := False;
  BGPanel.FrameColor := clInactiveBorder;
end;

procedure TVCLCalculatorForm.CloseButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TVCLCalculatorForm.FormActivate(Sender: TObject);
begin
  if Tag = 0 then
  begin
    Tag := 1;
    SizeControls;
  end;
end;

procedure TVCLCalculatorForm.FormCreate(Sender: TObject);
begin
  MatchWindowsTheme;

  // In keeping with Win UI we need to go opaque when the calculator loses focus..
  Application.OnActivate   := AppGotFocus;
  Application.OnDeActivate := AppLostFocus;

  // We will only allow the calculator to be at least as small as the original design
  Constraints.MinHeight    := Height;
  Constraints.MinWidth     := Width;

  // Start with no panels 'pressed'
  FActivePanel.SelectedPanel := Nil;

  CreateCalculatorController(UpdateDisplay);

  SetCaptions;

  UpdateDisplay;
end;

procedure TVCLCalculatorForm.FormDeactivate(Sender: TObject);
begin
  AppLostFocus(Self);
end;

procedure TVCLCalculatorForm.FormResize(Sender: TObject);
begin
  SizeControls;
end;

procedure TVCLCalculatorForm.MatchWindowsTheme;
var
  GoDark:  Boolean;
  iInt:    Integer;
  AButton: TComponent;
begin
  SetAppropriateThemeMode('Tablet Dark', 'Windows10');
  GoDark := DarkModeIsEnabled;

  // We have to do this due to the Carbon theme not quite matching the default Windows Dark theme
  for iInt in cNumberButtons do
  begin
    AButton := FindComponent('scGPButton' + IntToStr(iInt));
    if (AButton <> Nil) then
      if (AButton is TscGPButton) then
        if GoDark then
          TscGPButton(AButton).Options.NormalColor := clBackground
        else
          TscGPButton(AButton).Options.NormalColor := clWindow;
  end;
end;

procedure TVCLCalculatorForm.MaxButtonClick(Sender: TObject);
begin
  if scStyledForm1.IsDWMClientMaximized then
    scStyledForm1.DWMClientRestore
  else
    scStyledForm1.DWMClientMaximize;
end;

procedure TVCLCalculatorForm.MinButtonClick(Sender: TObject);
begin
  Application.Minimize;
end;

procedure TVCLCalculatorForm.NumberClick(Sender: TObject);
var
  sStr: string;
begin
  sStr := (Sender as TscGPButton).Caption;
  if sStr.Length > 0 then
    FCalculatorController.NumberPressed(sStr.Chars[0]);
end;

procedure TVCLCalculatorForm.scGPButton12Click(Sender: TObject);
begin
  FCalculatorController.OperatorPressed(Multiply);
end;

procedure TVCLCalculatorForm.scGPButton16Click(Sender: TObject);
begin
  FCalculatorController.OperatorPressed(Subtract);
end;

procedure TVCLCalculatorForm.scGPButton1Click(Sender: TObject);
begin
  FCalculatorController.OperatorPressed(Percent);
end;

procedure TVCLCalculatorForm.scGPButton20Click(Sender: TObject);
begin
  FCalculatorController.OperatorPressed(Add);
end;

procedure TVCLCalculatorForm.scGPButton21Click(Sender: TObject);
begin
  FCalculatorController.ChangeSign;
end;

procedure TVCLCalculatorForm.scGPButton23Click(Sender: TObject);
begin
  FCalculatorController.DecimalPointPressed;
end;

procedure TVCLCalculatorForm.scGPButton24Click(Sender: TObject);
begin
  FCalculatorController.EqualsPressed;
end;

procedure TVCLCalculatorForm.scGPButton2Click(Sender: TObject);
begin
  FCalculatorController.ClearPressed;
end;

procedure TVCLCalculatorForm.scGPButton3Click(Sender: TObject);
begin
  FCalculatorController.ClearPressed;
end;

procedure TVCLCalculatorForm.scGPButton4Click(Sender: TObject);
begin
  FCalculatorController.BackSpacePressed;
end;

procedure TVCLCalculatorForm.scGPButton5Click(Sender: TObject);
begin
  FCalculatorController.OperatorPressed(OneOverX);
end;

procedure TVCLCalculatorForm.scGPButton6Click(Sender: TObject);
begin
  FCalculatorController.OperatorPressed(XSquared);
end;

procedure TVCLCalculatorForm.scGPButton7Click(Sender: TObject);
begin
  FCalculatorController.OperatorPressed(SquareRootX);
end;

procedure TVCLCalculatorForm.scGPButton8Click(Sender: TObject);
begin
  FCalculatorController.OperatorPressed(Divide);
end;

procedure TVCLCalculatorForm.scLabel1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
 if (Button = mbLeft) and not (ssDouble in Shift) and scStyledForm1.IsDWMClientMaximized then
   scStyledForm1.DWMClientStartDrag;
end;

procedure TVCLCalculatorForm.scStyledForm1BeforeChangeScale(Sender: TObject);
begin
  // avoid Delphi bug with Constrains when DPI changed
  VCLCalculatorForm.Constraints.MinWidth := 0;
  VCLCalculatorForm.Constraints.MinHeight := 0;
end;

procedure TVCLCalculatorForm.scStyledForm1ChangeScale(AScaleFactor: Double);
begin
  // avoid Delphi bug with Constrains when DPI changed
  VCLCalculatorForm.Constraints.MinWidth  := scStyledForm1.ScaleInt(cFormStartHeight);
  VCLCalculatorForm.Constraints.MinHeight := scStyledForm1.ScaleInt(cFormStartWidth);
end;

procedure TVCLCalculatorForm.scStyledForm1DWMClientMaximize(Sender: TObject);
begin
  MaxButton.GlyphOptions.Kind := scgpbgkRestore;
//  scGPSizeBox1.Visible := False;
  BGPanel.Sizeable := False;
end;

procedure TVCLCalculatorForm.scStyledForm1DWMClientRestore(Sender: TObject);
begin
  MaxButton.GlyphOptions.Kind := scgpbgkMaximize;
//  scGPSizeBox1.Visible := True;
  BGPanel.Sizeable := True;
end;

procedure TVCLCalculatorForm.scStyledForm1StyleChanged(Sender: TObject);
begin
  MatchWindowsTheme;
end;

procedure TVCLCalculatorForm.SetCaptions;
begin
  scGPButton1.Caption     := '%';
  scGPButton1.Font.Name   := 'Segoe UI Symbol';
  scGPButton2.Caption     := 'CE';
  scGPButton3.Caption     := 'C';
  scGPButton4.Caption     := #9003;
  scGPButton4.Font.Name   := 'Segoe UI Symbol';
  scGPButton5.Caption     := #185'/'#8339;
  scGPButton4.Font.Name   := 'Segoe UI Symbol';
  scGPButton6.Caption     := #8339#178;
  scGPButton6.Font.Name   := 'Segoe UI Symbol';
  scGPButton7.Caption     := #178#8730#8339;
  scGPButton7.Font.Name   := 'Segoe UI Symbol';
  scGPButton8.Caption     := #247;
  scGPButton8.Font.Name   := 'Segoe UI Symbol';
  scGPButton9.Caption     := '7';
  scGPButton10.Caption    := '8';
  scGPButton11.Caption    := '9';
  scGPButton12.Caption    := #9587;
  scGPButton12.Font.Name := 'Segoe UI Symbol';
  scGPButton13.Caption    := '4';
  scGPButton14.Caption    := '5';
  scGPButton15.Caption    := '6';
  scGPButton16.Caption    := #8722;
  scGPButton20.Caption    := '+';
  scGPButton19.Caption    := '3';
  scGPButton18.Caption    := '2';
  scGPButton17.Caption    := '1';
  scGPButton21.Caption    := #8314'/'#8331;
  scGPButton21.Font.Name  := 'Segoe UI';
  scGPButton22.Caption    := '0';
  scGPButton23.Caption    := '.';
  scGPButton24.Caption    := '=';
  scGPButton24.Font.Name  := 'Segoe UI Symbol';
end;

procedure TVCLCalculatorForm.SizeControls;
var
  iIdx, iGap, iHeight, iWidth, iCol, iRow: integer;
  CMP:                               TComponent;
const
  cCols   = 4;
  cRows   = 5;
  cBorder = 0;
begin
  // In the actual Windows app the top panel grabs a proportionate chunk
  // of the screen real-estate
  TopPanel.Height := BGPanel.ClientHeight div 6;
  // We fit our buttons into what's left over
  iWidth          := ButtonsPanel.ClientWidth  div cCols;
  iHeight         := ButtonsPanel.ClientHeight div Succ(cRows);
  iGap            := ButtonsPanel.ClientWidth - (iWidth * cCols);
  for iCol := 1 to cCols do
    for iRow := 0 to cRows do
    begin
      iIdx := (iRow * cCols) + iCol;
      CMP := FindComponent('scGPButton' + IntToStr(iIdx));
      if (CMP <> Nil) then
        if (CMP is TscGPButton) then
        begin
          TscGPButton(CMP).Left    := iGap + ((iWidth + cBorder) * Pred(iCol));
          TscGPButton(CMP).Top     := iRow * iHeight;
          TscGPButton(CMP).Width   := iWidth - cBorder;
          TscGPButton(CMP).Height  := iHeight - cBorder;
          TscGPButton(CMP).Options.HotColor := clBtnHighlight;
          TscGPButton(CMP).Options.HotColor2 := clBtnHighlight;

          // To make dereferencing which 'button' is pressed a little easier
          TscGPButton(CMP).Tag     := iIdx;
        end;
    end;
  scGPButton24.Options.HotColor  := clHotLight;
  scGPButton24.Options.HotColor2 := clHotLight;
end;

procedure TVCLCalculatorForm.UpdateDisplay;
begin
  HistoryLabel.Caption      := FCalculatorController.History;
  CurrentValueLabel.Caption := FCalculatorController.CurrentTotal;
end;

end.
