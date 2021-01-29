# Calculator Analysis 

![Barker VCL Calculator Appearance](https://github.com/Embarcadero/ComparisonResearch/blob/main/calculator/delphi-vcl/barker/Barker%20VCL%20Calculator%20Appearance.PNG)

## Adherence to the Specification

### GUI
**95% adherence** to the specification. The only deviations are slighlty different operation symbols, numbers that aren't bold, a different window title, and slightly darker palette.  

### Functionaity
**65% adherence** to the specification. This calculator has the following deviations:
- CE button does not delete the previous equation display.
- Plus/Minus button turns '0' negative.
- Calculator allows a leading '0' (i.e. -0272).
- Reciprocal, square, square root, and percentage operations don't work.
- Repeatedly pressing the equals button after a calculation doesn't re-apply the last operation to the result.

## Code Design

### Decoupling
The GUI is decoupled from the calculator logic. classes.tcalculationinterface.pas describes a class that encapsulates the equation entered and its solution. interfaces.icalculatorinterface.pas defines the interface for the back-end and the state machine enumerated types.  forms.VCLCalculator.pas handles GUI input and passes input back to the calculator logic.

### Languages
This calculator is written exclusively in Delphi. It has many variants that compile the base Delphi classes into an Electron application, a web application, and a PWA without requiring programming in any other language.

### Techniques
#### TPanels as Buttons
Rather than using the TButton component for calculator buttons, this calculator uses TPanels.  The end result is indistinguishable from the design of the Windows 10 calculator buttons.

#### Transparency
GUI transparency was achieved by adjusting the alpha value of the main Calculator GUI window. 

#### Enum Operations
Rather than parsing an equation string to solve an equation, this calculator uses an enumerated type to represent operations and executes the relevant calculation according to the TOperatorType value passed from the GUI (forms.VCLCalculator.pas).

*interfaces.icalculatorinterface.pas*

`type TOperatorType = (None, Percent, OneOverX, XSquared, SquareRootX, Divide, Multiply, Subtract, Add);`

It also uses an enumerated type to define how to update the equation display.  This type is passed from the GUI according to which TPanel button is pressed.

`type TUpdateCalcDisplay = procedure of object;`

## Metrics

### Code Size
This calculator has 559 lines of code (without blank lines). The developer wrote 426 lines of code and RAD Studio generated the rest. Only 116 lines (27% of developer written lines) are needed to set up the GUI and connect it to the calculator logic.

### Files and Sizes
This calculator compiles to one, 2.4MB binary executable.

### Runtime Performance
This VCL calculator started up in 0.2433 seconds from a local filesystem and 0.3245 seconds from a network location.  It used 3.55MB of memory when idle and peaked at 12.58MB.

### Productivity
This calculator took approximately 3 hours to develop and test the core calculator functions.  Adding in Fluent UI and converting it to a PWA or Electron app took less than one hour each.
