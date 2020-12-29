using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;

namespace Github_Recent_Explorer_Test.Models
{
    class RepositoriesModel : INotifyPropertyChanged
    {
        private Repository[] _repositories;
        private string[] _availabelDateFilters;
        private string[] _availabelLanguageFilters;
        private string[] _availabelCustomFilters;
        private string _languageFilter = null;
        private string _dateFilter = null;
        private string _customFilter = null;
        private string _previousLanguageFilterApplied = null;
        private string _previousDateFilterApplied = null;
        private string _previousCustomFilterApplied = null;
        private string api_url = "https://api.github.com/search/repositories?q=language:{LANGUAGE}";
        private bool _isRequestInProcess;
        public bool IsRequestInProcess
        {
            get => _isRequestInProcess;
            set
            {
                _isRequestInProcess = value;
                RaisePropertyChanged("IsLoading");
            }
        }
        public Repository[] Repositories
        {
            get
            {
                return _repositories;
            }
            set
            {
                _repositories = value;
                RaisePropertyChanged("Repositories");
            }
        }
        public string[] AvailableLanguageFilters
        {
            get => _availabelLanguageFilters;
        }
        public string[] AvailableCustomFilters
        {
            get => _availabelCustomFilters;
        }
        public string[] AvailableDateFilters
        {
            get => _availabelDateFilters;
        }
        public event PropertyChangedEventHandler PropertyChanged;

        protected void RaisePropertyChanged(string propertyName)
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
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
                if (_dateFilter != _previousDateFilterApplied && !_isRequestInProcess)
                {
                    Task.Run(() => UpdateRepositoriesList());
                }
            }
        }
        public string LanguageFilter
        {
            get
            {
                return _languageFilter;
            }
            set
            {
                _languageFilter = value;
                if (_languageFilter != _previousLanguageFilterApplied && !_isRequestInProcess)
                {
                    Task.Run(() => UpdateRepositoriesList());
                }
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
                if (_customFilter != _previousCustomFilterApplied && !_isRequestInProcess)
                {
                    Task.Run(() => UpdateRepositoriesList());
                }
            }
        }
        private async Task UpdateRepositoriesList()
        {
            this.IsRequestInProcess = true;
            this._previousLanguageFilterApplied = this._languageFilter;
            this._previousDateFilterApplied = this._dateFilter;
            this._previousCustomFilterApplied = this._customFilter;

            try
            {
                var repositoriesResponse = await GetRepositoriesWithFiltersApplied(this._previousLanguageFilterApplied, this._previousDateFilterApplied, this._previousCustomFilterApplied);

                Repositories = ProceedResponse(repositoriesResponse);
            }
            catch (Exception)
            {

            }
            this.IsRequestInProcess = false;
        }
        private Repository[] ProceedResponse(GitHubApiResponse response)
        {
            List<Repository> repositories = new List<Repository>();

            foreach (var item in response.items)
            {
                repositories.Add(
                    new Repository(item.id, item.full_name, item.html_url, item.description, item.language, item.stargazers_count, item?.license?.name, item.updated_at, item.created_at)
                    );
            }

            return repositories.ToArray();
        }
        private string[] GetAvailableDateFilters()
        {
            List<string> dateFilters = new List<string>();

            for (int i = 1; i <= 7; i++)
            {
                DateTime date = DateTime.MinValue + DateTime.Now.Subtract(DateTime.MinValue.AddDays(i));

                dateFilters.Add($"{date.Month.ToString().PadLeft(2, '0')}/{date.Day.ToString().PadLeft(2,'0')}/{date.Year}");
            }

            return dateFilters.ToArray();
        }

        private string ApplyDateFilter(string url, string date)
        {
            date = (date == "" || date == null ? _availabelDateFilters.Last() : date);

            string yyyy = date.Split('/')[2];
            string mm = date.Split('/')[0];
            string dd = date.Split('/')[1];

            url = url + $"+created:>={yyyy}-{mm}-{dd}";

            return url;
        }
        private string ApplyCustomFilter(string url, string customFilter)
        {
            switch (customFilter)
            {
                case "Sort by stars decreasing":
                    url = url + "&sort=stars&order=desc";
                    break;
                case "Sort by stars increasing":
                    url = url + "&sort=stars&order=asc";
                    break;
            }
            return url;
        }
        private string GetApiLinkWithFiltersApplied(string url, string languageFilter, string dateFilter, string customFilter)
        {
            string languageFilterUrlEncoded = WebUtility.UrlEncode(languageFilter);

            url = url.Replace("{LANGUAGE}", languageFilterUrlEncoded);

            url = ApplyDateFilter(url, dateFilter);

            url = ApplyCustomFilter(url, customFilter);

            return url;
        }

        private async Task<GitHubApiResponse> GetRepositoriesWithFiltersApplied(string languageFilter, string dateFilter, string customFilter)
        {
            string apiLinkWithFiltersApplied = GetApiLinkWithFiltersApplied(api_url, languageFilter, dateFilter, customFilter) + "&per_page=60";

            GitHubApiResponse responseWrap = null;
            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(apiLinkWithFiltersApplied);

            request.UserAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.111 Safari/537.36";
            using (var response = request.GetResponse())
            using (var stream = response.GetResponseStream())
            using (var streamReader = new StreamReader(stream))
            {
                string responseBody = streamReader.ReadToEnd();
                JsonSerializer jsonSerializer = new JsonSerializer();
                using (TextReader tr = new StringReader(responseBody))
                {
                    responseWrap = (GitHubApiResponse)jsonSerializer.Deserialize(tr, typeof(GitHubApiResponse));
                }
            }
            return responseWrap;
        }
        public RepositoriesModel()
        {
            this.IsRequestInProcess = false;
            this.Repositories = new Repository[] { };
            this._availabelLanguageFilters = new string[] { "Pascal", "JavaScript", "HTML", "Java", "Python", "CSS", "TypeScript", "Jupyter Notebook", "C#", "Ruby", "PHP" };
            this._availabelCustomFilters = new string[] { "Sort by stars decreasing", "Sort by stars increasing", "No Sort" };
            this._availabelDateFilters = GetAvailableDateFilters();

            Task.Run(() => UpdateRepositoriesList());
        }
    }
}
