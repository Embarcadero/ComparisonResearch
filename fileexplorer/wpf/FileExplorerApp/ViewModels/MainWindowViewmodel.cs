using FileExplorerApp.Enums;
using FileExplorerApp.Models;
using FileExplorerApp.Utils;
using GalaSoft.MvvmLight.Command;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Input;

namespace FileExplorerApp.ViewModels
{
    public class MainWindowViewmodel
    {
        public MainWindowViewmodel()
        {
            Items = new ObservableCollection<TabModel>()
            {
                new TabModel(){ Header = $"File Explorer #{Items.Count+1}",DataContext = new ExplorerControlViewModel()},
            };
            CloseTabCommand = new RelayCommand<object>(OnCloseTabCommand);
            AddTabCommand = new RelayCommand(OnAddTabCommand);
        }

        private void OnAddTabCommand()
        {
            Items.Add(new TabModel() { Header = $"File Explorer #{Items.Count + 1}", DataContext = new ExplorerControlViewModel() });
        }

        private void OnCloseTabCommand(object obj)
        {
            Items.Remove((TabModel)obj);
        }

        public ObservableCollection<TabModel> Items { get; set; } = new ObservableCollection<TabModel>();

        public ICommand CloseTabCommand { get; set; }
        public ICommand AddTabCommand { get; set; }
    }

    public class TabModel
    {
        public string Header { get; set; }
        public ExplorerControlViewModel DataContext { get; set; }
    }
}
