unit Calculator.Engine;

interface

uses
  System.Classes, System.SysUtils;

type
  TCalcEngine = class(TObject)

  private
    FOperation: string;
    FValue: Double;
    function GetValue: Double;
  protected
    procedure Number(ANumber: Integer);
  public
    Constructor Create;
    property Value: Double read GetValue;
    property Operation: string read FOperation write FOperation;
    procedure Calc(AKey: string);
    procedure Clear;
  end;

implementation

{ TCalcEngine }

procedure TCalcEngine.Calc(AKey: string);
begin
  if CharInSet(AKey[1], ['0' .. '9']) then
  begin
    Number(AKey.ToInteger);
  end;
end;

procedure TCalcEngine.Clear;
begin
  FValue := 0;
  FOperation := '';
end;

constructor TCalcEngine.Create;
begin
  inherited;
  FValue := 0;
  FOperation := '';
end;

function TCalcEngine.GetValue: Double;
begin
  result := FValue;
end;

procedure TCalcEngine.Number(ANumber: Integer);
begin
  // Todo: implement
  FValue := ANumber;
  FOperation := FOperation + ANumber.ToString;
end;

end.
