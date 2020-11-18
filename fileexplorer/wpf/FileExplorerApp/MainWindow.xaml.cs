using FileExplorerApp.Models;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Collections.Specialized;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Interactivity;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace FileExplorerApp
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
    }


    public class CustomDataGrid : DataGrid
    {
        public CustomDataGrid()
        {
            this.SelectionChanged += CustomDataGrid_SelectionChanged;
        }

        void CustomDataGrid_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            this.SelectedItemsList = new ObservableCollection<FileSystemObjectInfo>(this.SelectedItems.Cast<FileSystemObjectInfo>().ToList());
        }

        public ObservableCollection<FileSystemObjectInfo> SelectedItemsList
        {
            get { return (ObservableCollection<FileSystemObjectInfo>)GetValue(SelectedItemsListProperty); }
            set { SetValue(SelectedItemsListProperty, value); }
        }

        public static readonly DependencyProperty SelectedItemsListProperty =
                    DependencyProperty.Register("SelectedItemsList", typeof(ObservableCollection<FileSystemObjectInfo>), typeof(CustomDataGrid)
                        , new FrameworkPropertyMetadata(null,FrameworkPropertyMetadataOptions.BindsTwoWayByDefault));
    }

    public class MyTreeView : TreeView, INotifyPropertyChanged
    {
        public static readonly DependencyProperty SelectedItemsProperty = DependencyProperty.Register("SelectedItem", typeof(Object), typeof(MyTreeView), new PropertyMetadata(null));
        public new Object SelectedItem
        {
            get { return (Object)GetValue(SelectedItemProperty); }
            set
            {
                SetValue(SelectedItemsProperty, value);
                NotifyPropertyChanged("SelectedItem");
            }
        }

        public MyTreeView()
            : base()
        {
            base.SelectedItemChanged += new RoutedPropertyChangedEventHandler<Object>(MyTreeView_SelectedItemChanged);
        }

        private void MyTreeView_SelectedItemChanged(Object sender, RoutedPropertyChangedEventArgs<Object> e)
        {
            this.SelectedItem = base.SelectedItem;
        }

        public event PropertyChangedEventHandler PropertyChanged;
        private void NotifyPropertyChanged(String aPropertyName)
        {
            if (PropertyChanged != null)
                PropertyChanged(this, new PropertyChangedEventArgs(aPropertyName));
        }
    }

    

}
