
# Calculator Build Instructions in WPF

System Requirements:-
	Either Visual Studio 2017 Or 2019

## 1)Create new Project in Visual Studio:
Choose application Type: WPF App(.net Framework)
		
Note: architectural pattern is MVVM.

## 2) Design view.
### A)Go to MainWindow.Xaml.
Set Window Property value Like below
1. Title: CalCulator
2. Height: 510
3. Width : 550
4. MinHeight: 550
5. MinWidth: 370

### B)CalCulator is broken up into two sections. 

The top section which shows the equation entered and the number entered/result.
The bottom section contains input buttons for digits, mathematical operations, and functions. 

	
Then add grid(Grid Background : #E6E6E6)
Then add below code for buttons style:
add style in grid resources:
1. style : 
```
x:key="Digit" TargetType="Button"
Focusable = false
BorderThickness = 0.1
FontSize = 18
FontWeight = Bold
Foreground =black
Command = DigitButtonPressCommand
CommandParameter = RelativeSource={RelativeSource Self}, Path=Content
Background = #FAFAFA
IsPressed change button Background(Add Trigger):
<Trigger Property="IsPressed" Value="True">
	<Setter Property="Background" Value="#C6C5C5"/>
</Trigger>
IsMouseOver Change button Background(Add Template):
<Setter Property="Template">
<Setter.Value>
	<ControlTemplate TargetType="{x:Type Button}">
		<Border x:Name="border" Background="{TemplateBinding Background}" BorderBrush="#E0E0E0" BorderThickness="1">
			<ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
		</Border>
		<ControlTemplate.Triggers>
			<Trigger Property="IsDefaulted" Value="true">
				<Setter Property="BorderBrush" TargetName="border" Value="{DynamicResource {x:Static SystemColors.HighlightBrushKey}}"/>
			</Trigger>
			<Trigger Property="IsMouseOver" Value="True">
				<Setter Property="Background" Value="#E0E0E0"/>
				<Setter Property="BorderBrush" TargetName="border"  Value="#BAB8B8"/>
				<Setter Property="BorderThickness" TargetName="border"  Value="2"/>
			</Trigger>
		</ControlTemplate.Triggers>
	</ControlTemplate>
</Setter.Value>
</Setter>
```
			
2. style:
```
x:key="Actions" TargetType="Button"
Focusable = false
FontSize = 15
FontWeight = Normal
Foreground =black
Command = OperationButtonPressCommand
CommandParameter = RelativeSource={RelativeSource Self}, Path=Content
Background = #F0F0F0
IsPressed change button Background(Add Trigger):
	<Trigger Property="IsPressed" Value="True">
		<Setter Property="Background" Value="#C6C5C5/>
	</Trigger>
IsMouseOver Change button Background(Add Template):
	code same as digit template property:
		BorderBrush=#E0E0E0
		BorderThickness=1
	IsMouseOver:
		Background = #E0E0E0
		BorderBrush:#BAB8B8
		BorderThickness= 2
```
						     
						     
		In grid add 3 rows:
			 1)Height="1*"
			 2)Height="2*"
			 3)Height="7*"
				1)First Row:
					Add TextBlock:
						Text: Standard
						FontSize: 20
						FontWeight: SemiBold
				2)Second Row
					Add Grid:
						add 2 Rows:
						Add Two TextBox in each row
						A)First TextBox will display expression(Binding Expression)
						B)Second TextBox will display Result(Binding Display)		
						Property:
							IsReadOnly:True
							Background : Transparent 							
							BorderBrush: Transparent 
							BorderThickness: 0 								
							TextWrapping: WrapWithOverflow
								(Set All Property in textbox)
								
							Foreground: Black(Second textbox)	
							Foreground: LightSlateGray (First textbox)	
				3)Third Row:
					Add Grid:	
						In which add 6 rows and 4 Columns:
						
						Create Button
							(Add Style in Button):
						1)Button :(%, CE, C, Del, 1/x, x², ²√x, ÷, ×, -, +, +/-, .,Backspace)
							  Style="{StaticResource Actions}" 
								
						2)Button :(0 to 9)
							 Style="{StaticResource Digit}"
		 
						3)Button :(=)
							  style same as action But change Color
							  Background: #8FB7D7
							  IsMouseOver:Background: #498DC5
								  IsPressed:Background: #0062B1
						button binding
						Button:(CE, C, Backspace, +/-, .)
							command:DigitButtonPressCommand
						
						CommandParameter:
							Button "Backspace" = CommandParameter = del
							Button "x²" = CommandParameter = sqr
							Button "²√x" = CommandParameter = ²√x
							Button "CE" = CommandParameter = CE
							Button "C" = CommandParameter = C
							Button "+/-" = CommandParameter = +/-
							Button "." = CommandParameter = .	
		
Here the design part is completed.
 

## 2)Then create two class
	1)BaseViewModel:
		
		Inherit INotifyPropertyChanged and define the overridden method for Inherited interface.
	
	2)MainViewModel:
		
		Bind Xaml to viewmodel in xaml:
			<Window.DataContext>
				<viewmodel:MainViewModel/>
			</Window.DataContext>
		
		Create two command:	
			1)DigitButtonPressCommand
			2)OperationButtonPressCommand
		
		Create property:		
			1)Display
			2)Expression
			3)FirstOperand
			4)SecondOperand
			5)Operation
			6)LastOperation
				(Note: All property data-type : string)
			
		Private member:
			private bool IsOperation = false;
			private string result = string.Empty;
			private string currentOperation = string.Empty;
			private bool IsBODMASOperation = false;

		In constructor 
			DigitButtonPressCommand = new RelayCommand<string>(OnDigitButtonPress);
															(same second command)				
			Display = "0";
            Expression = string.Empty;	
				
		Create three mthods
			1)OnDigitButtonPress
			2)OnOperationButtonPress
			3)CalculateResult
			
		A)OnDigitButtonPress Method(digit):-
			(using switch-case)
			1)Button "0 To 9"(default):
				if (IsOperation && currentOperation == "=")
				{
					Display = "0";
					Expression = string.Empty;
					FirstOperand = string.Empty;
				}
				if (Display == "0" || IsOperation)
					Display = digit;
				else
					Display = Display + digit;
							
			2)Button "C": 				
				Display = "0";
				result = "0";
				Expression = string.Empty;
				FirstOperand = string.Empty;
				SecondOperand = null;
				LastOperation = string.Empty;
				Operation = string.Empty;
		
			3)Button "CE":
				if (LastOperation == "=")
				{
					Display = "0";
					result = "0";
					Expression = string.Empty;
					FirstOperand = string.Empty;
					SecondOperand = null;
					LastOperation = string.Empty;
					Operation = string.Empty;
				}
				else
				{
					Display = "0";
					result = string.Empty;
				}
				
			4)Button "+/-":
				if (Display.Length >= 1)
					Display = (Convert.ToDouble(Display) * -1).ToString();
					
			5)Button "del":(Backspace)		
				if (Display.Length > 1)
				{
					if (!string.IsNullOrEmpty(LastOperation))
					{
						if (LastOperation != "=")
						{
							if (LastOperation != "+" && LastOperation != "-" && LastOperation != "×" && LastOperation != "÷")
								Display = Display.Substring(0, Display.Length - 1);
							else
							{
								if (!IsOperation)
									Display = Display.Substring(0, Display.Length - 1);
								else
									return;
							}
						}
						else
							Expression = string.Empty;
					}
					else
					{
						Display = Display.Substring(0, Display.Length - 1);
					}
				}
				else Display = "0";
				
			Assign "IsOperation":-
			("IsOperation" is flag for check last expression value is "Digit" or "Operation")
				IsOperation = false

			Assign "IsBODMASOperation":-
			("IsBODMASOperation" is flag for check last operation is plus,minus,divide and multiplication)
			IsBODMASOperation = false;
		
		(B)Method OnOperationButtonPress(operation):
		
			Assign "Operation" in "currentOperation" local variable:
				currentOperation = operation[method parameter]
				
			Check "FirstOperand is IsNullOrEmpty or "LastOperation" is "=" then assign "Display" into "FirstOperand" and assign "Operation" into "LastOperation"
				if (string.IsNullOrEmpty(FirstOperand) || LastOperation == "=")
				{
					FirstOperand = Display;
					Operation = operation == "=" ? Operation : operation;
					LastOperation = operation;
					IsBODMASOperation = false;
				}
				
			When "FirstOperand" is not null or empty then
			assign "Display" into "SecondOperand" and then call CalculateResult method	
				else
				{
					if (!IsBODMASOperation || operation == "sqr" || operation == "√" || operation == "1/x" || operation == "%")
                    {
						SecondOperand = Display;
						Operation = operation == "=" ? LastOperation : operation;
						CalculateResult();
						if (Operation != "sqr" && Operation != "%" && Operation != "√" && Operation != "1/x")
						{
							LastOperation = operation;
							FirstOperand = result;
							IsBODMASOperation = true;
						}
						if (result == "Infinity")
							Display = "Overflow";
						else
							Display = result;
					}
				}
				
			When "FirstOperand" is not NullOrEmpty then call CalculateResult method".
				if (Operation == "sqr" || Operation == "√" || Operation == "1/x" || Operation == "%")
				{
					CalculateResult();
					Display = result;
				}
				
			Then assign value in to "Expression" (using switch case):
				First check "SecondOperand" IsNullOrEmpty :
					var number = string.IsNullOrEmpty(SecondOperand) ? FirstOperand : SecondOperand;
					
				(using switch case)
					When "Operation" Value is :
					"sqr":
						Expression = Expression + operation + "( " + number + " )";
					"√":	
						Expression = Expression + operation + "( " + number + " )";
					"%":
						if (result == "0" || result == "Infinity")
						{
							Display = "0";
							result = "0";
							Expression = string.Empty;
							FirstOperand = string.Empty;
							SecondOperand = null;
							LastOperation = string.Empty;
							Operation = string.Empty;
						}
						else
							Expression = Expression + result;
					"1/x":		
						Expression = 1 + "/(" + FirstOperand + ")";	
					and default:
						if (IsOperation == false)
						{
							Expression = Expression + number + operation;
						}
						var str = Expression.Last();
						if (str == Convert.ToChar(")"))
						{
							Expression = Expression + operation;
						}
						
				Add last click "Operation" in the "Exception":-
					if (Expression.Length > 0)
					{
						var str = Expression.Last();
						if (str == Convert.ToChar("=") || str == Convert.ToChar("+") || str == Convert.ToChar("-")
							|| str == Convert.ToChar("×") || str == Convert.ToChar("÷"))
						{
							Expression = Expression.Substring(0, Expression.Length - 1) + operation;
						}
					}
					
				Then Clear "Operation" value:  
					Operation = string.Empty;
				
				Assign "IsOperation":-
				("IsOperation" is flag for check last expression value is "Digit" or "Operation")	
					IsOperation = true;
		
		(C)Method CalculateResult(using switch-case):-
		
			Check "SecondOperand" IsNullOrEmpty:
			
				var number = string.IsNullOrEmpty(SecondOperand) ? FirstOperand : SecondOperand;
				if (Operation == "sqr" || Operation == "%" || Operation == "√" || Operation == "1/x")
				{
					oper[local variable] = Operation;
				}
				else
					oper = Operation == "=" ? Operation : LastOperation;
				
			(using switch case)
			1)Button:(+, -, ÷, ×)
				if (!string.IsNullOrEmpty(SecondOperand))
					result = (Convert.ToDouble(FirstOperand) + Convert.ToDouble(SecondOperand)).ToString();
			2)Button "%":
				try
				{
					result = Math.Round(Convert.ToDouble(FirstOperand) * Convert.ToDouble(SecondOperand) / 100).ToString();
					IsBODMASOperation = false;
				}
				catch (Exception e)
				{
					result = "0";
				}
			3)Button "1/x":
				result = (1 / (Convert.ToDouble(Display))).ToString();
				IsBODMASOperation = false;

			8)Button "sqr":
				result = Math.Pow(Convert.ToDouble(number), 2).ToString();
				IsBODMASOperation = false;

			4)Button "√":
				result = Math.Sqrt(Convert.ToDouble(Display)).ToString();
				IsBODMASOperation = false;
		
Code completed check calCulator work or not.

## Key Bindings
Apply key binding in Xaml(key binding apply in Window.InputBindings):
1. 
		Keys:NumPad1,NumPad2,NumPad3,NumPad4,NumPad5,NumPad6,NumPad7,NumPad8,NumPad9,NumPad0,D1,D2,D3,D4,D5,D6,D7,D8,D9,D0,
			Backspace,Esc,Delete,OemPeriod,Decimal
		Command:DigitButtonPressCommand	
		CommandParameter:
				key :- NumPad1,NumPad2,NumPad3,NumPad4,NumPad5,NumPad6,NumPad7,NumPad8,NumPad9,NumPad0	
				parameter:-0 to 9
				
				key :- D1,D2,D3,D4,D5,D6,D7,D8,D9,D0	
				parameter:-0 to 9	
				
				key 			parameter
				Backspace		del	
				Esc				C
				Delete			CE
				OemPeriod		.
				Decimal			.
2.
		Keys:Add,OemPlus,OemMinus,Subtract,Multiply,Divide,Enter,
		Command:OperationButtonPressCommand
		CommandParameter:
			key 			parameter
			OemPlus			+
			Add				+
			OemMinus		-
			Subtract		-
			Multiply		*
			Divide			/
			Enter			=
3.
		Key:D5
		Modifiers:Shift
		Command:OperationButtonPressCommand	
		CommandParameter:
			key 			parameter
			D5				%
			
			
			
