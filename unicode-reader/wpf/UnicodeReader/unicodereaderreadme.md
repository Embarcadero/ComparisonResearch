# Directions to Create the Unicode Reader Using WPF.

### Requirements:-
Either Visual Studio 2017 or 2019
   <br/>.NET Version 4.6.1 or above

## Initial Setup
- Open Visual studio Editor.
- Go to "File" => "New" => "Project".
- Select "Wpf app (.NET framework)" from New Project dialog.
- Give the project name ***"UnicodeReader"*** then click OK.

- The Project will contain three files:
1. MainWindow.xaml
2. App.xaml
3. App.config

### <b>Some packages needs to be installed by NugetPackegeManeger.</b>

1. Right click the Solution in the Solution Explorer
2. Select "Manage NuGet Packages for Solution"
3. Select "Browse" and search for "MVVMLightLibs"
4. Then press the Install Button.
5. Follow the same instructions for below packages

        1 - CommonServiceLocator and select the Version 2.0.2
        2 - Newtonsoft.json
        3 - WpfAnimatedGif
        4 - EntityFramework
        5 - Npgsql

<br/><div style="text-align:center"><a href="https://ibb.co/gVRy1wB"><img src="https://i.ibb.co/gVRy1wB/Nuget-Package.png" alt="Nuget-Package" border="0"></a></div>

## Add Icons

- Create ***Icons*** Folder

    Follow the below instruction to create the folder.
<br/><div style="text-align:center"><a href="https://ibb.co/dcQ6WrY"><img src="https://i.ibb.co/dcQ6WrY/Create-Folder.png" alt="Create-Folder" border="0"></a></div>

    Add the image inside this folder with below instructions
<br/><div style="text-align:center"><a href="https://ibb.co/V9DyfXx"><img src="https://i.ibb.co/V9DyfXx/AddIsons.png" alt="AddIsons" border="0"></a></div>

    Paste Images in the folder and go to visual studio and follow instructions 
<br/><div style="text-align:center"><a href="https://ibb.co/44jNKkF"><img src="https://i.ibb.co/44jNKkF/Include-Icons.png" alt="Include-Icons" border="0"></a></div>

Here is the code for ***"MainWindowViewmodel.cs"***

    Follow the below instruction to create the class.
<br/><div style="text-align:center"><a href="https://ibb.co/BZgQzK0"><img src="https://i.ibb.co/BZgQzK0/Create-Class.png" alt="Create-Class" border="0"></a></div>
    
```
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
```

# Graphical User Interface

## MainWindow.xaml

Add a namespace for datacontext class in MainWindow: 

`xmlns:local="clr-namespace:UnicodeReader"`

Add a namespace for add gif image
`xmlns:gif="http://wpfanimatedgif.codeplex.com"`

Set the Title properties of mainwindow
```
Title="Unicode Reader"
```

Build the solution then add the datacontext below to MainWindow.xaml
```
<Window.DataContext>
    <local:MainWindowViewmodel/>
</Window.DataContext>
```

By default the mainwindow.xaml will contain the below code.
```
<Grid>

</Grid>
```
We will refer to this as the ***"Main Grid"*** 

Please refer to attached screen shot to understand the structure.
<br/><div style="text-align:center"><a href="https://ibb.co/x7q439n"><img src="https://i.ibb.co/x7q439n/MainGrid.png" alt="MainGrid" border="0"></a></div>

### Button styles
We are creating the style for buttons inside the  ****<Window.Resources>****

Add resource inside "Window"
```
<Window.Resources>

</Window.Resources>
```

Add the style code below inside the above code
```
<Style x:Key="ButtonHoverStyle" TargetType="{x:Type Button}">
    <Setter Property="OverridesDefaultStyle" Value="True" />
    <Setter Property="Background" Value="Transparent"/>
    <Setter Property="Template">
        <Setter.Value>
            <ControlTemplate TargetType="{x:Type Button}">
                <Border Background="{TemplateBinding Background}" BorderBrush="Black" BorderThickness="0">
                        <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                </Border>
            </ControlTemplate>
        </Setter.Value>
    </Setter>
    <Style.Triggers>
        <Trigger Property="IsMouseOver" Value="True">
            <Setter Property="Background" Value="#00A1A1"/>
        </Trigger>
    </Style.Triggers>
</Style>
```

### Grid Layout

Set main grid properties
```
x:Name="mainGrid" 
Background="{Binding Background,UpdateSourceTrigger=PropertyChanged}"
```

The main grid will split into two rows.
```
<Grid.RowDefinitions>
    <RowDefinition Height="50"/>
    <RowDefinition Height="*"/>
</Grid.RowDefinitions>
```

## First row of main grid
In the first row we display Toggle button and two buttons to change theme and refresh data.

Add Grid for first row
```
<Grid>
</Grid>
```

Add Togglebutton inside the grid
```
<ToggleButton IsChecked="{Binding IsBackDropVisible}" Width="50" HorizontalAlignment="Left" ToolTip="Server Connection" Margin="0 5 5 5">
        <Image Source="{Binding HumbergerIcon,UpdateSourceTrigger=PropertyChanged}"/>
</ToggleButton>
```

Add style for toggle button
```
<ToggleButton.Style>
    <Style TargetType="{x:Type ToggleButton}">
        <Setter Property="OverridesDefaultStyle" Value="True" />
        <Setter Property="Background" Value="Transparent"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="{x:Type ToggleButton}">
                            <Border Background="{TemplateBinding Background}" BorderBrush="Black" BorderThickness="0">
                                    <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                            </Border>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
            <Style.Triggers>
                <Trigger Property="IsMouseOver" Value="True">
                    <Setter Property="Background" Value="#00A1A1"/>
                </Trigger>
            </Style.Triggers>
    </Style>
</ToggleButton.Style>
```

Add stackpanel inside the grid to display buttons.
```
<StackPanel HorizontalAlignment="Right" Orientation="Horizontal">
    <Button x:Name="changeTheme" Command="{Binding ThemeCommand,UpdateSourceTrigger=PropertyChanged}" CommandParameter="{Binding ElementName=mainGrid}"
    ToolTip="Change Theme" Width="50" Margin="5 5 0 5" Style="{StaticResource ButtonHoverStyle}">
            <Image Source="{Binding ThemeIcon,UpdateSourceTrigger=PropertyChanged}"/>
    </Button>
    <Button x:Name="refreshFeed" Command="{Binding RefreshCommand,UpdateSourceTrigger=PropertyChanged}" ToolTip="Import Feed" Width="50" Margin=" 0 5 5 5" Style="{StaticResource ButtonHoverStyle}">
            <Image Source="{Binding RefreshIcon,UpdateSourceTrigger=PropertyChanged}"/>
    </Button>
</StackPanel>
```

## Second row of main grid
In the second row we will display two listboxes to display FeedList and FeedItems in listbox and add web browser to display content.

Add grid for second row
```
<Grid>
</Grid>
```

Add five columns inside the grid.
```
<Grid.ColumnDefinitions>
    <ColumnDefinition Width="25*" MinWidth="30"/>
    <ColumnDefinition Width="Auto"/>
    <ColumnDefinition Width="30*" MinWidth="30"/>
    <ColumnDefinition Width="Auto"/>
    <ColumnDefinition Width="60*"/>
</Grid.ColumnDefinitions>
```

Please refer to attached screen shot to understand the structure.

<br/><div style="text-align:center"><a href="https://ibb.co/M291qLW"><img src="https://i.ibb.co/M291qLW/GridRow.png" alt="GridRow" border="0"></a></div>

Add stack panel inside first column.
```
<StackPanel Background="Transparent" MinWidth="150" HorizontalAlignment="Left">
</StackPanel>
```

Add stack panel style for visibility.
```
<StackPanel.Style>
    <Style TargetType="StackPanel">
        <Setter Property="Visibility" Value="Collapsed"/>
        <Style.Triggers>
            <DataTrigger Binding="{Binding IsBackDropVisible}" Value="True">
                <Setter Property="Visibility" Value="Visible"/>
            </DataTrigger>
        </Style.Triggers>
    </Style>
</StackPanel.Style>
```

Add Grid inside the stack panel.
```
<Grid Margin="0 30 0 0">
</Grid>
```

Add two columns and six rows inside grid.
```
<Grid.ColumnDefinitions>
    <ColumnDefinition Width="Auto"/>
    <ColumnDefinition Width="*"/>
</Grid.ColumnDefinitions>
<Grid.RowDefinitions>
    <RowDefinition/>
    <RowDefinition/>
    <RowDefinition/>
    <RowDefinition/>
    <RowDefinition/>
    <RowDefinition/>
</Grid.RowDefinitions>
```

Add Labels, Textboxes and Button to connect with database.
```
<Label Content="Server" Foreground="{Binding Foreground, UpdateSourceTrigger=PropertyChanged}" Margin="5"/>
<TextBox Text="{Binding ServerName,UpdateSourceTrigger=PropertyChanged}" Grid.Column="1" Background="Transparent" Margin="5" Foreground="{Binding Foreground, UpdateSourceTrigger=PropertyChanged}"/>

<Label Content="Port" Foreground="{Binding Foreground, UpdateSourceTrigger=PropertyChanged}" Grid.Row="1"  Margin="5"/>
<TextBox Text="{Binding Port,UpdateSourceTrigger=PropertyChanged}" Grid.Column="1" Grid.Row="1" Background="Transparent"  Margin="5" Foreground="{Binding Foreground, UpdateSourceTrigger=PropertyChanged}"/>

<Label Content="User" Foreground="{Binding Foreground, UpdateSourceTrigger=PropertyChanged}" Grid.Row="2" Margin="5"/>
<TextBox Text="{Binding User,UpdateSourceTrigger=PropertyChanged}" Grid.Column="1" Grid.Row="2" Background="Transparent" Margin="5" Foreground="{Binding Foreground, UpdateSourceTrigger=PropertyChanged}"/>

<Label Content="Password" Foreground="{Binding Foreground, UpdateSourceTrigger=PropertyChanged}" Grid.Row="3" Margin="5"/>
<TextBox Text="{Binding Password,UpdateSourceTrigger=PropertyChanged}" Grid.Column="1" Grid.Row="3" Background="Transparent" Margin="5" Foreground="{Binding Foreground, UpdateSourceTrigger=PropertyChanged}"/>

<Label Content="Database" Foreground="{Binding Foreground, UpdateSourceTrigger=PropertyChanged}" Grid.Row="4" Margin="5"/>
<TextBox Text="{Binding Database,UpdateSourceTrigger=PropertyChanged}" Grid.Column="1" Grid.Row="4" Background="Transparent" Margin="5" Foreground="{Binding Foreground, UpdateSourceTrigger=PropertyChanged}"/>

<Button Content="ConnectButton" Command="{Binding ConnectCommand,UpdateSourceTrigger=PropertyChanged}" Grid.Row="5" Grid.ColumnSpan="2" Margin="5"/>
```

Add Grid in the first column to disply Feed list data.
```
<Grid>
</Grid>
```

Add Grid style for visibility.
```
<Grid.Style>
    <Style TargetType="Grid">
        <Setter Property="Visibility" Value="Visible"/>
            <Style.Triggers>
                <DataTrigger Binding="{Binding IsBackDropVisible}" Value="True">
                    <Setter Property="Visibility" Value="Collapsed"/>
                </DataTrigger>
            </Style.Triggers>
    </Style>
</Grid.Style>
```

Add Listbox inside Grid
```
<ListBox x:Name="feed" ItemsSource="{Binding FeedList,UpdateSourceTrigger=PropertyChanged}" Background="Transparent" VerticalAlignment="Stretch"
Foreground="{Binding Foreground, UpdateSourceTrigger=PropertyChanged}" SelectedItem="{Binding SelectedFeed,UpdateSourceTrigger=PropertyChanged}"
ScrollViewer.HorizontalScrollBarVisibility="Disabled">
    <ListBox.ItemTemplate>
        <DataTemplate>
            <StackPanel>
                <Grid>
                    <Grid.ColumnDefinitions>
                        <ColumnDefinition Width="Auto"/>
                        <ColumnDefinition Width="*"/>
                        <ColumnDefinition Width="30"/>
                    </Grid.ColumnDefinitions>
                        <Image DataContext="{Binding RelativeSource={RelativeSource Mode=FindAncestor, AncestorType=Window}, Path=DataContext}" HorizontalAlignment="Left" Source="{Binding Arrow,UpdateSourceTrigger=PropertyChanged}" Height="20" Width="20"  VerticalAlignment="Center"/>
                            <Grid Grid.Column="1">
                                <Grid.RowDefinitions>
                                    <RowDefinition/>
                                    <RowDefinition/>
                                </Grid.RowDefinitions>
                                    <TextBlock Text="{Binding Title}" TextTrimming="CharacterEllipsis" Margin="5 5 5 0" />
                                    <TextBlock Text="{Binding Url}" TextTrimming="CharacterEllipsis" Margin="5 0 5 0" Grid.Row="1"/>
                            </Grid>
                                    <Image DataContext="{Binding RelativeSource={RelativeSource Mode=FindAncestor, AncestorType=Window}, Path=DataContext}" HorizontalAlignment="Right"
                                       Source="{Binding RightArrow,UpdateSourceTrigger=PropertyChanged}" Height="10" Width="10" VerticalAlignment="Center" Grid.Column="2" Margin="10" />
                </Grid>
                <Separator Opacity="1" Foreground="{Binding Foreground, UpdateSourceTrigger=PropertyChanged}"/>
            </StackPanel>
        </DataTemplate>
    </ListBox.ItemTemplate>
</ListBox>
```

Add style inside listbox resources
```
<ListBox.Resources>
    <Style TargetType="{x:Type ListBoxItem}">
        <Setter Property="Template">
            <Setter.Value>
                <ControlTemplate TargetType="{x:Type ListBoxItem}">
                    <Border x:Name="Bd" BorderBrush="{TemplateBinding BorderBrush}" >
                        <ContentPresenter/>
                    </Border>
                    <ControlTemplate.Triggers>
                        <MultiTrigger>
                            <MultiTrigger.Conditions>
                                <Condition Property="IsSelected" Value="True" />
                            </MultiTrigger.Conditions>
                                <Setter Property="Background" TargetName="Bd" Value="#00A1A1" />
                        </MultiTrigger>
                    </ControlTemplate.Triggers>
                </ControlTemplate>
            </Setter.Value>
        </Setter>
    </Style>
</ListBox.Resources>
```

In the second column add grid splitter

```
<GridSplitter HorizontalAlignment="Center" VerticalAlignment="Stretch" Grid.Column="1" Width="5" Background="Silver"/>
```

In the third column Add ListBox to display FeedItems List and add Grid for spinner.
```
<ListBox x:Name="feedItems" ItemsSource="{Binding FeedItemsList,UpdateSourceTrigger=PropertyChanged}" Background="Transparent" 
Foreground="{Binding Foreground, UpdateSourceTrigger=PropertyChanged}" SelectedItem="{Binding SelectedFeedItem,UpdateSourceTrigger=PropertyChanged}" 
HorizontalContentAlignment="Stretch" ScrollViewer.HorizontalScrollBarVisibility="Disabled" MinWidth="20">
    <ListBox.ItemTemplate>
        <DataTemplate>
            <StackPanel>
                <Grid>
                    <Grid.ColumnDefinitions>
                        <ColumnDefinition Width="Auto"/>
                        <ColumnDefinition Width="*"/>
                        <ColumnDefinition Width="30"/>
                    </Grid.ColumnDefinitions>
                    <Image DataContext="{Binding RelativeSource={RelativeSource Mode=FindAncestor, AncestorType=Window}, Path=DataContext}" HorizontalAlignment="Left" Source="{Binding Arrow,UpdateSourceTrigger=PropertyChanged}" Height="20" Width="20"  VerticalAlignment="Center"/>
                                    
                    <Grid Grid.Column="1">
                        <Grid.RowDefinitions>
                            <RowDefinition/>
                            <RowDefinition/>
                        </Grid.RowDefinitions>
                            <TextBlock Text="{Binding title}" TextTrimming="CharacterEllipsis" Margin="5 5 5 0" />
                            <TextBlock Text="{Binding link}" TextTrimming="CharacterEllipsis" Margin="5 0 5 0" Grid.Row="1"/>
                    </Grid>
                    <Image DataContext="{Binding RelativeSource={RelativeSource Mode=FindAncestor, AncestorType=Window}, Path=DataContext}" HorizontalAlignment="Right"
                    Source="{Binding RightArrow,UpdateSourceTrigger=PropertyChanged}" Height="10" Width="10" VerticalAlignment="Center" Grid.Column="2" Margin="10" />
                </Grid>
                <Separator Opacity="1" Foreground="{Binding Foreground, UpdateSourceTrigger=PropertyChanged}"/>
            </StackPanel>
        </DataTemplate>
    </ListBox.ItemTemplate>
</ListBox>
```

Add style inside listbox resources
```
<ListBox.Resources>
    <Style TargetType="{x:Type ListBoxItem}">
        <Setter Property="Template">
            <Setter.Value>
                <ControlTemplate TargetType="{x:Type ListBoxItem}">
                    <Border x:Name="Bd" BorderBrush="{TemplateBinding BorderBrush}" >
                        <ContentPresenter/>
                    </Border>
                    <ControlTemplate.Triggers>
                        <MultiTrigger>
                            <MultiTrigger.Conditions>
                                <Condition Property="IsSelected" Value="True" />
                            </MultiTrigger.Conditions>
                            <Setter Property="Background" TargetName="Bd" Value="#00A1A1" />
                        </MultiTrigger>
                    </ControlTemplate.Triggers>
                </ControlTemplate>
            </Setter.Value>
        </Setter>
    </Style>
</ListBox.Resources>
```

Add style for visibility
```
<ListBox.Style>
    <Style TargetType="{x:Type ListBox}">
        <Setter Property="Visibility" Value="Visible" />
        <Style.Triggers>
            <DataTrigger Binding="{Binding IsListBusy}" Value="True">
                <Setter Property="Visibility" Value="Collapsed" />
            </DataTrigger>
        </Style.Triggers>
    </Style>
</ListBox.Style>
```

Add Grid for spinner
```
<Grid Name="spinnerGridList">
    <Image Width="115" Height="115" gif:ImageBehavior.AnimatedSource="Spinner.gif" />
</Grid>
```

Add style for visibility inside grid
```
<Grid.Style>
    <Style TargetType="{x:Type Grid}">
        <Setter Property="Visibility" Value="Collapsed" />
        <Style.Triggers>
            <DataTrigger Binding="{Binding IsListBusy}" Value="True">
                <Setter Property="Visibility" Value="Visible" />
            </DataTrigger>
        </Style.Triggers>
    </Style>
</Grid.Style>
```

In the forth column add grid splitter
```
<GridSplitter HorizontalAlignment="Center" VerticalAlignment="Stretch" Grid.Column="3" Width="5" Background="Silver"/>
```

In the fifth column add two grid to display webbrowser and spinner.

Add grid for webbrowser
```
<Grid x:Name="feedGrid" Grid.Column="4">
</Grid>
```

Add style for above grid visibility
```
<Grid.Style>
    <Style TargetType="{x:Type Grid}">
    <Setter Property="Visibility" Value="Visible" />
        <Style.Triggers>
            <DataTrigger Binding="{Binding IsBusy}" Value="True">
                <Setter Property="Visibility" Value="Collapsed" />
            </DataTrigger>
        </Style.Triggers>
    </Style>
</Grid.Style>
```

Add webbrowser inside the grid.
```
<WebBrowser x:Name="feedData"  Opacity="0" OpacityMask="{x:Null}" Navigated="feedData_Navigated"
local:MainWindow.BindableSource="{Binding FeedUrl,UpdateSourceTrigger=PropertyChanged}">
</WebBrowser>
```

Add style for WebBrowser
```
<WebBrowser.Style>
    <Style TargetType="WebBrowser">
        <Setter Property="Visibility" Value="Hidden"/>
        <Style.Triggers>
            <DataTrigger Binding="{Binding IsWebBrowserVisible}" Value="True">
                <Setter Property="Visibility" Value="Visible" />
            </DataTrigger>
        </Style.Triggers>
    </Style>
</WebBrowser.Style>
```

Add Grid for spinner 
```
 <Grid Name="spinnerGrid" Grid.Column="4">
    <Image Width="115" Height="115" gif:ImageBehavior.AnimatedSource="Spinner.gif" />
 </Grid>
```

Add style for above grid
```
<Grid.Style>
    <Style TargetType="{x:Type Grid}">
        <Setter Property="Visibility" Value="Hidden" />
        <Setter Property="Background" Value="Transparent"/>
        <Style.Triggers>
            <DataTrigger Binding="{Binding IsBusy}" Value="True">
                <Setter Property="Visibility" Value="Visible" />
            </DataTrigger>
        </Style.Triggers>
    </Style>
</Grid.Style>
```

## MainWindow.xaml.cs

Add Namespace
```
using System;
using System.Reflection;
using System.Runtime.InteropServices;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Navigation;
```

In Constructor add navigated event handler
```
feedData.Navigated += new NavigatedEventHandler(feedData_Navigated);
```

Create dependanct property to bind source in Web Browser.
```
public static readonly DependencyProperty BindableSourceProperty = DependencyProperty.RegisterAttached("BindableSource", typeof(string), typeof(MainWindow), new UIPropertyMetadata(null, BindableSourcePropertyChanged));

public static string GetBindableSource(DependencyObject obj)
{
    return (string)obj.GetValue(BindableSourceProperty);
}

public static void SetBindableSource(DependencyObject obj, string value)
{
    obj.SetValue(BindableSourceProperty, value);
}

public static void BindableSourcePropertyChanged(DependencyObject o, DependencyPropertyChangedEventArgs e)
{
    WebBrowser browser = o as WebBrowser;
    if (browser != null)
    {
        string uri = e.NewValue as string;
        browser.Source = !String.IsNullOrEmpty(uri) ? new Uri(uri) : null;
    }
}
```

Create Method and Interface to set WebBrowser silent
```
private void feedData_Navigated(object sender, NavigationEventArgs e)
{
    SetSilent(feedData, true);
}

public static void SetSilent(WebBrowser browser, bool silent)
{
    if (browser == null)
        throw new ArgumentNullException("browser");

    // get an IWebBrowser2 from the document
    IOleServiceProvider serviceProvider = browser.Document as IOleServiceProvider;
    if (serviceProvider != null)
    {
        Guid IID_IWebBrowserApp = new Guid("0002DF05-0000-0000-C000-000000000046");
        Guid IID_IWebBrowser2 = new Guid("D30C1661-CDAF-11d0-8A3E-00C04FC9E26E");

        object webBrowser;
        serviceProvider.QueryService(ref IID_IWebBrowserApp, ref IID_IWebBrowser2, out webBrowser);
        if (webBrowser != null)
        {
            webBrowser.GetType().InvokeMember("Silent", BindingFlags.Instance | BindingFlags.Public | BindingFlags.PutDispProperty, null, webBrowser, new object[] { silent });
        }
    }
}

[ComImport, Guid("6D5140C1-7436-11CE-8034-00AA006009FA"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
private interface IOleServiceProvider
{
    [PreserveSig]
    int QueryService([In] ref Guid guidService, [In] ref Guid riid, [MarshalAs(UnmanagedType.IDispatch)] out object ppvObject);
}
```