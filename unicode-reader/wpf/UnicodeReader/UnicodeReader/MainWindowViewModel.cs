using GalaSoft.MvvmLight.Command;
using Newtonsoft.Json;
using Npgsql;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Data;
using System.IO;
using System.Linq;
using System.Net;
using System.Runtime.CompilerServices;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Threading;
using System.Xml;
using System.Xml.Serialization;

namespace UnicodeReader
{
    public class MainWindowViewModel : INotifyPropertyChanged
    {
        public MainWindowViewModel()
        {
            //FeedList = new ObservableCollection<Feed>()
            //{
            //    new Feed(){Title = "All Feed",Url="all feed"},
            //    new Feed(){Title = "EN Feed",Url="https://blogs.embarcadero.com/feed/"},
            //    new Feed(){Title = "JA Feed",Url="https://blogs.embarcadero.com/ja/feed/"},
            //    new Feed(){Title = "DE Feed",Url="https://blogs.embarcadero.com/de/feed/"},
            //    new Feed(){Title = "RU Feed",Url="https://blogs.embarcadero.com/ru/feed/"},
            //    new Feed(){Title = "PT Feed",Url="https://blogs.embarcadero.com/pt/feed/"},
            //    new Feed(){Title = "ES Feed",Url="https://blogs.embarcadero.com/es/feed/"},
            //};
            FeedList = new ObservableCollection<Feed>();
            FeedItemsList = new ObservableCollection<FeedItem>();
            RefreshCommand = new RelayCommand(GetFeedItems);
            ConnectCommand = new RelayCommand(GetConnection);
            ThemeCommand = new RelayCommand<Grid>(ChangeTheme);
            //ServerName = "localhost";
            //Port = "5432";
            //User = "postgres";
            //Password = "postgres";
            //Database = "Test";
            Background = (Brush)(new BrushConverter().ConvertFrom("#20262F")); ;
            Foreground = Brushes.White;
            HumbergerIcon = "pack://application:,,,/Icons/humbergerwhite.png";
            RefreshIcon = "pack://application:,,,/Icons/refreshwhite.png";
            ThemeIcon = "pack://application:,,,/Icons/themeiconwhite.png";
            Arrow = "pack://application:,,,/Icons/navigatewhite.png";
            RightArrow = "pack://application:,,,/Icons/rightarrowwhite.png";
        }

        private Brush _foreground;
        public Brush Foreground
        {
            get { return _foreground; }
            set { _foreground = value; OnPropertyChanged(nameof(Foreground)); }
        }

        private Brush _background;
        public Brush Background
        {
            get { return _background; }
            set { _background = value; OnPropertyChanged(nameof(Background)); }
        }

        private string _humbergerIcon;
        public string HumbergerIcon
        {
            get { return _humbergerIcon; }
            set { _humbergerIcon = value; OnPropertyChanged(nameof(HumbergerIcon)); }
        }

        private string _refreshIcon;
        public string RefreshIcon
        {
            get { return _refreshIcon; }
            set { _refreshIcon = value; OnPropertyChanged(nameof(RefreshIcon)); }
        }

        private string _arrow;
        public string Arrow
        {
            get { return _arrow; }
            set { _arrow = value; OnPropertyChanged(nameof(Arrow)); }
        }

        private string _rightArrow;
        public string RightArrow
        {
            get { return _rightArrow; }
            set { _rightArrow = value; OnPropertyChanged(nameof(RightArrow)); }
        }

        private string _themeIcon;
        public string ThemeIcon
        {
            get { return _themeIcon; }
            set { _themeIcon = value; OnPropertyChanged(nameof(ThemeIcon)); }
        }


        private ObservableCollection<Feed> _feedList;
        public ObservableCollection<Feed> FeedList
        {
            get { return _feedList; }
            set { _feedList = value; OnPropertyChanged(nameof(FeedList)); }
        }

        private Feed _selectedFeed;
        public Feed SelectedFeed
        {
            get { return _selectedFeed; }
            set { _selectedFeed = value; OnPropertyChanged(nameof(SelectedFeed)); GetFeedItemsFromDatabase(); IsWebBrowserVisible = false; }
        }

        private ObservableCollection<FeedItem> _feedItemsList;
        public ObservableCollection<FeedItem> FeedItemsList
        {
            get { return _feedItemsList; }
            set { _feedItemsList = value; OnPropertyChanged(nameof(FeedItemsList)); }
        }

        private FeedItem _selectedFeedItem;
        public FeedItem SelectedFeedItem
        {
            get { return _selectedFeedItem; }
            set { _selectedFeedItem = value; OnPropertyChanged(nameof(SelectedFeedItem)); GetFeedUrl(); }
        }

        private bool _isBackDropVisible;
        public bool IsBackDropVisible
        {
            get { return _isBackDropVisible; }
            set { _isBackDropVisible = value; OnPropertyChanged(nameof(IsBackDropVisible)); }
        }

        private Uri _feedUrl;
        public Uri FeedUrl
        {
            get { return _feedUrl; }
            set { _feedUrl = value; OnPropertyChanged(nameof(FeedUrl)); }
        }

        private bool _isBusy;
        public bool IsBusy
        {
            get { return _isBusy; }
            set { _isBusy = value; OnPropertyChanged("IsBusy"); }
        }

        private bool _isListBusy;
        public bool IsListBusy
        {
            get { return _isListBusy; }
            set { _isListBusy = value; OnPropertyChanged("IsListBusy"); }
        }

        private bool _isWebBrowserVisible;
        public bool IsWebBrowserVisible
        {
            get { return _isWebBrowserVisible; }
            set { _isWebBrowserVisible = value; OnPropertyChanged(nameof(IsWebBrowserVisible)); }
        }

        private string _serverName;
        public string ServerName
        {
            get { return _serverName; }
            set { _serverName = value; OnPropertyChanged(nameof(ServerName)); }
        }

        private string _port;
        public string Port
        {
            get { return _port; }
            set { _port = value; OnPropertyChanged(nameof(Port)); }
        }

        private string _user;
        public string User
        {
            get { return _user; }
            set { _user = value; OnPropertyChanged(nameof(User)); }
        }

        private string _password;
        public string Password
        {
            get { return _password; }
            set { _password = value; OnPropertyChanged(nameof(Password)); }
        }

        private string _database;
        public string Database
        {
            get { return _database; }
            set { _database = value; OnPropertyChanged(nameof(Database)); }
        }
        private ObservableCollection<FeedItem> defaultFeedItems { get; set; } = new ObservableCollection<FeedItem>();

        public ICommand RefreshCommand { get; set; }
        public ICommand ConnectCommand { get; set; }
        public ICommand ThemeCommand { get; set; }

        private NpgsqlConnection GetConnectionString()
        {
            try
            {
                if (string.IsNullOrWhiteSpace(ServerName))
                {
                    MessageBox.Show("Server name required!!", "Unicode Reader", MessageBoxButton.OK);
                    return null;
                }
                if (string.IsNullOrWhiteSpace(Port))
                {
                    MessageBox.Show("Port number required!!", "Unicode Reader", MessageBoxButton.OK);
                    return null;
                }
                if (string.IsNullOrWhiteSpace(User))
                {
                    MessageBox.Show("Username required!!", "Unicode Reader", MessageBoxButton.OK);
                    return null;
                }
                if (string.IsNullOrWhiteSpace(Password))
                {
                    MessageBox.Show("Password required!!", "Unicode Reader", MessageBoxButton.OK);
                    return null;
                }
                if (string.IsNullOrWhiteSpace(Database))
                {
                    MessageBox.Show("Database name required!!", "Unicode Reader", MessageBoxButton.OK);
                    return null;
                }
                NpgsqlConnection connection = new NpgsqlConnection();
                connection.ConnectionString = $"Server={ServerName};Port={Port};User Id={User};Password={Password};Database={Database};";
                connection.Open();
                return connection;
            }
            catch (Exception)
            {
                throw;
            }
        }

        private void GetConnection()
        {
            try
            {
                NpgsqlCommand cmd = new NpgsqlCommand();
                cmd.Connection = GetConnectionString();
                if (cmd.Connection != null)
                {
                    cmd.CommandText = "select id,description,link from channels";
                    cmd.CommandType = CommandType.Text;

                    NpgsqlDataReader dr = cmd.ExecuteReader();
                    FeedList = new ObservableCollection<Feed>();
                    while (dr.Read())
                    {
                        var feed = new Feed();
                        feed.Id = (int)dr[0];
                        feed.Title = dr[1].ToString();
                        feed.Url = dr[2].ToString();
                        FeedList.Add(feed);
                    }
                }
                else
                {
                    return;
                }
            }
            catch (Exception e)
            {
                throw;
            }
        }
        
        private void GetFeedItemsFromDatabase()
        {
            var worker = new BackgroundWorker();
            worker.DoWork += (o, ea) =>
            {
                defaultFeedItems.Clear();
                NpgsqlCommand cmd = new NpgsqlCommand();
                cmd.Connection = GetConnectionString();
                if (SelectedFeed != null)
                {
                    if (SelectedFeed.Url != "All feed")
                        cmd.CommandText = "select title,link from articles where channel =" + SelectedFeed.Id;
                    else
                        cmd.CommandText = "select title,link from articles";
                }

                cmd.CommandType = CommandType.Text;

                NpgsqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    var feedItem = new FeedItem()
                    {
                        title = dr[0].ToString(),
                        link = dr[1].ToString()
                    };
                    defaultFeedItems.Add(feedItem);
                }
                Application.Current.Dispatcher.Invoke(DispatcherPriority.Background, new Action(() =>
                {
                    FeedItemsList = new ObservableCollection<FeedItem>(defaultFeedItems);
                }));
            };
            worker.RunWorkerCompleted += (o, ea) =>
            {
                IsListBusy = false;
            };
            worker.RunWorkerAsync();
        }

        private void GetFeedItems()
        {
            IsListBusy = true;
            var worker = new BackgroundWorker();
            worker.DoWork += (o, ea) =>
            {
                GetFeedItemsData();
            };
            worker.RunWorkerCompleted += (o, ea) =>
            {
                IsListBusy = false;
            };
            worker.RunWorkerAsync();
        }

        private void GetFeedItemsData()
        {
            if (SelectedFeed != null)
            {
                var itemList = new List<FeedItem>();
                if (SelectedFeed.Url != "All feed")
                {
                    XmlDocument xDoc = new XmlDocument();
                    xDoc.Load(SelectedFeed.Url);

                    foreach (var item in xDoc.GetElementsByTagName("item"))
                    {
                        var items = JsonConvert.DeserializeObject<Root>(JsonConvert.SerializeObject(item)).Item.ToFeedItem();
                        itemList.Add(items);
                    }
                }
                else
                {
                    foreach (var feedUrl in FeedList.Where(x => x.Url != "All feed").ToList())
                    {
                        XmlDocument xDoc = new XmlDocument();
                        xDoc.Load(feedUrl.Url);

                        foreach (var item in xDoc.GetElementsByTagName("item"))
                        {
                            var items = JsonConvert.DeserializeObject<Root>(JsonConvert.SerializeObject(item)).Item.ToFeedItem();
                            itemList.Add(items);
                        }
                    }
                }

                var uniqueFeeds = itemList.Where(y => !defaultFeedItems.Any(df => df.link == y.link)).ToList();

                InsertData(uniqueFeeds, SelectedFeed.Id);

                Application.Current.Dispatcher.Invoke(DispatcherPriority.Background, new Action(() =>
                {
                    foreach (var item in uniqueFeeds)
                    {
                        defaultFeedItems.Add(item);
                    }
                    FeedItemsList = new ObservableCollection<FeedItem>(itemList);
                }));
            }
        }

        private void InsertData(List<FeedItem> feedItems, int id)
        {
            NpgsqlCommand cmd = new NpgsqlCommand();
            cmd.Connection = GetConnectionString();
            foreach (var item in feedItems)
            {
                cmd = new NpgsqlCommand();
                cmd.Connection = GetConnectionString();
                cmd.CommandText = "Insert into articles(title,description,content,link,is_read,timestamp,channel) values(@title,@description,@content,@link,@is_read,@timestamp,@channel)";
                cmd.CommandType = CommandType.Text;
                cmd.Parameters.Add(new NpgsqlParameter("@title", item.title));
                cmd.Parameters.Add(new NpgsqlParameter("@description", item.description));
                cmd.Parameters.Add(new NpgsqlParameter("@content", item.ContentEncoded));
                cmd.Parameters.Add(new NpgsqlParameter("@link", item.link));
                cmd.Parameters.Add(new NpgsqlParameter("@is_read", false));
                cmd.Parameters.Add(new NpgsqlParameter("@timestamp", Convert.ToDateTime(item.pubDate)));
                cmd.Parameters.Add(new NpgsqlParameter("@channel", id));
                cmd.ExecuteNonQuery();
                cmd.Dispose();
            }
        }

        private void GetFeedUrl()
        {
            IsWebBrowserVisible = true;
            FeedUrl = null;
            IsBusy = true;
            var worker = new BackgroundWorker();
            worker.DoWork += (o, ea) =>
            {
                Application.Current.Dispatcher.Invoke(DispatcherPriority.Background, new Action(() =>
                {
                    if (SelectedFeedItem != null)
                    {
                        FeedUrl = new Uri(SelectedFeedItem.link);
                    }
                }));
            };
            worker.RunWorkerCompleted += (o, ea) =>
            {
                IsBusy = false;
            };
            worker.RunWorkerAsync();
        }
        private void ChangeTheme(Grid grid)
        {
            var color = (Brush)(new BrushConverter().ConvertFrom("#20262F"));
            var bg = grid.Background as Brush;
            if (grid.Background.ToString() == color.ToString())
            {
                grid.Background = Brushes.White;
                Foreground = Brushes.Black;
                HumbergerIcon = "pack://application:,,,/Icons/humbergerBlack.png";
                RefreshIcon = "pack://application:,,,/Icons/refreshblack.png";
                ThemeIcon = "pack://application:,,,/Icons/themeicon.png";
                Arrow = "pack://application:,,,/Icons/navigateblack.png";
                RightArrow = "pack://application:,,,/Icons/rightarrowblack.png";
            }
            else
            {
                grid.Background = (Brush)(new BrushConverter().ConvertFrom("#20262F"));
                Foreground = Brushes.White;
                HumbergerIcon = "pack://application:,,,/Icons/humbergerwhite.png";
                RefreshIcon = "pack://application:,,,/Icons/refreshwhite.png";
                ThemeIcon = "pack://application:,,,/Icons/themeiconwhite.png";
                Arrow = "pack://application:,,,/Icons/navigatewhite.png";
                RightArrow = "pack://application:,,,/Icons/rightarrowwhite.png";
            }
        }

        public event PropertyChangedEventHandler PropertyChanged;
        protected void OnPropertyChanged([CallerMemberName] string name = null)
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(name));
        }
    }

    public static class Utility
    {
        public static FeedItem ToFeedItem(this Item item)
        {
            return new FeedItem()
            {
                link = item.link,
                title = item.title,
                pubDate = item.pubDate,
                ContentEncoded = item.ContentEncoded.CdataSection,
                description = item.description.CdataSection
            };
        }
    }
    public class Feed
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public string Url { get; set; }
    }

    public class FeedItem
    {
        public string title { get; set; }
        public string link { get; set; }
        public string pubDate { get; set; }
        public string description { get; set; }
        public string ContentEncoded { get; set; }
    }

    public class Description
    {
        [JsonProperty("#cdata-section")]
        public string CdataSection { get; set; }
    }

    public class ContentEncoded
    {
        [JsonProperty("#cdata-section")]
        public string CdataSection { get; set; }
    }

    public class Item
    {
        public string title { get; set; }
        public string link { get; set; }
        public string pubDate { get; set; }
        public Description description { get; set; }

        [JsonProperty("content:encoded")]
        public ContentEncoded ContentEncoded { get; set; }
    }

    public class Root
    {
        public Item Item { get; set; }
    }
}
