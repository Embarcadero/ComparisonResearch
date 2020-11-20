unit forms.VCLCalculator;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;


type TActivePanel = record
  SelectedPanel: TPanel;
  OriginalColor: TColor;
end;

type
  TVCLCalculatorForm = class(TForm)
    TopPanel: TPanel;
    Panel1: TPanel;
    HistoryLabel: TLabel;
    Panel2: TPanel;
    CurrentValueLabel: TLabel;
    FunctionsPanel: TPanel;
    ButtonsPanel: TPanel;
    Timer1: TTimer;
    Pnl1: TPanel;
    Pnl2: TPanel;
    Pnl3: TPanel;
    Pnl4: TPanel;
    Pnl5: TPanel;
    Pnl6: TPanel;
    Pnl7: TPanel;
    Pnl8: TPanel;
    Pnl12: TPanel;
    Pnl16: TPanel;
    Pnl20: TPanel;
    Pnl9: TPanel;
    Pnl10: TPanel;
    Pnl11: TPanel;
    Pnl13: TPanel;
    Pnl14: TPanel;
    Pnl15: TPanel;
    Pnl17: TPanel;
    Pnl18: TPanel;
    Pnl22: TPanel;
    Pnl21: TPanel;
    Pnl19: TPanel;
    Pnl23: TPanel;
    Pnl24: TPanel;
    Mem1: TLabel;
    Mem2: TLabel;
    Mem3: TLabel;
    Mem4: TLabel;
    Mem6: TLabel;
    Mem5: TLabel;
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure PanelClick(Sender: TObject);
    procedure AppGotFocus(Sender: TObject);
    procedure AppLostFocus(Sender: TObject);
    procedure NumberClick(Sender: TObject);
    procedure Pnl24Click(Sender: TObject);
    procedure Pnl1Click(Sender: TObject);
    procedure Pnl3Click(Sender: TObject);
    procedure Pnl4Click(Sender: TObject);
    procedure Pnl12Click(Sender: TObject);
    procedure Pnl16Click(Sender: TObject);
    procedure Pnl20Click(Sender: TObject);
    procedure Pnl21Click(Sender: TObject);
    procedure Pnl23Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    FActivePanel: TActivePanel;
    procedure SizeControls;
    procedure HighlightKeypress(TheControl: TPanel);
    procedure Unpress;
    procedure UpdateDisplay;
    procedure SetCaptions;
  end;

var
  VCLCalculatorForm: TVCLCalculatorForm;

implementation

{$R *.dfm}

uses System.StrUtils,
     controllers.calculatorinterface,
     interfaces.icalculatorinterface;


const
  cFunctionButtons = [1..8, 12, 16, 20];
  cNumberButtons   = [9..11, 13..15, 17..19, 21..23];

{ TVCLCalculatorForm }

procedure TVCLCalculatorForm.AppGotFocus(Sender: TObject);
begin
  // Make form go semi-transparent
  AlphaBlend := True;
end;

procedure TVCLCalculatorForm.AppLostFocus(Sender: TObject);
begin
  // Make form go opaque
  AlphaBlend := False;
end;

procedure TVCLCalculatorForm.FormCreate(Sender: TObject);
begin
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
  AlphaBlend := False;
end;

procedure TVCLCalculatorForm.FormResize(Sender: TObject);
begin
  SizeControls;
end;

procedure TVCLCalculatorForm.HighlightKeypress(TheControl: TPanel);
const
  cFunctionFlashColor = $00DBDBDB;
  cRegularFlashColor  = $00E6E6E6;
  cEqualsFlashColor   = $00DBC8B0;
begin
  Timer1.Enabled                   := False;
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
  Timer1.Enabled := True;
end;

procedure TVCLCalculatorForm.NumberClick(Sender: TObject);
var
  sStr: string;
begin
  PanelClick(Sender);
  sStr := (Sender as TPanel).Caption;
  if sStr.Length > 0 then
    FCalculatorController.NumberPressed(sStr.Chars[0]);
end;

procedure TVCLCalculatorForm.PanelClick(Sender: TObject);
begin
  HighlightKeypress(TPanel(Sender));
end;

procedure TVCLCalculatorForm.Pnl12Click(Sender: TObject);
begin
  PanelClick(Sender);
  FCalculatorController.OperatorPressed(Multiply);
end;

procedure TVCLCalculatorForm.Pnl16Click(Sender: TObject);
begin
  PanelClick(Sender);
  FCalculatorController.OperatorPressed(Subtract);
end;

procedure TVCLCalculatorForm.Pnl1Click(Sender: TObject);
begin
  PanelClick(Sender);
  FCalculatorController.OperatorPressed(Percent);
end;

procedure TVCLCalculatorForm.Pnl20Click(Sender: TObject);
begin
  PanelClick(Sender);
  FCalculatorController.OperatorPressed(Add);
end;

procedure TVCLCalculatorForm.Pnl21Click(Sender: TObject);
begin
  PanelClick(Sender);
  FCalculatorController.ChangeSign;
end;

procedure TVCLCalculatorForm.Pnl23Click(Sender: TObject);
begin
  PanelClick(Sender);
  FCalculatorController.DecimalPointPressed;
end;

procedure TVCLCalculatorForm.Pnl24Click(Sender: TObject);
begin
  PanelClick(Sender);
  FCalculatorController.EqualsPressed;
end;

procedure TVCLCalculatorForm.Pnl3Click(Sender: TObject);
begin
  PanelClick(Sender);
  FCalculatorController.ClearPressed;
end;

procedure TVCLCalculatorForm.Pnl4Click(Sender: TObject);
begin
  PanelClick(Sender);
  FCalculatorController.BackSpacePressed;
end;

procedure TVCLCalculatorForm.SetCaptions;
begin
  Pnl1.Caption     := '%';
  Pnl1.Font.Name   := 'Segoe UI Symbol';
  Pnl2.Caption     := 'CE';
  Pnl3.Caption     := 'C';
  Pnl4.Caption     := #9003;
  Pnl4.Font.Name   := 'Segoe UI Symbol';
  Pnl5.Caption     := #185'/'#8339;
  Pnl4.Font.Name   := 'Segoe UI Symbol';
  Pnl6.Caption     := #8339#178;
  Pnl6.Font.Name   := 'Segoe UI Symbol';
  Pnl7.Caption     := #178#8730#8339;
  Pnl7.Font.Name   := 'Segoe UI Symbol';
  Pnl8.Caption     := #247;
  Pnl8.Font.Name   := 'Segoe UI Symbol';
  Pnl9.Caption     := '7';
  Pnl10.Caption    := '8';
  Pnl11.Caption    := '9';
  Pnl12.Caption    := #9587;
  Pnl12.Font.Name := 'Segoe UI Symbol';
  Pnl13.Caption    := '4';
  Pnl14.Caption    := '5';
  Pnl15.Caption    := '6';
  Pnl16.Caption    := #8722;
  Pnl20.Caption    := '+';
  Pnl19.Caption    := '3';
  Pnl18.Caption    := '2';
  Pnl17.Caption    := '1';
  Pnl21.Caption    := #8314'/'#8331;
  Pnl21.Font.Name  := 'Segoe UI';
  Pnl22.Caption    := '0';
  Pnl23.Caption    := '.';
  Pnl24.Caption    := '=';
  Pnl24.Font.Name  := 'Segoe UI Symbol';
end;

procedure TVCLCalculatorForm.SizeControls;
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
      CMP := FindComponent('Pnl' + IntToStr(iIdx));
      if (CMP <> Nil) then
        if (CMP is TPanel) then
        begin
          TPanel(CMP).Left    := iGap + ((iWidth + cBorder) * Pred(iCol));
          TPanel(CMP).Top     := iRow * iHeight;
          TPanel(CMP).Width   := iWidth - cBorder;
          TPanel(CMP).Height  := iHeight - cBorder;

          // To make dereferencing which 'button' is pressed a little easier
          TPanel(CMP).Tag     := iIdx;
        end;
    end;end;

procedure TVCLCalculatorForm.Timer1Timer(Sender: TObject);
begin
  Unpress;
end;

procedure TVCLCalculatorForm.Unpress;
begin
  if FActivePanel.SelectedPanel <> Nil then
  begin
    FActivePanel.SelectedPanel.Color := FActivePanel.OriginalColor;
  end;
end;

procedure TVCLCalculatorForm.UpdateDisplay;
begin
  HistoryLabel.Caption      := FCalculatorController.History;
  CurrentValueLabel.Caption := FCalculatorController.CurrentTotal;
end;

end.
