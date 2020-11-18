using FileExplorerApp.Models;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
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

namespace FileExplorerApp.UserControls
{
    /// <summary>
    /// Interaction logic for ExplorerControl.xaml
    /// </summary>
    public partial class ExplorerControl : UserControl
    {
        public ExplorerControl()
        {
            InitializeComponent();
        }

        private void treeView_SelectedItemChanged(object sender, RoutedPropertyChangedEventArgs<object> e)
        {

        }

        private void DataGrid_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {

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
                        , new FrameworkPropertyMetadata(null, FrameworkPropertyMetadataOptions.BindsTwoWayByDefault, CurrentItemPropertyChanged));


        private static void CurrentItemPropertyChanged(
     DependencyObject d, DependencyPropertyChangedEventArgs e)
        {
            //this.SelectedItems = e.NewValue as FileSystemObjectInfo;
            //var control = (CustomAutoCompleteBox)d;
            //control.InternalCurrentItem = (CityEntity)e.NewValue;
        }
    }

    public class MyTreeView : TreeView, INotifyPropertyChanged
    {
        public static readonly DependencyProperty SelectedItemsProperty = 
            DependencyProperty.Register("SelectedItem", typeof(FileSystemObjectInfo), typeof(MyTreeView)
                , new PropertyMetadata(new FileSystemObjectInfo(), CurrentItemPropertyChanged));

        private static void CurrentItemPropertyChanged(
    DependencyObject d, DependencyPropertyChangedEventArgs e)
        {
            var gg = d as MyTreeView;
            gg.SelectedItem = e.NewValue as FileSystemObjectInfo;
        }
        public new FileSystemObjectInfo SelectedItem
        {
            get { return (FileSystemObjectInfo)GetValue(SelectedItemProperty); }
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
            this.SelectedItem = base.SelectedItem as FileSystemObjectInfo;
        }

        public event PropertyChangedEventHandler PropertyChanged;
        private void NotifyPropertyChanged(String aPropertyName)
        {
            if (PropertyChanged != null)
                PropertyChanged(this, new PropertyChangedEventArgs(aPropertyName));
        }
    }
}
