unit Calculator.Forms.Main;

interface

uses
  System.Classes, System.SysUtils, System.Types, System.UITypes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts,
  Calculator.Forms.Transparent, Calculator.Engine;

type
  TFormMain = class(TTransparentForm)
    StyleBookCalculator: TStyleBook;
    GridMain: TGridPanelLayout;
    PanelDisplay: TPanel;
    LabelValue: TLabel;
    LabelOperation: TLabel;
    GridButtons: TGridPanelLayout;
    Panel1: TPanel;
    SpeedButton1: TSpeedButton;
    Panel2: TPanel;
    SpeedButton2: TSpeedButton;
    Panel3: TPanel;
    SpeedButton3: TSpeedButton;
    Panel4: TPanel;
    SpeedButton4: TSpeedButton;
    Panel5: TPanel;
    SpeedButton5: TSpeedButton;
    Panel6: TPanel;
    SpeedButton6: TSpeedButton;
    Panel7: TPanel;
    SpeedButton7: TSpeedButton;
    Panel8: TPanel;
    SpeedButton8: TSpeedButton;
    Panel9: TPanel;
    SpeedButton9: TSpeedButton;
    Panel10: TPanel;
    SpeedButton10: TSpeedButton;
    Panel11: TPanel;
    SpeedButton11: TSpeedButton;
    Panel12: TPanel;
    SpeedButton12: TSpeedButton;
    Panel13: TPanel;
    SpeedButton13: TSpeedButton;
    Panel14: TPanel;
    SpeedButton14: TSpeedButton;
    Panel15: TPanel;
    SpeedButton15: TSpeedButton;
    Panel16: TPanel;
    SpeedButton16: TSpeedButton;
    Panel17: TPanel;
    SpeedButton17: TSpeedButton;
    Panel18: TPanel;
    SpeedButton18: TSpeedButton;
    Panel19: TPanel;
    SpeedButton19: TSpeedButton;
    Panel20: TPanel;
    SpeedButton20: TSpeedButton;
    Panel21: TPanel;
    SpeedButton21: TSpeedButton;
    Panel22: TPanel;
    SpeedButton22: TSpeedButton;
    Panel23: TPanel;
    SpeedButton23: TSpeedButton;
    Panel24: TPanel;
    SpeedButton24: TSpeedButton;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift:
      TShiftState);
    procedure SendKey(Sender: TObject);
  private
    FCalculator: TCalculatorEngine;
    procedure UpdateDisplay;
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;

implementation

{$R *.fmx}


procedure TFormMain.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FCalculator);
end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
  AlphaBlendValue := 240; // Just a little bit of trancparency. 255 would be no transparency.
  FCalculator := TCalculatorEngine.Create;
  UpdateDisplay;
end;

procedure TFormMain.FormKeyUp(Sender: TObject; var Key: Word; var KeyChar:
  Char; Shift: TShiftState);
var
  LKey: Char;
begin
  if Key > 0 then
  begin
    LKey := Char(Key);
  end
  else
  begin
    LKey := KeyChar;
  end;
  FCalculator.SendKey(LKey);
  UpdateDisplay;
end;

procedure TFormMain.SendKey(Sender: TObject);
begin
  if (Sender is TSpeedButton) and (TSpeedButton(Sender).Hint > '') then
  begin
    FCalculator.SendKey(TSpeedButton(Sender).Hint[1]);
    UpdateDisplay;
  end;
end;

procedure TFormMain.UpdateDisplay;
begin
  LabelValue.Text := FCalculator.ValueString;
  LabelOperation.Text := FCalculator.CurrentOperation;
end;

end.
