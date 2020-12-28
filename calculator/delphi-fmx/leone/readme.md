# Calculator Analysis 

![Leone Calculator Appearance](https://github.com/Embarcadero/ComparisonResearch/blob/main/calculator/delphi-fmx/leone/Leone_FMX%20Calculator_Appearance.PNG)

## Adherence to the Specification

### GUI
**90% adherence** to the specification. This calculator has the following deviations:
- Some operation buttons and +/- button do not look the same
- Transparency exists but lacks the "blur" effect in the specification. This effect was unachievable within the 5 hours specified.

### Functionaity
**95% adherence** to the specification. This calculator has the following deviations:
- Displays more decimal digits than the Windows 10 calculator and prints an ellipse ("...") when the value is larger than the text space.  This is a default Delphi behavior.
- Percentage operation does not display the correct value in the Answer field following the Percent button press.  The calculated answer is correct but display functionality deviates from Windows 10 calculator behavior.

## Code Design

### Decoupling
The GUI is decoupled from the logic ...

### Languages
This calculator is written exclusively in Delphi.


## Metrics

### Code Size
Number of lines

### Files and Sizes
This calculator compiles to one, 9.7MB binary executable.

### Runtime Performance
Something about performance that doesn't repeat the paper too much.
