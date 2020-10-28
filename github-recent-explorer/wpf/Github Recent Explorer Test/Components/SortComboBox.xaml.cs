using System;
using System.Collections.Generic;
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
    /// Interaction logic for SortComboBox.xaml
    /// </summary>
    public partial class SortComboBox : UserControl
    {
        public string[] AvailableCustomFilters
        {
            get { return (string[])GetValue(AvailableCustomFiltersProperty); }
            set { SetValue(AvailableCustomFiltersProperty, value); }
        }

        public static readonly DependencyProperty AvailableCustomFiltersProperty =
            DependencyProperty.Register("AvailableCustomFilters", typeof(string[]), typeof(SortComboBox), new PropertyMetadata(new string[] { }));
        public string CustomFilter
        {
            get { return (string)GetValue(CustomFilterProperty); }
            set { SetValue(CustomFilterProperty, value); }
        }

        public static readonly DependencyProperty CustomFilterProperty =
            DependencyProperty.Register("CustomFilter", typeof(string), typeof(SortComboBox), new PropertyMetadata(null));

        public SortComboBox()
        {
            InitializeComponent();
        }
    }
}
