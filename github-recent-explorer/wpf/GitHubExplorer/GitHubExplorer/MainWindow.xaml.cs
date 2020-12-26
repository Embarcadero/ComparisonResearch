using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Controls.Primitives;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Interactivity;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace GitHubExplorer
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        public MainWindow()
        {
            InitializeComponent();
        }

        private void languageList_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            var viewmodel = this.DataContext as MainWindowViewmodel;

            var languageList = new List<Languages>();

            foreach (var item in ((ListBox)sender).SelectedItems)
            {
                languageList.Add(item as Languages);
            }
            viewmodel.SelectedListItem = new List<Languages>(languageList);
        }
    }
}
