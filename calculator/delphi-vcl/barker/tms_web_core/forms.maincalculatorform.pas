unit forms.maincalculatorform;

interface

uses
  System.SysUtils, System.Classes, JS, Web, WEBLib.Graphics, WEBLib.Controls,
  WEBLib.Forms, WEBLib.Dialogs, Vcl.Controls, Vcl.StdCtrls,
  WEBLib.StdCtrls, WEBLib.ExtCtrls;


{
  Developer: Ian Barker
           https://about.me/IanBarker
           https://www.codedotshow.com/blog
}


type TActivePanel = record
  SelectedPanel: TWebPanel;
  OriginalColor: TColor;
end;

type
  TForm1 = class(TWebForm)
    BGPanel: TWebPanel;
    CaptionPanel: TWebPanel;
    TopPanel: TWebPanel;
    Panel1: TWebPanel;
    HistoryLabel: TWebLabel;
    FunctionsPanel: TWebPanel;
    CurrentValueLabel: TWebLabel;
    WebPanel1: TWebPanel;
    WebPanel2: TWebPanel;
    WebPanel3: TWebPanel;
    WebPanel4: TWebPanel;
    WebPanel5: TWebPanel;
    WebPanel6: TWebPanel;
    WebPanel7: TWebPanel;
    WebPanel8: TWebPanel;
    WebPanel9: TWebPanel;
    WebPanel10: TWebPanel;
    WebPanel11: TWebPanel;
    WebPanel12: TWebPanel;
    WebPanel13: TWebPanel;
    WebPanel14: TWebPanel;
    WebPanel15: TWebPanel;
    WebPanel16: TWebPanel;
    WebPanel17: TWebPanel;
    WebPanel18: TWebPanel;
    WebPanel19: TWebPanel;
    WebPanel20: TWebPanel;
    WebPanel21: TWebPanel;
    WebPanel22: TWebPanel;
    WebPanel23: TWebPanel;
    WebPanel24: TWebPanel;
    WebLabel1: TWebLabel;
    WebPanel25: TWebPanel;
    WebPanel26: TWebPanel;
    WebPanel27: TWebPanel;
    WebPanel28: TWebPanel;
    WebPanel29: TWebPanel;
    WebTimer1: TWebTimer;
    ButtonsPanel: TWebPanel;
    WebPanel30: TWebPanel;

    procedure PanelClick(Sender: TObject);
    procedure NumberClick(Sender: TObject);

    procedure WebTimer1Timer(Sender: TObject);
    procedure WebFormCreate(Sender: TObject);
    procedure WebFormKeyPress(Sender: TObject; var Key: Char);
    procedure WebFormResize(Sender: TObject);
    procedure WebPanel24Click(Sender: TObject);
    procedure WebPanel1Click(Sender: TObject);
    procedure WebPanel2Click(Sender: TObject);
    procedure WebPanel4Click(Sender: TObject);
    procedure WebPanel3Click(Sender: TObject);
    procedure WebPanel8Click(Sender: TObject);
    procedure WebPanel12Click(Sender: TObject);
    procedure WebPanel16Click(Sender: TObject);
    procedure WebPanel20Click(Sender: TObject);
    procedure WebPanel21Click(Sender: TObject);
    procedure WebPanel23Click(Sender: TObject);
    procedure WebFormShow(Sender: TObject);
    procedure WebPanel30Click(Sender: TObject);
    procedure WebPanel30MouseEnter(Sender: TObject);
    procedure WebPanel30MouseLeave(Sender: TObject);
  private
    FActivePanel: TActivePanel;
    procedure SizeControls;
    procedure HighlightKeypress(TheControl: TWebPanel);
    procedure Unpress;
    procedure UpdateDisplay;
    procedure SetCaptions;
  end;

var
  Form1: TForm1;

implementation
uses System.StrUtils,
     controllers.calculatorinterface,
     interfaces.icalculatorinterface;

{$R *.dfm}


const
  cFunctionButtons = [1..8, 12, 16, 20];
  cNumberButtons   = [9..11, 13..15, 17..19, 21..23];


{ TForm1 }

procedure TForm1.HighlightKeypress(TheControl: TWebPanel);
const
  cFunctionFlashColor = $00DBDBDB;
  cRegularFlashColor  = $00E6E6E6;
  cEqualsFlashColor   = $00DBC8B0;
begin
  WebTimer1.Enabled := False;
  Unpress;
  FActivePanel.SelectedPanel := TheControl;
  FActivePanel.OriginalColor := TheControl.Color;
  if FActivePanel.SelectedPanel.Tag in cNumberButtons then
    FActivePanel.SelectedPanel.Color := cRegularFlashColor
  else
    if FActivePanel.SelectedPanel.Tag in cFunctionButtons then
      FActivePanel.SelectedPanel.Color := cFunctionFlashColor
    else
      FActivePanel.SelectedPanel.Color := cEqualsFlashColor;
  WebTimer1.Enabled := True;
end;

procedure TForm1.NumberClick(Sender: TObject);
var
  sStr: string;
begin
  PanelClick(Sender);
  sStr := (Sender as TWebPanel).Caption;
  if sStr.Length > 0 then
    FCalculatorController.NumberPressed(sStr.Chars[0]);
end;

procedure TForm1.PanelClick(Sender: TObject);
begin
  HighlightKeypress(TWebPanel(Sender));
end;

procedure TForm1.SetCaptions;
begin
    WebPanel6.Caption     := #8339#178;
    WebPanel21.Caption    := #8314 + '/' + #8331;
end;

procedure TForm1.SizeControls;
var
  iIdx, iGap, iHeight, iWidth, iCol, iRow: integer;
  CMP:                               TComponent;
const
  cCols   = 4;
  cRows   = 5;
  cBorder = 1;
begin
  // In the actual Windows app the top panel grabs a proportionate chunk
  // of the screen real-estate
  TopPanel.Height := ClientHeight div 6;

  // We fit our buttons into what's left over
  iWidth          := ButtonsPanel.Width  div cCols;
  iHeight         := ButtonsPanel.Height div Succ(cRows);
  iGap            := ButtonsPanel.Width - (iWidth * cCols);
  for iCol := 1 to cCols do
    for iRow := 0 to cRows do
    begin
      iIdx := (iRow * cCols) + iCol;
      CMP := FindComponent('WebPanel' + IntToStr(iIdx));
      if (CMP <> Nil) then
        if (CMP is TWebPanel) then
        begin
          TWebPanel(CMP).Left    := iGap + ((iWidth + cBorder) * Pred(iCol));
          TWebPanel(CMP).Top     := iRow * iHeight;
          TWebPanel(CMP).Width   := iWidth - cBorder;
          TWebPanel(CMP).Height  := iHeight - cBorder;

          // To make dereferencing which 'button' is pressed a little easier
          TWebPanel(CMP).Tag     := iIdx;
        end;
    end;end;

procedure TForm1.Unpress;
begin
  if FActivePanel.SelectedPanel <> Nil then
  begin
    FActivePanel.SelectedPanel.Color := FActivePanel.OriginalColor;
  end;
end;

procedure TForm1.UpdateDisplay;
begin
  HistoryLabel.Caption      := FCalculatorController.History;
  CurrentValueLabel.Caption := FCalculatorController.CurrentTotal;
end;

procedure TForm1.WebFormCreate(Sender: TObject);
begin
  // Start with no panels 'pressed'
  FActivePanel.SelectedPanel := Nil;

  CreateCalculatorController(@UpdateDisplay);

  SetCaptions;

  UpdateDisplay;

end;

procedure TForm1.WebFormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = FormatSettings.DecimalSeparator then
    FCalculatorController.DecimalPointPressed
  else
    case Key of
      '=', #13:      FCalculatorController.EqualsPressed;  // Enter is the same as equals
      'c', 'C':      FCalculatorController.ClearPressed;  // Clear entry
      '+':           FCalculatorController.OperatorPressed(Add);
      '-':           FCalculatorController.OperatorPressed(Subtract);
      '*', 'x', 'X': FCalculatorController.OperatorPressed(Multiply);
      '/', '\':      FCalculatorController.OperatorPressed(Divide);
      #8:            FCalculatorController.BackSpacePressed;
      '0'..'9':      FCalculatorController.NumberPressed(Key);
    end;
end;

procedure TForm1.WebFormResize(Sender: TObject);
begin
  SizeControls;
end;

procedure TForm1.WebFormShow(Sender: TObject);
begin
  SizeControls;
end;

procedure TForm1.WebPanel12Click(Sender: TObject);
begin
  PanelClick(Sender);
  FCalculatorController.OperatorPressed(Multiply);
end;

procedure TForm1.WebPanel16Click(Sender: TObject);
begin
  PanelClick(Sender);
  FCalculatorController.OperatorPressed(Subtract);
end;

procedure TForm1.WebPanel1Click(Sender: TObject);
begin
  PanelClick(Sender);
  FCalculatorController.OperatorPressed(Percent);
end;

procedure TForm1.WebPanel20Click(Sender: TObject);
begin
  PanelClick(Sender);
  FCalculatorController.OperatorPressed(Add);
end;

procedure TForm1.WebPanel21Click(Sender: TObject);
begin
  PanelClick(Sender);
  FCalculatorController.ChangeSign;
end;

procedure TForm1.WebPanel23Click(Sender: TObject);
begin
  PanelClick(Sender);
  FCalculatorController.DecimalPointPressed;
end;

procedure TForm1.WebPanel24Click(Sender: TObject);
begin
  PanelClick(Sender);
  FCalculatorController.EqualsPressed;
end;

procedure TForm1.WebPanel2Click(Sender: TObject);
begin
  PanelClick(Sender);
  FCalculatorController.ClearPressed;
end;

procedure TForm1.WebPanel30Click(Sender: TObject);
begin
  Application.Navigate('https://about.me/IanBarker', TNavigationTarget.ntPage);
end;

procedure TForm1.WebPanel30MouseEnter(Sender: TObject);
begin
  WebPanel30.Color := $000000C4;
end;

procedure TForm1.WebPanel30MouseLeave(Sender: TObject);
begin
  WebPanel30.Color := CaptionPanel.Color;
end;

procedure TForm1.WebPanel3Click(Sender: TObject);
begin
  PanelClick(Sender);
  FCalculatorController.ClearPressed;
end;

procedure TForm1.WebPanel4Click(Sender: TObject);
begin
  PanelClick(Sender);
  FCalculatorController.BackSpacePressed;
end;

procedure TForm1.WebPanel8Click(Sender: TObject);
begin
  PanelClick(Sender);
  FCalculatorController.OperatorPressed(Divide);
end;

procedure TForm1.WebTimer1Timer(Sender: TObject);
begin
  WebTimer1.Enabled := False;
  Unpress;
end;

end.
