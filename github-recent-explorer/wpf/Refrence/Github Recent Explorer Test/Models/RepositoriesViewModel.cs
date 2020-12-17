using Github_Recent_Explorer_Test.Components;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Controls;
using System.Windows.Media;

namespace Github_Recent_Explorer_Test.Models
{
    class RepositoriesViewModel : INotifyPropertyChanged
    {
        private Label _languageFilter;
        private string _dateFilter;
        private string _customFilter;
        private bool _isDropSideHidden;
        public bool IsLoading
        {
            get
            {
                return this.repositoriesModel.IsRequestInProcess;
            }
        }
        public bool IsDropSideHidden
        {
            get
            {
                return _isDropSideHidden;
            }
            set
            {
                _isDropSideHidden = value;
                RaisePropertyChanged("IsDropSideHidden");
            }
        }

        public string DateFilter
        {
            get
            {
                return _dateFilter;
            }
            set
            {
                _dateFilter = value;
                repositoriesModel.DateFilter = this._dateFilter;
            }
        }
        public string CustomFilter
        {
            get
            {
                return _customFilter;
            }
            set
            {
                _customFilter = value;
                repositoriesModel.CustomFilter = this._customFilter;
            }
        }
        public Label LanguageFilter
        {
            get
            {
                return _languageFilter;
            }
            set
            {
                _languageFilter = value;
                repositoriesModel.LanguageFilter = (this._languageFilter?.Content as string);
            }
        }
        public GitRepositoryControl[] Repositories
        {
            get
            {
                return this.repositoriesModel.Repositories
                    .Select((each) => 
                    new GitRepositoryControl() 
                    { 
                        Url = each.url, Title = each.title, Description = each.description, 
                        Stars = each.stars, Language = each.language, License = each.license, 
                        LastUpdate = each.representupdatedate 
                    })
                    .ToArray();
            }
        }

        public string[] AvailableDateFilters
        {
            get => this.repositoriesModel.AvailableDateFilters;
        } 
        public string[] AvailableCustomFilters
        {
            get => this.repositoriesModel.AvailableCustomFilters;
        }
        public Label[] AvailableLanguageFilters
        {
            get => this.repositoriesModel.AvailableLanguageFilters
               .Select((each) => new Label() { Content = each, Foreground = Brushes.White }).ToArray();
        }
        private RepositoriesModel repositoriesModel;

        public event PropertyChangedEventHandler PropertyChanged;

        protected void RaisePropertyChanged(string propertyName)
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
        }
        private void ModelPropertyChange(object sender, PropertyChangedEventArgs e)
        {
            RaisePropertyChanged(e.PropertyName);
        }
        public RepositoriesViewModel()
        {
            this.IsDropSideHidden = false;
            this.repositoriesModel = new RepositoriesModel();
            this.repositoriesModel.PropertyChanged += ModelPropertyChange;

        }
    }
}
