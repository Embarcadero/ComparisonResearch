using GitHubExplorer.Components;
using GitHubExplorer.Models;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.IO;
using System.Linq;
using System.Net;
using System.Runtime.CompilerServices;

namespace GitHubExplorer
{
    public class MainWindowViewmodel : INotifyPropertyChanged
    {
        public event PropertyChangedEventHandler PropertyChanged;
        protected void OnPropertyChanged([CallerMemberName] string name = null)
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(name));
        }

        public MainWindowViewmodel()
        {
            Repositories = new ObservableCollection<Repository>();
            Languages = new ObservableCollection<Languages>()
            {
                new Languages(){Name = "Pascal" },
                new Languages(){Name ="JavaScript"},
                new Languages(){Name ="HTML"},
                new Languages(){Name ="Java"},
                new Languages(){Name ="Python"},
                new Languages(){Name ="CSS"},
                new Languages(){Name ="TypeScript"},
                new Languages(){Name ="Jupyter Notebook"},
                new Languages(){Name ="C#"},
                new Languages(){Name ="Ruby"},
                new Languages(){Name ="PHP"}
            };
            MasterLanguages = Languages;
            SelectedListItem = new List<Languages>();
            SelectedDate = DateTime.Today.AddDays(-7);
          
            SortDataList = new List<string>()
            {
                "Sort by decreasing",
                "Sort by increasing",
                "No Sort"
            };
        }

        private List<string> _sortDataList;
        public List<string> SortDataList
        {
            get { return _sortDataList; }
            set { _sortDataList = value; OnPropertyChanged(nameof(SortDataList)); }
        }

        private string _selectedSortData;
        public string SelectedSortData
        {
            get { return _selectedSortData; }
            set { _selectedSortData = value; OnPropertyChanged(nameof(SelectedSortData)); SortedData(); }
        }

        private ObservableCollection<Languages> MasterLanguages { get; set; }

        private ObservableCollection<GitRepositoryControl> _repositoryList;
        public ObservableCollection<GitRepositoryControl> RepositoryList
        {
            get { return _repositoryList; }
            set { _repositoryList = value; OnPropertyChanged(nameof(RepositoryList)); }
        }

        private ObservableCollection<Repository> _repositories;
        public ObservableCollection<Repository> Repositories
        {
            get { return _repositories; }
            set { _repositories = value; OnPropertyChanged(nameof(Repositories)); if (Repositories != null) { UpdateRepositoryList(); }; }
        }
        private ObservableCollection<Repository> repositoryDefaultList { get; set; } = new ObservableCollection<Repository>();

        private void UpdateRepositoryList()
        {
            System.Windows.Application.Current.Dispatcher.Invoke(new Action(() =>
            {
                RepositoryList = new ObservableCollection<GitRepositoryControl>(Repositories.Select((each) =>
                 new GitRepositoryControl()
                 {
                     Url = each.url,
                     Title = each.title,
                     Description = each.description,
                     Stars = each.stars,
                     Language = each.language,
                     License = each.license,
                     LastUpdate = each.representupdatedate
                 }).ToList());
            }));
        }

        private ObservableCollection<Languages> _languages;
        public ObservableCollection<Languages> Languages
        {
            get { return _languages; }
            set { _languages = value; OnPropertyChanged(nameof(Languages)); }
        }

        private string _searchText;
        public string SearchText
        {
            get { return _searchText; }
            set { _searchText = value; OnPropertyChanged(nameof(SearchText)); FilterData(); }
        }

        private List<Languages> _selectedListItem;
        public List<Languages> SelectedListItem
        {
            get { return _selectedListItem; }
            set
            {
                _selectedListItem = value;
                if (SelectedListItem.Count > 0)
                {
                    GetFilterRepository();
                }
            }
        }

        private DateTime _selectedDate;
        public DateTime SelectedDate
        {
            get { return _selectedDate; }
            set
            {
                if (value != _selectedDate)
                {
                    _selectedDate = value;
                    OnPropertyChanged("SelectedDate"); GetFilterRepository();
                }
            }
        }

        private bool _isBackDropVisible;
        public bool IsBackDropVisible
        {
            get { return _isBackDropVisible; }
            set { _isBackDropVisible = value; OnPropertyChanged(nameof(IsBackDropVisible)); }
        }


        private bool _isBusy;
        public bool IsBusy
        {
            get { return _isBusy; }
            set { _isBusy = value; OnPropertyChanged("IsBusy"); }
        }

        private void FilterData()
        {
            Languages = MasterLanguages;
            if (SearchText.Trim() != "")
            {
                Languages = new ObservableCollection<Languages>(MasterLanguages.Where(z => z.Name.Contains(SearchText.Trim(), StringComparison.OrdinalIgnoreCase)));
            }
        }

        private string api_url = "https://api.github.com/search/repositories?q=";

        private void GetFilterRepository()
        {
            IsBusy = true;
            var worker = new BackgroundWorker();
            worker.DoWork += (o, ea) =>
            {
                if (SelectedListItem.Count > 0 || (SelectedDate != null && SelectedDate != DateTime.MinValue))
                {
                    var url = api_url;
                    //https://api.github.com/search/repositories?q=test+language:Javascript+language:java&per_page=100
                    //https://api.github.com/search/repositories?q=language:Javascript+language:java&per_page=100
                    //https://api.github.com/search/repositories?q=language:+created:>=2020-12-14
                    if (SelectedListItem.Count > 0)
                    {
                        for (int i = 0; i < SelectedListItem.Count; i++)
                        {
                            if (i == 0)
                            {
                                url = $"{url}language:{SelectedListItem[i].Name}";
                            }
                            else
                            {
                                url = $"{url}+language:{SelectedListItem[i].Name}";
                            }
                        }
                    }
                    else
                    {
                        url = $"{url}language";
                    }

                    if (SelectedDate != null)
                    {
                        url = $"{url}+created:>={SelectedDate.Date.ToString("yyyy/MM/dd")}";
                    }

                    LoadRepositories(url);
                    
                }
            };
            worker.RunWorkerAsync();
        }

        private void SortedData()
        {
            if (SelectedSortData != null)
            {
                if (SelectedSortData == "Sort by decreasing")
                {
                    Repositories = new ObservableCollection<Repository>(repositoryDefaultList.OrderByDescending(x => x.createdate));
                }
                else if (SelectedSortData == "Sort by increasing")
                {
                    Repositories = new ObservableCollection<Repository>(repositoryDefaultList.OrderBy(x => x.createdate));
                }
                else
                {
                    Repositories = new ObservableCollection<Repository>(repositoryDefaultList);
                }
            }
        }

        private void LoadRepositories(string apiLinkWithFiltersApplied)
        {
            try
            {
                repositoryDefaultList = new ObservableCollection<Repository>();

                for (int i = 1; i <= 1; i++)
                {
                    var defaulturl = $"{apiLinkWithFiltersApplied}&per_page=100&page={i}";
                    GithubResult responseWrap = null;
                    HttpWebRequest request = (HttpWebRequest)WebRequest.Create(defaulturl);
                    request.Proxy = new WebProxy()
                    {
                        Credentials = System.Net.CredentialCache.DefaultNetworkCredentials
                    };
                    request.UseDefaultCredentials = true;
                    request.Credentials = CredentialCache.DefaultCredentials;
                    request.KeepAlive = true;
                    request.UserAgent = "My request";



                    using (var response = request.GetResponse())
                    using (var stream = response.GetResponseStream())
                    using (var streamReader = new StreamReader(stream))
                    {
                        string responseBody = streamReader.ReadToEnd();
                        JsonSerializer jsonSerializer = new JsonSerializer();
                        using (TextReader tr = new StringReader(responseBody))
                        {
                            responseWrap = (GithubResult)jsonSerializer.Deserialize(tr, typeof(GithubResult));
                        }
                    }

                    if (responseWrap.total_count == 0)
                    {
                        break;
                    }
                    else
                    {
                        ProceedResponse(responseWrap);
                    }
                }
            }
            catch (WebException exception)
            {
                string responseText;

                using (var reader = new StreamReader(exception.Response.GetResponseStream()))
                {
                    responseText = reader.ReadToEnd();
                }
            }
        }

        private void ProceedResponse(GithubResult response)
        {
            foreach (var item in response.items)
            {
                repositoryDefaultList.Add(
                    new Repository(item.id, item.full_name, item.html_url, item.description, item.language,
                    item.stargazers_count, item?.license?.name, item.updated_at, item.created_at));
            }
            IsBusy = false;
            SortedData();
        }
    }

    public static class StringExtensions
    {
        public static bool Contains(this string value, string valueToCheck, StringComparison comparisonType)
        {
            return value.IndexOf(valueToCheck, comparisonType) != -1;
        }
    }

    public class Languages
    {
        public string Name { get; set; }
        public bool IsChecked { get; set; }
    }
}
