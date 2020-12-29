using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace Github_Recent_Explorer_Test.Components
{
    /// <summary>
    /// Interaction logic for DateComboBox.xaml
    /// </summary>
    public partial class DateComboBox : UserControl
    {
        public string[] AvailableDateFilters
        {
            get { return (string[])GetValue(AvailableDateFiltersProperty); }
            set { SetValue(AvailableDateFiltersProperty, value); }
        }

        public static readonly DependencyProperty AvailableDateFiltersProperty =
            DependencyProperty.Register("AvailableDateFilters", typeof(string[]), typeof(DateComboBox), new PropertyMetadata(new string[] { }));
        public string DateFilter
        {
            get { return (string)GetValue(DateFilterProperty); }
            set { SetValue(DateFilterProperty, value); }
        }

        public static readonly DependencyProperty DateFilterProperty =
            DependencyProperty.Register("DateFilter", typeof(string), typeof(DateComboBox), new PropertyMetadata(null));

        public DateComboBox()
        {
            InitializeComponent();
        }
    }
}
