Total time: 53 minutes without counting CalculatorEngine which required a little tought.

## Step 1: Create GUI

Create a new Windows VCL application

Resize the form 
* W=334 H=322, Caption=”Calculator”, Name=” CalculatorForm”
	
Constraints: 
* MinHeight= 200, MinWidth=200
	
Drop a TLabel near the top of the form
* Name=ExprLabel, Autosize=False, Width=ClientWidth less margins, 
* Alignment taRightJustify, Anchors=left+top+right

Drop a TLabel below the first
* Name=NumLabel, Autosize=False, Width=ClientWidth less margins, 
* Alignment taRightJustify, Anchors=left+top+right 
* Font: size=12, style=bold

Drop a TPanel on the form
* Size=51x51

Copy the TPanel and paste it 11 times to make the numeric keypad
* Arrange the panels to be contiguous as a 3x4 grid on the left (7,8,9/4,5,6/1,2,3/C,0,.)
* Rename the panels as OnePanel, TwoPanel,…
* Change captions to be 1, E,…
* ClearPanel caption is ‘C’
* DecimalPanel caption is ‘.’

Drop a TPanel on the form
* Size=71x51

Copy the TPanel and paste 5 times to make /,X,+,-,=,backspace key
* Arrange 4 panels as a column for /, *, -, +.
* Arrange 2 panels for backspace and equal.
* Rename panels as DividePanel, MultiplyPanel, SubtractPanel, AddPanel,
* EqualPanel and BackSpacePanel. Change captions accordingly.
* EqualPanel can be double height.

Drop a CheckBox on the right of DividePanel
* Rename as TransparentCheckbox. Caption=”Trans.”

Drop a TTimer anywhere on the form.
* Rename as FlashTimer. Set Enabled=FALSE.

Drop a TEdit on the top left corner, make it small.

Save the form and project as “CalculatorMain.pas” and “Calculator.dproj”


## Step 2: Add basic code for form size/position persistence
Switch to code tab and add the following déclaration in TCalculatorForm
```pascal
    private
        FIniFileName  : String;
        FAppName      : String;
        FLocalAppData : String;
```
Add this FormCreate handler:
```pascal
procedure TCalculatorForm.FormCreate(Sender: TObject);
var
    Path    : array [0..MAX_PATH] of Char;
    IniFile : TIniFile;
begin
    // Get path for local appdata folder in user profile (Uses: Winapi.SHFolder)
    SHGetFolderPath(0, CSIDL_LOCAL_APPDATA, 0, SHGFP_TYPE_CURRENT, @Path[0]);

    FAppName        := ChangeFileExt(ExtractFileName(Application.ExeName), '');
    FLocalAppData   := IncludeTrailingPathDelimiter(Path) +
                       CompanyFolder + '\' + FAppName + '\';
    ForceDirectories(FLocalAppData);
    FIniFileName    := FLocalAppData + FAppName + '.ini';

    IniFile := TIniFile.Create(FIniFileName);   // Uses: System.IniFiles
    try
        Width  := IniFile.ReadInteger('Window', 'Width',  Width);
        Height := IniFile.ReadInteger('Window', 'Height', Height);
        Top    := IniFile.ReadInteger('Window', 'Top',
                                      (Screen.Height - Height) div 2);
        Left   := IniFile.ReadInteger('Window', 'Left',
                                      (Screen.Width  - Width)  div 2);
    finally
        IniFile.Destroy;
    end;
end;
```

Add the following FormClose handler:
```pascal
procedure TCalculatorForm.FormClose(Sender: TObject; var Action: TCloseAction);
var
    IniFile : TIniFile;
begin
    try
        IniFile := TIniFile.Create(FIniFileName);
        try
            IniFile.WriteInteger('Window', 'Top',    Top);
            IniFile.WriteInteger('Window', 'Left',   Left);
            IniFile.WriteInteger('Window', 'Width',  Width);
            IniFile.WriteInteger('Window', 'Height', Height);
        finally
            IniFile.Destroy;
        end;
    except
        // Ignore any exception when saving window size and position
    end;
end;
```

Run the application and verify that the GUI looks OK and position and size are preserved against several runs.


## Step 3: Add code to adapt GUI to form resize

Add the following FormResize event handler:
```pascal
procedure TCalculatorForm.FormResize(Sender: TObject);
var
    W1, W2, W3, W4 : Integer;
    H1, H2 : Integer;
begin
    // Move edit out of view
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
```

Save and run the project. Resize the form and verify that all buttons resize correctly.


## Step 4: Create calculator engine unit

Add a new unit to the project.

Name the unit CalculatorEngine.pas 

Add the following code:
```pascal
unit CalculatorEngine;

interface

uses
    System.Classes, System.SysUtils, System.Character;

type
    TCalculator = class(TComponent)
    private
        FNum                : String;
        FDecimal            : Boolean;
        FOperand1           : Double;
        FPrevOperator       : Char;
        FPrevKey            : Char;
        FExpression         : String;
        FFormatSettings     : TFormatSettings;
        FOnExpressionChange : TNotifyEvent;
        FOnNumChange        : TNotifyEvent;
        FOnOperand1Change   : TNotifyEvent;
        procedure SetExpression(const S : String);
        procedure SetNum(const S : String);
        procedure SetOperand1(const Value : Double);
    public
        constructor Create(AOwner : TComponent); override;
        procedure Clear;
        procedure KeyPress(var Key : Char);
        property Expression : String read FExpression;
        property Num        : String read FNum;
        property Operand1   : Double read FOperand1;
    published
        property OnExpressionChange : TNotifyEvent read  FOnExpressionChange
                                                   write FOnExpressionChange;
        property OnNumChange        : TNotifyEvent read  FOnNumChange
                                                   write FOnNumChange;
        property OnOperand1Change   : TNotifyEvent read  FOnOperand1Change
                                                   write FOnOperand1Change;
    end;

implementation

const
    Operators : TSysCharSet = ['+', '-', '*', 'x', '/', '='];

constructor TCalculator.Create(AOwner: TComponent);
begin
    inherited;
    FFormatSettings                  := FormatSettings;
    FFormatSettings.DecimalSeparator := '.';
    Clear;
end;

procedure TCalculator.Clear;
begin
    FDecimal              := FALSE;
    FPrevOperator         := '+';
    FPrevKey              := ' ';
    SetNum('0');
    SetOperand1(0);
    SetExpression('0');
    SetOperand1(0);
end;

procedure TCalculator.KeyPress(var Key : Char);
begin
    Key := Key.ToLower;
    // Replace return key by equal key
    if Key = #13 then
        Key := '=';
    if Key = FormatSettings.DecimalSeparator then
        Key := FFormatSettings.DecimalSeparator;

    if CharInSet(Key, Operators) then begin
        if FPrevOperator = '=' then begin
            FPrevOperator := Key;
            SetExpression(Double.ToString(FOperand1, FFormatSettings) + Key);
            SetNum('0');
            FDecimal := FALSE;
        end
        else if (not CharInSet(FPrevKey,  Operators)) and
           (CharInSet(FPrevOperator, Operators)) then begin
            case FPrevOperator of
            '+': SetOperand1(FOperand1 + Double.Parse(FNum, FFormatSettings));
            '-': SetOperand1(FOperand1 - Double.Parse(FNum, FFormatSettings));
            '*', 'x':
                 SetOperand1(FOperand1 * Double.Parse(FNum, FFormatSettings));
            '/': SetOperand1(FOperand1 / Double.Parse(FNum, FFormatSettings));
            end;

            if FExpression = '0' then
                SetExpression(FNum)
            else
                SetExpression(FExpression + FNum);
            SetNum('0');
            FPrevOperator := Key;
            if Key = '=' then begin
                SetExpression(FExpression + '=' + Double.ToString(FOperand1, FFormatSettings));
                SetNum('0');
            end
            else
                SetExpression(FExpression + FPrevOperator);
            FDecimal := FALSE;
        end;
    end
    else begin
        case Key of
        '0'..'9':
            begin
                if FNum = '0' then
                    SetNum(Key)
                else
                    SetNum(FNum + Key);
            end;
        '.':
            begin
                if not FDecimal then begin
                    FDecimal         := TRUE;
                    SetNum(FNum + Key);
                end;
            end;
        #8:
            begin
                if Length(FNum) > 1 then
                    SetNum(Copy(FNum, 1, Length(FNum) - 1))
                else
                    SetNum('0');
            end;
        'c':
            begin
                Clear;
            end;
        else
            // Ignore anything else
            Key := #0;
            Exit;
        end;
    end;
    FPrevKey := Key;    // Remember previous key
    Key      := #0;     // Do not process key further
end;

procedure TCalculator.SetExpression(const S: String);
begin
    FExpression := S;
    if Assigned(FOnExpressionChange) then
        FOnExpressionChange(Self);
end;

procedure TCalculator.SetNum(const S: String);
begin
    FNum := S;
    if Assigned(FOnNumChange) then
        FOnNumChange(Self);
end;

procedure TCalculator.SetOperand1(const Value : Double);
begin
    FOperand1 := Value;
    if Assigned(FOnOperand1Change) then
        FOnOperand1Change(Self);
end;

end.
```


## Step 5: Add calculator engine to the project

Add CalculatorEngine in the project form’s uses clause.

Add this declaration in the form’s private section:
```pascal
        FCalculator   : TCalculator;
```
Add this line at the end of FormCreate event handler:
```pascal
        FCalculator                    := TCalculator.Create(Self);
```
Check that saving,  compiling and running the project still works unchanged.

Add event handler to the calculator engine to update the GUI:
At the end of FormCreate event handler, add the following code:
```pascal
    FCalculator.OnNumChange        := CalculatorNumChange;
    FCalculator.OnExpressionChange := CalculatorExpressionChange;
    CalculatorNumChange(FCalculator);
    CalculatorExpressionChange(FCalculator);	
```

Declare and implement the two event handlers that update the GUI with calculator engine data:
```pascal
procedure TCalculatorForm.CalculatorExpressionChange(Sender: TObject);
begin
    ExprLabel.Caption := FCalculator.Expression;
end;

procedure TCalculatorForm.CalculatorNumChange(Sender: TObject);
begin
    NumLabel.Caption := FCalculator.Num;
end;
```
Feed calculator engine with data entered by the user using keyboard or mouse.

Keyboard: Add an OnKeyPress event handler for EntryEdit:
```pascal
procedure TCalculatorForm.EntryEditKeyPress(Sender: TObject; var Key: Char);
var
    I    : Integer;
    Ctrl : TControl;
begin
    if Key = FormatSettings.DecimalSeparator then
        Key := '.'           // We always use dot as decimal separator
    else if Key = #13 then   // Enter key is made same as equal
        Key := '='
    else if Key = 'c' then   // "Clear" key in lower case
        Key := 'C';
    FCalculator.KeyPress(Key);
end;
```
Mouse: Add the same event handler for all TPanel (Select all to do it in one operation):
```pascal
procedure TCalculatorForm.AllPanelClick(Sender: TObject);
var
    Key : Char;
begin
    if Sender = BackspacePanel then
        Key := #8
    else
        Key := (Sender as TPanel).Caption[1];
    FCalculator.KeyPress(Key);
end;
```


## Step 6: Make the panel flash when the user enter data

Create an OnTimer event handler for FlashTimer:
```pascal
procedure TCalculatorForm.FlashTimerTimer(Sender: TObject);
begin
    FlashTimer.Enabled           := FALSE;
    (FFlashCtrl as TPanel).Color := clBtnFace;
    FFlashCtrl                   := nil;
end;
```

Create a procedure to make a panel flash:
```pascal
procedure TCalculatorForm.FlashPanel(Ctrl : TPanel);
begin
    FlashTimer.Interval := 100;
    FlashTimer.Enabled  := TRUE;
    FFlashCtrl          := Ctrl;
    Ctrl.Color          := clDkGray;
end;
```

Insert code to make panel flash for keyboard input: in EntryEditKeyPress before the line with FCalculator.KeyPress(Key) insert the code below.
```pascal
    // Search which panel correspond to the key and then flash it
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
```

Insert the code to make panel flash when user click on the panels: in AllPanelClick just after the begin insert the code below.
```pascal
    FlashPanel(Sender as TPanel);
```


## Step 7: Make the calculator semi-transparent

In the top of implementation section, add the following function:
```pascal
function MakeWindowTransparent(Handle: HWND; Alpha: Integer = 10): Boolean;
begin
    SetWindowLong(Handle, GWL_EXSTYLE,
                  GetWindowLong(Handle, GWL_EXSTYLE) or WS_EX_LAYERED);
    Result := SetLayeredWindowAttributes(
                               Handle,
                               0,
                               Trunc((255 / 100) * (100 - Alpha)),
                               LWA_ALPHA);
end;
```

Add an OnClick event handler for TransparentCheckbox:
```pascal
procedure TCalculatorForm.TransparentCheckBoxClick(Sender: TObject);
begin
    if TransparentCheckBox.Checked then
        MakeWindowTransparent(Handle, 15)
    else
        MakeWindowTransparent(Handle, 0);
end;
```

You are done. Save, compile, run and enjoy :-)


