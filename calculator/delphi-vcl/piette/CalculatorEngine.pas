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
