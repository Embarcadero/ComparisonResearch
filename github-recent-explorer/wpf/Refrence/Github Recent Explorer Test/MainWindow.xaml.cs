using Github_Recent_Explorer_Test.Models;
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

namespace Github_Recent_Explorer_Test
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        RepositoriesViewModel repositoriesViewModel;
        public MainWindow()
        {
            InitializeComponent();

            this.repositoriesViewModel = new RepositoriesViewModel();

            this.DataContext = this.repositoriesViewModel;
        }

        private void DropSide_Click(object sender, RoutedEventArgs e)
        {
            this.repositoriesViewModel.IsDropSideHidden = (this.repositoriesViewModel.IsDropSideHidden ? false : true); 
        }
    }
}
