# Directions to Recreate the Windows 10 Calculator Using WPF. 

### Requirements:-
   Either Visual Studio 2017 or 2019
   <br/>.NET Version 5 or above 

**Running the compiled binary requires GalaSoftMvvmLight.dll in the same folder as the Calculator.exe file.**

## Initial Setup
- Open Visual studio Editor.
- Go to "File" => "New" => "Project".
- Select "Wpf app (.NET framework)" from New Project dialog.
- Give the project name "Calculator" then click OK.

- The Project will contain three files:
1. MainWindow.xaml
2. App.xaml
3. App.config

We have to add two packages to the project using the NuGet Package Manager.
1. Right click the Solution in the Solution Explorer
2. Select "Manage NuGet Packages for Solution"
3. Select "Browse" and search for "MVVMLight"
4. Install for the Calculator solution.
5. Repeat for the package name "System.ComponentModel.Annotations"
6. MVMMLight adds a class and code we don't need.  
   1. Right click and delete the "ViewModelLocator.cs" class in the Solution Explorer.
   2. In "App.xaml", delete ```     <ResourceDictionary>   <vm:ViewModelLocator x:Key="Locator" d:IsDataSource="True" xmlns:vm="clr-namespace:Calculator.ViewModel" />  </ResourceDictionary>``` 

<br/><div style="text-align:center">
<a href="https://ibb.co/mhMpSbj"><img src="https://i.ibb.co/mhMpSbj/Mvvm-Light-Installation.png" alt="Mvvm-Light-Installation" border="0"></a></div>

## Logic Classes
Create a new class named ***"BaseViewModel"*** in the "ViewModel" folder following these instructions:<br/><div style="text-align:center">
<a href="https://ibb.co/vdvCXg4"><img src="https://i.ibb.co/vdvCXg4/Datacontextfile.png" alt="Datacontextfile" border="0"></a></div><br/>
***"BaseViewModel"*** and ***"MainViewModel"*** will contain the calculator logic.

### Editing BaseViewModel.cs
Paste the following code into ***"BaseViewModel.cs"***
```
 using System;
 using System.Collections.Generic;
 using System.ComponentModel;
 using System.ComponentModel.DataAnnotations.Schema;
 using System.Linq;
 using System.Text;
 using System.Threading.Tasks;

 namespace Calculator.ViewModel
 {
     public class BaseViewModel:INotifyPropertyChanged
     {
         public BaseViewModel()
         {
             this.PropertyChanged += new PropertyChangedEventHandler(OnNotifiedOfPropertyChanged);
         }

         public event PropertyChangedEventHandler PropertyChanged;

         protected void OnPropertyChanged(String propertyName)
         {
             if (this.PropertyChanged != null)
                 this.PropertyChanged(this, new PropertyChangedEventArgs(propertyName));
         }

         private void OnNotifiedOfPropertyChanged(object sender, PropertyChangedEventArgs e)
         {
             if (e != null && !String.Equals(e.PropertyName, "IsChanged", StringComparison.Ordinal))
             {
                 this.IsChanged = true;
             }
         }

         private bool _notifyingObjectIsChanged;
         private readonly object _notifyingObjectIsChangedSyncRoot = new Object();
         [NotMapped]
         public bool IsChanged
         {
             get
             {
                 lock (_notifyingObjectIsChangedSyncRoot)
                 {
                     return _notifyingObjectIsChanged;
                 }
             }

             set
             {
                 lock (_notifyingObjectIsChangedSyncRoot)
                 {
                     if (!Boolean.Equals(_notifyingObjectIsChanged, value))
                     {
                         _notifyingObjectIsChanged = value;

                         this.OnPropertyChanged("IsChanged");
                     }
                 }
             }
         }
      }
  }
```

### Editing MainViewModel.cs
Paste the following code into ***"MainViewModel.cs"***
```
using GalaSoft.MvvmLight.Command;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Input;

namespace Calculator.ViewModel
{
    public class MainViewModel : BaseViewModel
    {
        #region Private member
        private bool IsOperation = false;
        private string result = string.Empty;
        private string _display;
        private string _expression;
        private string _firstOperand;
        private string _lastOperation;
        private string _secondOperand;
        private string _operation;
        private string currentOperation = string.Empty;
        private bool IsBODMASOperation = false;
        private List<string> UsedOperatorInSequence { get; set; } = new List<string>();

        #endregion

        #region Constructor
        public MainViewModel()
        {
            Display = "0";
            Expression = string.Empty;

            DigitButtonPressCommand = new RelayCommand<string>(OnDigitButtonPress);
            OperationButtonPressCommand = new RelayCommand<string>(OnOperationButtonPress);
        }

        #endregion

        #region public property
        public string Display
        {
            get { return _display; }
            set { _display = value; OnPropertyChanged(nameof(Display)); }
        }

        public string Expression
        {
            get { return _expression; }
            set { _expression = value; OnPropertyChanged(nameof(Expression)); }
        }

        public string FirstOperand
        {
            get { return _firstOperand; }
            set { _firstOperand = value; OnPropertyChanged(nameof(FirstOperand)); }
        }

        public string LastOperation
        {
            get { return _lastOperation; }
            set { _lastOperation = value; }
        }

        public string SecondOperand
        {
            get { return _secondOperand; }
            set { _secondOperand = value; }
        }

        public string Operation
        {
            get { return _operation; }
            set { _operation = value; }
        }
        #endregion

        #region Command
        public ICommand DigitButtonPressCommand { get; set; }
        public ICommand OperationButtonPressCommand { get; set; }
        #endregion

        #region Private Method
        private void OnDigitButtonPress(string digit)
        {
            switch (digit)
            {
                case "C":
                    Display = "0";
                    result = "0";
                    Expression = string.Empty;
                    FirstOperand = string.Empty;
                    SecondOperand = null;
                    LastOperation = string.Empty;
                    Operation = string.Empty;
                    UsedOperatorInSequence = new List<string>();
                    break;
                case "Del":
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
                    break;
                case "+/-":
                    if (Display.Length >= 1)
                        Display = (Convert.ToDouble(Display) * -1).ToString();
                    break;
                case ("CE"):
                    if (LastOperation == "=")
                    {
                        Display = "0";
                        result = "0";
                        Expression = string.Empty;
                        FirstOperand = string.Empty;
                        SecondOperand = null;
                        LastOperation = string.Empty;
                        UsedOperatorInSequence = new List<string>();
                        Operation = string.Empty;
                    }
                    else
                    {
                        Display = "0";
                        result = string.Empty;
                    }
                    break;
                default:
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
                    break;

            }
            IsOperation = false;
            IsBODMASOperation = false;
        }
        
        private void OnOperationButtonPress(string operation)
        {
            try
            {
                if (operation != "sqr" && operation != "√" && operation != "1/x" && operation != "%")
                {
                    UsedOperatorInSequence.Add(operation);
                }
                var lastOperator = UsedOperatorInSequence.LastOrDefault(s => s != operation);
                currentOperation = operation;
                if (string.IsNullOrEmpty(FirstOperand) || LastOperation == "=")
                {
                    if (operation == "=")
                    {
                        Operation = lastOperator;
                    }
                    else
                    {
                        Operation = operation == "=" ? Operation : operation;
                    }
                    FirstOperand = Display;
                    LastOperation = operation;
                    if (Operation == "sqr" || Operation == "√" || Operation == "1/x" || Operation == "%" || LastOperation == "=")
                    {
                        CalculateResult();
                        Display = result;
                    }
                    IsBODMASOperation = true;
                }
                else
                {
                    if (!IsBODMASOperation || operation == "sqr" || operation == "√" || operation == "1/x" || operation == "%")
                    {
                        SecondOperand = Display;
                        Operation = operation == "=" ? LastOperation : operation;
                        CalculateResult();
                    }
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
                var number = string.IsNullOrEmpty(SecondOperand) ? FirstOperand : SecondOperand;
                switch (operation)
                {
                    case ("sqr"):
                        if (operation == LastOperation || LastOperation == "sqr" || LastOperation == "√" || LastOperation == "1/x" || LastOperation == "%")
                        {
                            Expression = string.Empty;
                            FirstOperand = string.Empty;
                            SecondOperand = null;
                            Expression = Expression + operation + "( " + number + " )";
                        }
                        else
                            Expression = Expression + operation + "( " + number + " )";
                        break;
                    case ("√"):
                        if (operation == LastOperation || LastOperation == "sqr" || LastOperation == "√" || LastOperation == "1/x" || LastOperation == "%")
                        {
                            Expression = string.Empty;
                            FirstOperand = string.Empty;
                            SecondOperand = null;
                            Expression = Expression + operation + "( " + number + " )";
                        }
                        else
                            Expression = Expression + operation + "( " + number + " )";
                        break;
                    case ("%"):
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
                        {
                            var lastChar = Expression.Last();
                            if (lastChar == Convert.ToChar("="))
                                Expression = result;
                            else
                            {
                                if (lastChar == Convert.ToChar(LastOperation))
                                {
                                    Expression = Expression + result;
                                }
                                else
                                {
                                    var lastIndex = Expression.LastIndexOf(LastOperation);
                                    Expression = Expression.Substring(0, lastIndex + 1) + result;
                                }
                            }
                        }
                        break;
                    case ("1/x"):
                        if (operation == LastOperation || LastOperation == "sqr" || LastOperation == "√" || LastOperation == "1/x" || LastOperation == "%")
                        {
                            Expression = string.Empty;
                            FirstOperand = string.Empty;
                            SecondOperand = null;
                            Expression = 1 + "/(" + number + ")";
                        }
                        else
                            Expression = Expression + 1 + "/(" + number + ")";
                        break;

                    default:
                        if (IsOperation == false)
                        {
                            Expression = Expression + number + operation;
                        }
                        else
                        {
                            var str = Expression.Last();
                            if (str == Convert.ToChar(")"))
                            {
                                Expression = Expression + operation;
                            }
                            else if (str == Convert.ToChar("="))
                            {
                                if (lastOperator == "=")
                                {
                                    Expression = FirstOperand + LastOperation;
                                }
                                else
                                    Expression = FirstOperand + Operation + number + operation;
                            }
                        }
                        break;
                }
                if (Expression.Length > 0)
                {
                    var str = Expression.Last();
                    if (str == Convert.ToChar("=") || str == Convert.ToChar("+") || str == Convert.ToChar("-")
                        || str == Convert.ToChar("×") || str == Convert.ToChar("÷"))
                    {
                        Expression = Expression.Substring(0, Expression.Length - 1) + operation;
                    }
                }
            }
            catch (Exception e)
            {
                Display = e.ToString();
            }
            Operation = string.Empty;
            IsOperation = true;
        }

        public void CalculateResult()
        {
            var oper = string.Empty;
            try
            {
                var number = string.IsNullOrEmpty(SecondOperand) ? FirstOperand : SecondOperand;
                if (Operation == "sqr" || Operation == "%" || Operation == "√" || Operation == "1/x" || LastOperation == "=")
                {
                    oper = Operation;
                }
                else
                    oper = Operation == "=" ? Operation : LastOperation;
                switch (oper)
                {
                    case ("+"):
                        if (!string.IsNullOrEmpty(SecondOperand))
                            result = (Convert.ToDouble(FirstOperand) + Convert.ToDouble(SecondOperand)).ToString();
                        break;

                    case ("-"):
                        if (!string.IsNullOrEmpty(SecondOperand))
                            result = (Convert.ToDouble(FirstOperand) - Convert.ToDouble(SecondOperand)).ToString();
                        break;

                    case ("×"):
                        if (!string.IsNullOrEmpty(SecondOperand))
                            result = (Convert.ToDouble(FirstOperand) * Convert.ToDouble(SecondOperand)).ToString();
                        break;

                    case ("÷"):
                        if (!string.IsNullOrEmpty(SecondOperand))
                            result = (Convert.ToDouble(FirstOperand) / Convert.ToDouble(SecondOperand)).ToString();
                        break;
                    case ("%"):
                        try
                        {
                            result = (Convert.ToDouble(FirstOperand) * Convert.ToDouble(SecondOperand) / 100).ToString();
                            IsBODMASOperation = false;
                        }
                        catch (Exception e)
                        {
                            result = "0";
                        }
                        break;
                    case ("1/x"):
                        var tempResult = (1 / (Convert.ToDouble(Display)));
                        if (double.IsInfinity(tempResult))
                        {
                            result = "Cannnot divide by zero";
                        }
                        else
                        {
                            result = tempResult.ToString();
                        }
                        IsBODMASOperation = false;
                        break;
                    case ("sqr"):
                        result = Math.Pow(Convert.ToDouble(number), 2).ToString();
                        IsBODMASOperation = false;
                        break;
                    case ("√"):
                        result = Math.Sqrt(Convert.ToDouble(Display)).ToString();
                        IsBODMASOperation = false;
                        break;

                }
            }
            catch (Exception e)
            {
                result = "Error whilst calculating";
                throw;
            }

        }

        #endregion
    }
}
```



## Calculator UI Design
### Setting Up MainWindow.xaml

Add a namespace for datacontext class in MainWindow: `xmlns:viewmodel="clr-namespace:Calculator.ViewModel"`

Change the MainWindow title and size according to this depiction:
<div style="text-align:center">
<a href="https://ibb.co/yNcfdPF"><img src="https://i.ibb.co/yNcfdPF/Data-Context-Name-Space.png" alt="Data-Context-Name-Space" border="0"></a></div><br/>

Build the solution then add the datacontext below to MainWindow.xaml:
```
<Window.DataContext>
   <viewmodel:MainViewModel/>
</Window.DataContext>
```

### Keybindings
Add keybindings to handle keypress event with calculator.
```
   <Window.InputBindings>
      <KeyBinding Key="NumPad1" 
      Command="{Binding DigitButtonPressCommand}" 
      CommandParameter="1"/>

      <KeyBinding Key="NumPad2" 
      Command="{Binding DigitButtonPressCommand}" 
      CommandParameter="2"/>

      <KeyBinding Key="NumPad3" 
      Command="{Binding DigitButtonPressCommand}" 
      CommandParameter="3"/>

      <KeyBinding Key="NumPad4" 
      Command="{Binding DigitButtonPressCommand}" 
      CommandParameter="4"/>

      <KeyBinding Key="NumPad5" 
      Command="{Binding DigitButtonPressCommand}" 
      CommandParameter="5"/>

      <KeyBinding Key="NumPad6" 
      Command="{Binding DigitButtonPressCommand}" 
      CommandParameter="6"/>

      <KeyBinding Key="NumPad7"
      Command="{Binding DigitButtonPressCommand}" 
      CommandParameter="7"/>

      <KeyBinding Key="NumPad8" 
      Command="{Binding DigitButtonPressCommand}" 
      CommandParameter="8"/>

      <KeyBinding Key="NumPad9" 
      Command="{Binding DigitButtonPressCommand}" 
      CommandParameter="9"/>

      <KeyBinding Key="NumPad0" 
      Command="{Binding DigitButtonPressCommand}" 
      CommandParameter="0"/>

      <KeyBinding Key="D1" 
      Command="{Binding DigitButtonPressCommand}" 
      CommandParameter="1"/>

      <KeyBinding Key="D2" 
      Command="{Binding DigitButtonPressCommand}" 
      CommandParameter="2"/>

      <KeyBinding Key="D3" 
      Command="{Binding DigitButtonPressCommand}" 
      CommandParameter="3"/>

      <KeyBinding Key="D4" 
      Command="{Binding DigitButtonPressCommand}" 
      CommandParameter="4"/>

      <KeyBinding Key="D5" 
      Command="{Binding DigitButtonPressCommand}" 
      CommandParameter="5"/>

      <KeyBinding Key="D6" 
      Command="{Binding DigitButtonPressCommand}" 
      CommandParameter="6"/>

      <KeyBinding Key="D7" 
      Command="{Binding DigitButtonPressCommand}" 
      CommandParameter="7"/>

      <KeyBinding Key="D8" 
      Command="{Binding DigitButtonPressCommand}"
      CommandParameter="8"/>

      <KeyBinding Key="D9" 
      Command="{Binding DigitButtonPressCommand}" 
      CommandParameter="9"/>

      <KeyBinding Key="D0" 
      Command="{Binding DigitButtonPressCommand}" 
      CommandParameter="0"/>

      <KeyBinding Key="Backspace" 
      Command="{Binding DigitButtonPressCommand}" 
      CommandParameter="Del"/>

      <KeyBinding Key="Esc" 
      Command="{Binding DigitButtonPressCommand}" 
      CommandParameter="C"/>

      <KeyBinding Key="Delete" 
      Command="{Binding DigitButtonPressCommand}" 
      CommandParameter="CE"/>

      <KeyBinding Key="Add" 
      Command="{Binding OperationButtonPressCommand}"
       CommandParameter="+"/>

      <KeyBinding Key="OemPlus" 
      Command="{Binding OperationButtonPressCommand}" 
      CommandParameter="="/>

      <KeyBinding Key="OemMinus" 
      Command="{Binding OperationButtonPressCommand}" 
      CommandParameter="-"/>

      <KeyBinding Key="Subtract" 
      Command="{Binding OperationButtonPressCommand}" 
      CommandParameter="-"/>

      <KeyBinding Key="Multiply" 
      Command="{Binding OperationButtonPressCommand}" 
      CommandParameter="×"/>

      <KeyBinding Key="Divide" 
      Command="{Binding OperationButtonPressCommand}" 
      CommandParameter="÷"/>

      <KeyBinding Key="Enter" 
      Command="{Binding OperationButtonPressCommand}" 
      CommandParameter="="/>

      <KeyBinding Modifiers="Shift" Key="D5"
       Command="{Binding OperationButtonPressCommand}" 
       CommandParameter="%"/>

      <KeyBinding Key="OemPeriod" 
      Command="{Binding DigitButtonPressCommand}" 
      CommandParameter="."/>

      <KeyBinding Key="Decimal" 
      Command="{Binding DigitButtonPressCommand}" 
      CommandParameter="."/>

</Window.InputBindings>
```

### Setting up the Main Grid
By default the mainwindow.xaml will contain the below code.
```
<Grid>

</Grid>
```
We will refer to this as the ***"Main Grid"*** 

Set the Main Grid ***(Property)*** Background to color "#E6E6E6" (just set the property don't copy same code in MainGrid)
```
<Grid Background="#E6E6E6">

</Grid>
```

### Button Styles
To create button like Windows calculator we have to customize some button style in side the "maingrid" resource. We have to create two types of style: one for the digit buttons and a second for the action buttons.

Add resource inside "MainGrid"
```
<Grid.Resources>

</Grid.Resources>
```

Add the style code below inside the grid resource:
```
<Style x:Key="Digit" TargetType="{x:Type Button}">
    <Setter Property="Focusable" Value="False"/>
    <Setter Property="BorderThickness" Value="0.1"></Setter>
    <Setter Property="FontSize" Value="18"></Setter>
    <Setter Property="FontFamily" Value="Dubai"></Setter>
    <Setter Property="FontWeight" Value="Bold"></Setter>
    <Setter Property="Foreground" Value="Black"></Setter>
    <Setter Property="Command" Value="{Binding DigitButtonPressCommand}"/>
    <Setter Property="CommandParameter" Value="{Binding RelativeSource={RelativeSource Self}, Path=Content}"/>
    <Setter Property="Background" Value="#FAFAFA"/>
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
    <Style.Triggers>
        <Trigger Property="IsPressed" Value="True">
            <Setter Property="Background" Value="#C6C5C5"/>
        </Trigger>
    </Style.Triggers>
</Style>
<Style x:Key="Actions" TargetType="{x:Type Button}">
    <Setter Property="Focusable" Value="False"/>
    <Setter Property="FontWeight" Value="Normal"></Setter>
    <Setter Property="FontSize" Value="15"></Setter>
    <Setter Property="Foreground" Value="Black"></Setter>
    <Setter Property="Command" Value="{Binding OperationButtonPressCommand}"/>
    <Setter Property="CommandParameter" Value="{Binding RelativeSource={RelativeSource Self}, Path=Content}"/>
    <Setter Property="Background" Value="#F0F0F0"/>
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
    <Style.Triggers>
        <Trigger Property="IsPressed" Value="True">
            <Setter Property="Background" Value="#C6C5C5"/>
        </Trigger>
    </Style.Triggers>
</Style>
```

### Main Grid Layout
The main grid will be split into 3 rows, each having a grid resource. Please refer the attached screen shot to understand the structure of main grid.
<div style="text-align:center">
<a href="https://ibb.co/gTpyC5g" >
<img src="https://i.ibb.co/gTpyC5g/Main-Grid-Structure.png" alt="Main-Grid-Structure"/></a>
</div>


Copy this code in the Main Grid block to create 3 rows:
```

<Grid.RowDefinitions>
   <RowDefinition Height="1*"/>
   <RowDefinition Height="2*"/>
   <RowDefinition Height="7*"/>
</Grid.RowDefinitions>
```
Create the ***Standard*** Label in First row.  Must be after the Grid.RowDefinitions code.
`<TextBlock Text="Standard" FontSize="20" Grid.Row="0" FontWeight="SemiBold" Margin="20 10 0 0"/>`


### Setting up the ***displayGrid***
Create a container for display portion in Second Row
```
<Grid Grid.Row="1" Name="displayGrid">
</Grid>
```

The displayGrid will be divided into two rows:
<div style="text-align:center"><a href="https://ibb.co/Lr4HMh4"><img src="https://i.ibb.co/Lr4HMh4/Display-Grid.png" alt="Display-Grid" border="0"></a></div>

Type this code to create 3 rows in-side the display grid:
```

<Grid.RowDefinitions>
       <RowDefinition Height="*"/>
       <RowDefinition Height="2*"/>
</Grid.RowDefinitions>
```

Create the ***Input*** Textblock in the first row with the name "InputTextBox":
```
 <TextBox Grid.Row="0"
      x:Name="InputTextBox"   
      IsReadOnly="True"                
      Background="Transparent"
      BorderBrush="Transparent"
      BorderThickness="0" 
      TextWrapping="WrapWithOverflow"
      Foreground="LightSlateGray"
      Text="{Binding Expression,
      UpdateSourceTrigger=PropertyChanged}" 
      TextAlignment="Right" FontSize="15">
 </TextBox>
```

Create the ***Display*** Textblock in the second row with the name "DisplayTextBox":
```
 <TextBlock 
      x:Name="DisplayTextBox" 
      Grid.Row="1"  
      Background="Transparent" 
      TextWrapping="WrapWithOverflow" 
      FontSize="45" 
      FontWeight="Bold" 
      TextAlignment="Right" 
      Text="{Binding Display, 
      UpdateSourceTrigger=PropertyChanged}">
  </TextBlock>
```

### Setting up the ***buttonGrid***
Create a container for button portion in Third Row
```
<Grid Grid.Row="2" Name="buttonsGrid">
</Grid>
```

buttonGrid will be divided into six rows and four columns. Please review the below link to check positions of buttons in the buttonGrid.
<div style="text-align:center">
<a href="https://ibb.co/VggCWz5"><img src="https://i.ibb.co/VggCWz5/number-Grid-Grid-Lines.png" alt="number-Grid-Grid-Lines" border="0"></a></div>

Type the code below to create six rows and four columns inside the display grid:
```
 <Grid.RowDefinitions>
       <RowDefinition/>
       <RowDefinition/>
       <RowDefinition/>
       <RowDefinition/>
       <RowDefinition/>
       <RowDefinition/>
   </Grid.RowDefinitions>
   <Grid.ColumnDefinitions>
       <ColumnDefinition/>
       <ColumnDefinition/>
       <ColumnDefinition/>
       <ColumnDefinition/>
   </Grid.ColumnDefinitions>
```

Now add each button to a specific position in "buttongrid".
```
<Button Name="buttonPercentage" Content="%" Style="{StaticResource Actions}" ></Button>
<Button Name="buttonCE" Content="CE" Grid.Column="1" Style="{StaticResource Actions}"
        Command="{Binding DigitButtonPressCommand}" CommandParameter="CE"></Button>
<Button Name="buttonClean" Content="C" Grid.Column="2" Style="{StaticResource Actions}"
        Command="{Binding DigitButtonPressCommand}" CommandParameter="C"></Button>
<Button Name="buttonBackspace" Content="⌫" Grid.Column="3" Style="{StaticResource Actions}"
        Command="{Binding DigitButtonPressCommand}" CommandParameter="Del"></Button>

<Button Name="buttonOnex" Content="1/x" Grid.Row="1" Style="{StaticResource Actions}"></Button>
<Button Name="buttonxintwo" Content="x²" Grid.Row="1" Grid.Column="1" Style="{StaticResource Actions}"
        CommandParameter="sqr"></Button>
<Button Name="buttonxsqure" Content="²√x" Grid.Row="1" Grid.Column="2" Style="{StaticResource Actions}" CommandParameter="√"></Button>
<Button Name="buttonDivide" Content="÷" Grid.Row="1" Grid.Column="3" Style="{StaticResource Actions}"></Button>

<Button Name="button7" Content="7" Grid.Row="2" Style="{StaticResource Digit}"></Button>
<Button Name="button8" Content="8" Grid.Row="2" Grid.Column="1" Style="{StaticResource Digit}"></Button>
<Button Name="button9" Content="9" Grid.Row="2" Grid.Column="2" Style="{StaticResource Digit}"></Button>
<Button Name="buttonMultiply" Content="×" FontSize="20" Grid.Row="2" Grid.Column="3" Style="{StaticResource Actions}"></Button>

<Button Name="button4" Content="4" Grid.Row="3" Style="{StaticResource Digit}"></Button>
<Button Name="button5" Content="5" Grid.Row="3" Grid.Column="1" Style="{StaticResource Digit}"></Button>
<Button Name="button6" Content="6" Grid.Row="3" Grid.Column="2" Style="{StaticResource Digit}"></Button>
<Button Name="buttonMinus" Content="-" FontSize="20" Grid.Row="3" Grid.Column="3" Style="{StaticResource Actions}"></Button>

<Button Name="button1" Content="1" Grid.Row="4" Style="{StaticResource Digit}"/>

<Button Name="button2" Content="2" Grid.Row="4" Grid.Column="1" Style="{StaticResource Digit}"/>

<Button Name="button3" Content="3" Grid.Row="4" Grid.Column="2" Style="{StaticResource Digit}"/>

<Button Name="buttonPluse" Content="+" FontSize="20" Grid.Row="4" Grid.Column="3" Style="{StaticResource Actions}"/>

<Button Name="buttonPluseminus" Content="+/-" Grid.Row="5" Style="{StaticResource Actions}" Command="{Binding DigitButtonPressCommand}"></Button>
<Button Name="button0" Content="0" Grid.Row="5" Grid.Column="1" Style="{StaticResource Digit}"
        ></Button>
<Button Name="buttonDot" Content="." Grid.Row="5" Grid.Column="2" Style="{StaticResource Actions}"
        Command="{Binding DigitButtonPressCommand}"></Button>

<Button Name="buttonResult" Focusable="True" Content="=" Grid.Row="5" Grid.Column="3">
    <Button.Style>
        <Style TargetType="Button">
            <Setter Property="FontWeight" Value="Normal"></Setter>
            <Setter Property="FontSize" Value="18"></Setter>
            <Setter Property="Foreground" Value="Black"></Setter>
            <Setter Property="Command" Value="{Binding OperationButtonPressCommand}"/>
            <Setter Property="CommandParameter" Value="{Binding RelativeSource={RelativeSource Self}, Path=Content}"/>
            <Setter Property="Background" Value="#8FB7D7"/>
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
                                <Setter Property="Background" Value="#498DC5"/>
                                <Setter Property="BorderBrush" TargetName="border"  Value="#BAB8B8"/>
                                <Setter Property="BorderThickness" TargetName="border"  Value="2"/>
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
            <Style.Triggers>
                <Trigger Property="IsPressed" Value="True">
                    <Setter Property="Background" Value="#0062B1"/>
                </Trigger>
            </Style.Triggers>
        </Style>
    </Button.Style>
</Button>
```


**Build solution and check styling compared to the Windows 10 Calculator.**

## Testing
### Simple Operations
- Test addition, subtraction, etc. Make sure the full equation is displayed above the correct answer when the "=" button is pressed.
- Test the clear, clear equation, and back buttons.
- Test the numpad keybindings.

### Complex Operations
- Test the square, square root, reciprocal, and percentage operators.  

### Chained Operations 
- Build a long equation without pressing the "=" button.  Does the correct answer calculate every time you click a new operator? 
- Enter an equation and press the "=" button.  Repeatedly press "=" and see if the equation repeats the last operation.


