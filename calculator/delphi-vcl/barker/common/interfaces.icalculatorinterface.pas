unit interfaces.icalculatorinterface;

interface

{
  Developer: Ian Barker
           https://about.me/IanBarker
           https://www.codedotshow.com/blog
}

type TOperatorType = (None, Percent, OneOverX, XSquared, SquareRootX, Divide, Multiply, Subtract, Add);
const TOperatorText: array[TOperatorType] of string = ('E', '%', 'E', 'E', 'E', '/', '*', '-', '+');

type TUpdateCalcDisplay = procedure of object;

type ICalculator = interface
  procedure NumberPressed(const Digit: Char);
  procedure OperatorPressed(const OperatorType: TOperatorType);
  procedure EqualsPressed;
  procedure BackSpacePressed;
  procedure ChangeSign;
  procedure DecimalPointPressed;
  procedure ClearPressed;
  procedure SetCalcDisplay(TheValue: TUpdateCalcDisplay);
  property UpdateDisplay: TUpdateCalcDisplay write SetCalcDisplay;
  function GetCurrentTotal: string;
  property CurrentTotal: string read GetCurrentTotal;
  function GetHistory: string;
  property History: string read GetHistory;
end;

implementation

end.
