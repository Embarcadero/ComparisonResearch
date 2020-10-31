# Calculator
October 29, 2020

## Overview
The goal of this Calculator project is to build a generic calculator that looks and functions nearly identically to the standard view of the Windows 10 calculator. This is a prototype! The emphasis of this project is on the lessons learned during the development process and documentation phase. The end result does not require a huge amount of polish but should look reasonably similar and function as closely as possible unless otherwise noted in this specification.

Your goal while building the Calculator is to explore the strengths and weaknesses of the framework you are using. The app should be built completely once to figure out your approach.  Once complete, build the app again from scratch while recording your screen.  Finally, document the app creation process in a step-by-step manner (similar to a recipe - what would someone else need to know to build the app in its entirety - configuration, code, testing, etc.), noting where your framework/language/toolset helps or hinders the build process.

## Requirements
### Theme
The Calculator should feature a look similar to the below. Note the brighter color palette for number, digit, and sign buttons, darker pallet for operator/function buttons, and dark grey pallet for the display field.  The “equals” button is a cornflower blue shade.  All buttons but the equals button change to a darker grey shade when the mouse rolls over and becomes darker again when clicked.  The equals button has the same behavior but in blue shades.  
Note that the window and controls are semi transparent.

![](https://github.com/Embarcadero/ComparisonResearch/blob/main/calculator/win10calculator.png)

### Transparency
The calculator window should be semi-transparent if it will not take more than 5 hours to add that feature.

### Layout
The goal here is to get close to the layout of the Windows calculator. It is broken up into two sections. The top section which shows the equation entered and the number entered/result.  The bottom section contains input buttons for digits, mathematical operations, and functions. 

### Responsive
The Calculator interface should resize automatically to the size of the window that contains it.  Changing the width/height should not result in blank areas or awkward spaces between buttons.

### Memory Buttons
The memory buttons are not required.

### Functions
The calculator must imitate Windows 10 calculator function to the maximum extent possible.  The following is not an all-inclusive list of behaviors:
- Does not respect operator precedence.  Operands are calculated from left-to-right.
- If a number is entered and “=” pressed, it appears in the Equation View as the number with an equals sign.  Ex. “0 =”
- After an operator (+, -, *, /) is clicked, the first operand remains visible until a new number is entered for the second operand.
- Numbers and operators can be “chained” and appear in sequential order in the Equation View.  The running result is displayed in the Entry/Answer View (largest font) whenever a new operator is clicked.  
- If the equals button is clicked after already solving an equation, the last operation is applied to the current result and the Equation View and Entry/Answer Views are updated.
- The backspace button will remove one digit at a time from the current number in the Entry/Answer View.  If the equation has been solved, it will erase the Equation View.
- The ‘CE’ button will completely erase the current number in the Entry/Answer View.  If the equation has been solved, it will clear both the Equation View and the Entry/Answer View.
- The ‘C’ button will fully reset the calculator Views whenever pressed.
- The square, square root, and 1/x buttons will immediately act on the current number in the Entry/Answer field so that the result is displayed and will update the equation in the Equation View..
- The change sign button will immediately act on the current number in the Entry/Answer field so that the result is displayed.
- The percent button will behave in accordance with the Microsoft algorithm found here.

## Deliverables
### Project Items

1. Complete source code for your working calculator.  Include a compiled executable if applicable or instructions for executing the code if not.
2. A video capture of the second build process.  This must be in real-time (not sped up) and executed manually (without auto-typing or other speed features).  The intent is to get a realistic view of the effort required to make this calculator by a competent programmer.
3. A document with step-by-step instructions that walk someone unfamiliar with your development environment, tools, and language through the process of building this calculator to its full functionality.  This document can be a .docx, .pdf, or Google Document format.  Markdown usage is preferred.

### Iterative Feedback
Please provide feedback to us during the development process so we can help speed up the development. We have many many years of experience and are here to help you get the project done as fast as possible.

## Helpful Tips
### Delphi Specific
If building the Delphi version you can reference [this project](https://delphi.fandom.com/wiki/Simple_Calculator_Tutorial).

### Electron Specific

For basic calculator functionality it should be enough to create this as a pure web app in a sandboxed browser window. Including clipboard functionality.

You can reference [this project](https://www.youtube.com/watch?v=La87CRt6CpY).

#### Electron Forge

To abstract away some of the common headaches of distributing and updating an application. Whether it be through an "app store" or not.
[Electron Forge](https://www.electronforge.io) could be used as it is very easy to get started with and it provides a lot of features out of the box.
Updates can be published through either update.electronjs.org (if the application is public and meets all the criteria) or custom update servers.
[Electron Forge](https://www.electronforge.io) provides an easy to use system for either one (publish targets).

To get started:

```sh
npx create-electron-app calculator
```
