unit CalculatorMain;

interface

uses
    Winapi.Windows, Winapi.Messages, Winapi.SHFolder,
    System.SysUtils, System.Variants, System.Classes, System.IniFiles,
    Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
    Vcl.ExtCtrls,
    CalculatorEngine;

const
    CompanyFolder = 'OverByte';

type
  TCalculatorForm = class(TForm)
    ExprLabel: TLabel;
    NumLabel: TLabel;
    EntryEdit: TEdit;
    SevenPanel: TPanel;
    EightPanel: TPanel;
    NinePanel: TPanel;
    FourPanel: TPanel;
    FivePanel: TPanel;
    SixPanel: TPanel;
    OnePanel: TPanel;
    TwoPanel: TPanel;
    ThreePanel: TPanel;
    ClearPanel: TPanel;
    ZeroPanel: TPanel;
    DecimalPanel: TPanel;
    DividePanel: TPanel;
    MultiplyPanel: TPanel;
    SubtractPanel: TPanel;
    AddPanel: TPanel;
    BackspacePanel: TPanel;
    EqualPanel: TPanel;
    TransparentCheckBox: TCheckBox;
    FlashTimer: TTimer;
    procedure EntryEditKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure AllPanelClick(Sender: TObject);
    procedure FlashTimerTimer(Sender: TObject);
    procedure TransparentCheckBoxClick(Sender: TObject);
  private
    FIniFilename  : String;
    FAppName      : String;
    FLocalAppData : String;
    FCalculator   : TCalculator;
    FFlashCtrl    : TPanel;
    procedure CalculatorExpressionChange(Sender: TObject);
    procedure CalculatorNumChange(Sender: TObject);
    procedure FlashPanel(Ctrl: TPanel);
  end;

var
    CalculatorForm: TCalculatorForm;

implementation

{$R *.dfm}

function MakeWindowTransparent(
    Handle : HWND;
    Alpha  : Integer = 10) : Boolean;
begin
    SetWindowLong(Handle, GWL_EXSTYLE,
                  GetWindowLong(Handle, GWL_EXSTYLE) or WS_EX_LAYERED);
    Result := SetLayeredWindowAttributes(
                  Handle,
                  0,
                  Trunc((255 / 100) * (100 - Alpha)),
                  LWA_ALPHA);
end;

procedure TCalculatorForm.FormClose(Sender: TObject; var Action: TCloseAction);
var
    IniFile : TIniFile;
begin
    try
        IniFile := TIniFile.Create(FIniFilename);
        try
            IniFile.WriteInteger('Window', 'Height', Height);
            IniFile.WriteInteger('Window', 'Width',  Width);
            IniFile.WriteInteger('Window', 'Top',    Top);
            IniFile.WriteInteger('Window', 'Left',   Left);
        finally
            IniFile.Free;
        end;
    except
        // Ignore any exception here (Would prevent close the app)
    end;
end;

procedure TCalculatorForm.FormCreate(Sender: TObject);
var
    IniFile : TIniFile;
    Path    : array [0..MAX_PATH] of Char;
begin
    SHGetFolderPath(0, CSIDL_LOCAL_APPDATA, 0, SHGFP_TYPE_CURRENT, @Path[0]);

    FAppName      := ChangeFileExt(ExtractFileName(Application.ExeName), '');
    FLocalAppData := IncludeTrailingPathDelimiter(Path) +
                     CompanyFolder + '\' + FAppName + '\';
    ForceDirectories(FLocalAppData);
    FIniFileName  := FLocalAppData + FAppName + '.ini';

    IniFile := TIniFile.Create(FIniFilename);
    try
        Height := IniFile.ReadInteger('Window', 'Height', Height);
        Width  := IniFile.ReadInteger('Window', 'Width',  Width);
        Top    := IniFile.ReadInteger('Window', 'Top',    Top);
        Left   := IniFile.ReadInteger('Window', 'Left',   Left);
    finally
        IniFile.Free;
    end;

    FCalculator                    := TCalculator.Create(Self);
    FCalculator.OnNumChange        := CalculatorNumChange;
    FCalculator.OnExpressionChange := CalculatorExpressionChange;
    CalculatorNumChange(FCalculator);
    CalculatorExpressionChange(FCalculator);
end;

procedure TCalculatorForm.CalculatorExpressionChange(Sender : TObject);
begin
    ExprLabel.Caption := FCalculator.Expression;
end;

procedure TCalculatorForm.CalculatorNumChange(Sender : TObject);
begin
    NumLabel.Caption  := FCalculator.Num;
end;

procedure TCalculatorForm.EntryEditKeyPress(Sender: TObject; var Key: Char);
var
    Ctrl : TControl;
    I    : Integer;
begin
    if Key = FormatSettings.DecimalSeparator then
        Key := '.'            // Calculator always use dot as decimal separator
    else if Key = #13 then    // Enter key is made same as equal sign
        Key := '='
    else if Key = 'c' then    // Clear key in lower case
        Key := 'C';
    if Key = #8 then
        FlashPanel(BackspacePanel)
    else begin
        for I := 0 to ControlCount - 1 do begin
            Ctrl := Controls[I];
            if (Ctrl is TPanel) and
               (TPanel(Ctrl).Caption[1] = Key) then begin
                   FlashPanel(TPanel(Ctrl));
                   break;
               end;
        end;
    end;
    FCalculator.KeyPress(Key);
end;

procedure TCalculatorForm.FormResize(Sender: TObject);
var
    W1, W2, W3, W4 : Integer;
    H1, H2         : Integer;
begin
    // Move edit out of the view
    EntryEdit.Left := ClientWidth + 10;

    W1 := (ClientWidth * 164) div 334;
    W2 := (W1 - 16) div 3;
    W3 := ClientWidth - W1;
    W4 := (W3 - 8) div 2;

    H1 := 72;
    H2 := (ClientHeight - H1 - 8) div 4;

    SevenPanel.Left       := 8;
    SevenPanel.Width      := W2;
    EightPanel.Left       := SevenPanel.Left + SevenPanel.Width;
    EightPanel.Width      := W2;
    NinePanel.Left        := EightPanel.Left + EightPanel.Width;
    NinePanel.Width       := W2;

    FourPanel.Left        := 8;
    FourPanel.Width       := W2;
    FivePanel.Left        := SevenPanel.Left + SevenPanel.Width;
    FivePanel.Width       := W2;
    SixPanel.Left         := EightPanel.Left + EightPanel.Width;
    SixPanel.Width        := W2;

    OnePanel.Left         := 8;
    OnePanel.Width        := W2;
    TwoPanel.Left         := SevenPanel.Left + SevenPanel.Width;
    TwoPanel.Width        := W2;
    ThreePanel.Left       := EightPanel.Left + EightPanel.Width;
    ThreePanel.Width      := W2;

    ClearPanel.Left       := 8;
    ClearPanel.Width      := W2;
    ZeroPanel.Left        := SevenPanel.Left + SevenPanel.Width;
    ZeroPanel.Width       := W2;
    DecimalPanel.Left     := EightPanel.Left + EightPanel.Width;
    DecimalPanel.Width    := W2;

    DividePanel.Left      := W1;
    DividePanel.Width     := W4;
    MultiplyPanel.Left    := W1;
    MultiplyPanel.Width   := W4;
    SubtractPanel.Left    := W1;
    SubtractPanel.Width   := W4;
    AddPanel.Left         := W1;
    AddPanel.Width        := W4;

    SevenPanel.Top        := H1;
    SevenPanel.Height     := H2;
    FourPanel.Top         := SevenPanel.Top + SevenPanel.Height;
    FourPanel.Height      := H2;
    OnePanel.Top          := FourPanel.Top  + FourPanel.Height;
    OnePanel.Height       := H2;
    ClearPanel.Top        := OnePanel.Top + OnePanel.Height;
    ClearPanel.Height     := H2;

    EightPanel.Top        := H1;
    EightPanel.Height     := H2;
    FivePanel.Top         := SevenPanel.Top + SevenPanel.Height;
    FivePanel.Height      := H2;
    TwoPanel.Top          := FourPanel.Top  + FourPanel.Height;
    TwoPanel.Height       := H2;
    ZeroPanel.Top         := OnePanel.Top + OnePanel.Height;
    ZeroPanel.Height      := H2;

    NinePanel.Top         := H1;
    NinePanel.Height      := H2;
    SixPanel.Top          := SevenPanel.Top + SevenPanel.Height;
    SixPanel.Height       := H2;
    ThreePanel.Top        := FourPanel.Top  + FourPanel.Height;
    ThreePanel.Height     := H2;
    DecimalPanel.Top      := OnePanel.Top + OnePanel.Height;
    DecimalPanel.Height   := H2;

    DividePanel.Top       := H1;
    DividePanel.Height    := H2;
    MultiplyPanel.Top     := SevenPanel.Top + SevenPanel.Height;
    MultiplyPanel.Height  := H2;
    SubtractPanel.Top     := FourPanel.Top  + FourPanel.Height;
    SubtractPanel.Height  := H2;
    AddPanel.Top          := OnePanel.Top + OnePanel.Height;
    AddPanel.Height       := H2;

    EqualPanel.Left       := W1 + W4;
    EqualPanel.Width      := W4;
    EqualPanel.Top        := OnePanel.Top;
    EqualPanel.Height     := H2 + H2;

    BackspacePanel.Left   := W1 + W4;
    BackspacePanel.Width  := W4;
    BackspacePanel.Top    := FourPanel.Top;
    BackspacePanel.Height := H2;

    TransparentCheckBox.Top  := H1 + (H2 - TransparentCheckBox.Height) div 2;
    TransparentCheckBox.Left := W1 + W4 + 4;
end;

procedure TCalculatorForm.AllPanelClick(Sender: TObject);
var
    Key : Char;
begin
    FlashPanel(Sender as TPanel);
    if Sender = BackspacePanel then
        Key := #8
    else
        Key := (Sender as TPanel).Caption[1];
    FCalculator.KeyPress(Key);
end;

procedure TCalculatorForm.FlashTimerTimer(Sender: TObject);
begin
    FlashTimer.Enabled  := FALSE;
    FFlashCtrl.Color    := clBtnFace;
    FFlashCtrl          := nil;
end;

procedure TCalculatorForm.FlashPanel(Ctrl : TPanel);
begin
    FFlashCtrl          := Ctrl;
    Ctrl.Color          := clDkGray;
    FlashTimer.Interval := 100;
    FlashTimer.Enabled  := TRUE;
end;

procedure TCalculatorForm.TransparentCheckBoxClick(Sender: TObject);
begin
    if TransparentCheckBox.Checked then
        MakeWindowTransparent(Handle, 15)
    else
        MakeWindowTransparent(Handle, 0);
end;

end.
