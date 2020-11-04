﻿using GalaSoft.MvvmLight.Command;
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
                currentOperation = operation;
                if (string.IsNullOrEmpty(FirstOperand) || LastOperation == "=")
                {
                    FirstOperand = Display;
                    Operation = operation == "=" ? Operation : operation;
                    LastOperation = operation;
                    if (Operation == "sqr" || Operation == "√" || Operation == "1/x" || Operation == "%")
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
                var number = string.IsNullOrEmpty(SecondOperand) ? FirstOperand : SecondOperand;
                switch (operation)
                {
                    case ("sqr"):
                        Expression = Expression + operation + "( " + number + " )";
                        break;
                    case ("√"):
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
                            Expression = Expression + result;
                        break;
                    case ("1/x"):
                        Expression = 1 + "/(" + FirstOperand + ")";
                        break;

                    default:
                        if (IsOperation == false)
                        {
                            Expression = Expression + number + operation;
                        }
                        var str = Expression.Last();
                        if (str == Convert.ToChar(")"))
                        {
                            Expression = Expression + operation;
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
                if (Operation == "sqr" || Operation == "%" || Operation == "√" || Operation == "1/x")
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
                            result = Math.Round(Convert.ToDouble(FirstOperand) * Convert.ToDouble(SecondOperand) / 100).ToString();
                            IsBODMASOperation = false;
                        }
                        catch (Exception e)
                        {
                            result = "0";
                        }
                        break;
                    case ("1/x"):
                        result = (1 / (Convert.ToDouble(Display))).ToString();
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
