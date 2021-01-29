# Calculator Analysis 

![Leone Calculator Appearance](https://github.com/Embarcadero/ComparisonResearch/blob/main/calculator/delphi-fmx/leone/Leone_FMX%20Calculator_Appearance.PNG)

## Adherence to the Specification

### GUI
**90% adherence** to the specification. This calculator has the following deviations:
- Some operation buttons and +/- button do not look the same
- Transparency exists but lacks the "blur" effect in the specification. This effect was unachievable within the 5 hours specified.

### Functionaity
**95% adherence** to the specification. This calculator has the following deviations:
- Displays more decimal digits than the Windows 10 calculator and prints an ellipse ("...") when the value is larger than the text space. This is a default Delphi behavior.
- Percentage operation does not display the correct value in the Answer field following the Percent button press. The calculated answer is correct but display functionality deviates from Windows 10 calculator behavior.

## Code Design

### Decoupling
The GUI is **partially decoupled** from the calculator logic. Equation.pas describes a class that encapsulates the equation entered and its solution. FMXCalculatorLogic.pas links to the GUI form, handles GUI input, and also provides the state machine logic needed to replicate Windows 10 calculator behavior. Full decoupling requires moving the FSM to a different file and using the FMXCalculatorLogic.pas file (renamed to CalcGUI.pas, perhaps) as a simple pass-through mechanism that can be hooked up to any type of backend logic file.

### Languages
This calculator is written exclusively in Delphi.

### Techniques
#### State Machine
In order to replicate the behavior of the Windows 10 calculator, this calculator uses a state machine to adjust the behavior of the interface buttons depending on what input has already been provided.  State is defined in an enumerated type and tracked throughout the "controller" part of the MVC pattern.

*FMXCalculatorLogic.pas*

`State = (InputFirstDigit, InputFollowingDigits, Solved, Error);`
`calcState : State;`

State checks like `if calcState = State.Solved then` are in most functions responding to GUI inputs.

#### Transparency
GUI transparency was achieved by adjusting the alpha value of the main Calculator GUI window down 15 points from 255 (solid) to 240 (lightly transparent). 

*FMXCalculatorLogic.pas*
```
{*
  Make the calculator semi-transparent like the Windows Calculator
*}
procedure TForm1.FormCreate(Sender: TObject);
var     h : HWND;
        aStyle : integer;
        alphaValue : byte;
begin
  h := WindowHandleToPlatform(self.Handle).Wnd;
  AStyle := GetWindowLong(h, GWL_EXSTYLE);
  SetWindowLong(h, GWL_EXSTYLE, AStyle or WS_EX_LAYERED);

  AlphaValue := 240;
  SetLayeredWindowAttributes(h, 0, alphaValue, LWA_ALPHA);
end;
```

RAD Studio includes a Blur tool in its standard "Tool Palette" but it operates on all child objects and blurred the calculator buttons and displays rather than the background when tested.

#### Enum Operations
Rather than parsing an equation string to solve an equation, this calculator uses an enumerated type to represent operations and executes the relevant calculation according to the stored Operations value.

*Equation.pas*

`Operations = (Addition, Subtraction, Multiplication, Division, Reciprocal, Square, SquareRoot, Percentage, Nothing);`


## Metrics

### Code Size
This calculator has 745 lines of code. The developer wrote 398 lines of code and RAD Studio generated the rest. Only 72 lines (18% of developer written lines) are needed to set up the GUI and connect it to the calculator logic and the remaining 326 form the state machine and calculation engine.

### Files and Sizes
This calculator compiles to one, 9.7MB binary executable.

### Runtime Performance
Although slower than the VCL calculators, this FMX calculator started up in 0.1616 seconds from a local filesystem and 0.3188 seconds from a network location.  It used 33.13MB of memory when idle and peaked at 41.61MB.

### Productivity
This calculator took approximately 40 hours to develop and test.  The developer used this exercise to learn the Delphi language but had some familiarity with the RAD Studio IDE through it's C++ Builder version in order to speed up the visual GUI development.  This productivity time was not considered in the white paper analysis because this developer is not an "MVP" and lacked Delphi expertise.
