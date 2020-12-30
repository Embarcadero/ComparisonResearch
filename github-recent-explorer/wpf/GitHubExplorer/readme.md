# Directions to Create the GitHub Explorer Using WPF.

### Requirements:-
Either Visual Studio 2017 or 2019
   <br/>.NET Version 4.6.1 or above

## Initial Setup
- Open Visual studio Editor.
- Go to "File" => "New" => "Project".
- Select "Wpf app (.NET framework)" from New Project dialog.
- Give the project name ***"GitHubExplorer"*** then click OK.

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

<div style="text-align:center"><a href="https://ibb.co/QnWtTFh"><img src="https://i.ibb.co/QnWtTFh/Install-Packages.png" alt="Install-Packages" border="0"></a></div>

## Models

- Create ***Models*** Folder
    Follow the below instruction to create the Model class files.
<br/><div style="text-align:center"><a href="https://ibb.co/rHG7mgh"><img src="https://i.ibb.co/rHG7mgh/Createfolder.png" alt="Createfolder" border="0"></a></div>


- Inside this folder Create below classes.
```
    GithubResult.cs
    Item.cs
    License.cs
    Repository.cs
```

Here is the code for ***"GithubResult.cs"***
```
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GitHubExplorer.Models
{
    public class GithubResult
    {
        public int total_count { get; set; }
        public bool incomplete_results { get; set; }
        public List<Item> items { get; set; }
    }
}
```

Here is the code for ***"Item.cs"***
```
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GitHubExplorer.Models
{
    public class Item
    {
        public int id { get; set; }
        public string full_name { get; set; }
        public string html_url { get; set; }
        public string description { get; set; }
        public string language { get; set; }
        public int stargazers_count { get; set; }
        public License license { get; set; }
        public string created_at { get; set; }
        public string updated_at { get; set; }
    }   
}
```

Here is the code for ***"License.cs"***
```
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GitHubExplorer.Models
{
    public class License
    {
        public string key { get; set; }
        public string name { get; set; }
        public string spdx_id { get; set; }
        public string url { get; set; }
        public string node_id { get; set; }
    }
}
```

Here is the code for ***"Repository.cs"***
```
using System;

namespace GitHubExplorer.Models
{
    public class Repository
    {
        public readonly int id;
        public readonly string title;
        public readonly string url;
        public readonly string description;
        public readonly string language;
        public readonly int stars;
        public readonly string license;
        public readonly string updatedate;
        public readonly string createdate;
        public readonly string representupdatedate;

        public Repository(int id,string title,string url,string description,string language,int stars,string license,string updatedate,string createdate)
        {
            this.id = id;
            this.title = title;
            this.url = url;
            this.description = description;
            this.language = language;
            this.stars = stars;
            this.license = license;
            this.updatedate = updatedate;
            this.createdate = createdate;
            representupdatedate = ConvertUpdateDateIntoUiData(updatedate);
        }

        private string ConvertUpdateDateIntoUiData(string date)
        {
            DateTime _date = DateTime.Parse(date);
            return "Updated on " + $"{_date.Month.ToString().PadLeft(2, '0')}/{_date.Day.ToString().PadLeft(2, '0')}/{_date.Year}";
        }
    }
}
```

### Add  Images 

- Create Folder "Resources"
    ##### ( Note - follow the same instruction to create folder what we used to create the Model folder )

Add the image inside this folder with below instructions
<br/><div style="text-align:center"><a href="https://ibb.co/wWSvkS0"><img src="https://i.ibb.co/wWSvkS0/Add-Images.png" alt="Add-Images" border="0"></a></div>

Paste Images in the folder and go to visual studio and follow instructions 
<br/><div style="text-align:center"><a href="https://ibb.co/RyjQrVB"><img src="https://i.ibb.co/RyjQrVB/Include-Images.png" alt="Include-Images" border="0"></a></div>

---

# Graphical User Interface

## UserControl
- Create Folder "UserControls"

##### ( Note - follow the same instruction to create folder what we used to create the Model folder )

- Create new Xaml haing name ***"GitRepositoryControl.xaml"***
<br/><div style="text-align:center"><a href="https://ibb.co/vjWQpJT"><img src="https://i.ibb.co/vjWQpJT/Add-User-Control.png" alt="Add-User-Control" border="0"></a></div>


By default the GitRepositoryControl.xaml will contain the below code.
```
<Grid>

</Grid>
```
Set Minimum and Maximum Height of MainGrid
```
<Grid MaxHeight="150" MaxWidth="720">

</Grid>
```

### Grid Layout
The main grid will split into 4 rows and 6 columns.

Please refer to attached screen shot to understand the structure.
<br/><div style="text-align:center"><a href="https://ibb.co/frNPgwt"><img src="https://i.ibb.co/frNPgwt/Git-Repository-Control.png" alt="Git-Repository-Control" border="0"></a></div>

Create 3 rows inside the main grid
```
    <Grid.RowDefinitions>
            <RowDefinition Height="Auto"></RowDefinition>
            <RowDefinition Height="Auto"></RowDefinition>
            <RowDefinition Height="Auto"></RowDefinition>
            <RowDefinition Height="10"></RowDefinition>
    </Grid.RowDefinitions>
```

Create 6 columns inside the main grid
```
    <Grid.ColumnDefinitions>
            <ColumnDefinition Width="15"></ColumnDefinition>
            <ColumnDefinition Width="24"></ColumnDefinition>
            <ColumnDefinition Width="50"></ColumnDefinition>
            <ColumnDefinition Width="Auto"></ColumnDefinition>
            <ColumnDefinition Width="Auto"></ColumnDefinition>
            <ColumnDefinition Width="*"></ColumnDefinition>
    </Grid.ColumnDefinitions>
```
## First row of main grid
In the first row we display Image and Button

Add image in first row and second column
```
<Grid Grid.Column="1"  VerticalAlignment="Stretch">
    <Image Width="16" Height="16" Source="pack://application:,,,/Resources/repos_image.png"></Image>
</Grid>
```

Add button in first row and third column
```
<Grid Grid.Column="2"  Grid.ColumnSpan="6" HorizontalAlignment="Left" >
    <Button Click="Title_Click" Content="{Binding Title}">
        <Button.Template>
                <ControlTemplate TargetType="{x:Type Button}">
                    <TextBlock  Cursor="Hand" Foreground="#0366d6" FontSize="13"  TextWrapping="Wrap"  Text="{TemplateBinding Content}" MaxHeight="42" VerticalAlignment="Stretch" TextTrimming="CharacterEllipsis"/>
                </ControlTemplate>
        </Button.Template>
    </Button>
</Grid>
```

## Second row of main grid
In the second row add TextBlock to display Description

Add TextBlock
```
<Grid Grid.Row="1" Grid.Column="2" Grid.ColumnSpan="6">
    <TextBlock Foreground="#24292e" FontSize="12" TextWrapping="Wrap" Text="{Binding Description}" MaxHeight="44" VerticalAlignment="Stretch" TextTrimming="CharacterEllipsis"/>
</Grid>
```

## Third row of main grid
In the third row we display stars, Language name, Licence name and updated date.

Add stackpanel in second column to display stars
```
<StackPanel Grid.Row="2" Grid.Column="2" Orientation="Horizontal">
    <Image Width="15" Source="pack://application:,,,/Resources/repos_star.png"></Image>
    <TextBlock Foreground="#586069" Margin="5 0 0 0" FontSize="10" TextWrapping="Wrap" Text="{Binding Stars}" MaxHeight="54" TextTrimming="CharacterEllipsis"></TextBlock>
</StackPanel>
```

Add stack panel in third column to display Language
```
<StackPanel Grid.Row="2" Grid.Column="3" Orientation="Horizontal">
    <Rectangle RadiusX="15" RadiusY="15" Width="13" Height="13" Fill="{Binding CircleColor}"/>
    <TextBlock Foreground="#586069" Margin="5 0 0 0" FontSize="10" TextWrapping="Wrap" Text="{Binding Language}" MaxHeight="54" TextTrimming="CharacterEllipsis"/>
</StackPanel>
```

Add Textblock in column four to display Licence name
```
<TextBlock Grid.Column="4" Grid.Row="2" Margin="15 0 0 0" Foreground="#586069" FontSize="10" TextWrapping="Wrap" Text="{Binding License}" MaxHeight="54" TextTrimming="CharacterEllipsis"/>
```

Add Textblock in column five to display Updated date
```
<TextBlock Grid.Column="5" Grid.ColumnSpan="3" Grid.Row="2" Margin="15 0 0 0" Foreground="#586069" FontSize="10" Text="{Binding LastUpdate}" MaxHeight="54" TextTrimming="CharacterEllipsis"/>
```

## Forth row of main grid

In the forth row is display line
```
<Separator Opacity="0.5" Grid.Row="3" Grid.Column="1" Grid.ColumnSpan="6"/>
```

## In the ***"GitRepositoryControl.xaml.cs"*** file

Add datacontext in constructor
```
    public GitRepositoryControl()
    {
        InitializeComponent();
        DataContext = this;
    }
```

Add dependancy properties 
```
public string Url
{
    get { return (string)GetValue(UrlProperty); }
    set { SetValue(UrlProperty, value); }
}

public static readonly DependencyProperty UrlProperty =
DependencyProperty.Register("Url", typeof(string), typeof(GitRepositoryControl), new PropertyMetadata(""));

public string Title
{
    get { return (string)GetValue(TitleProperty); }
    set { SetValue(TitleProperty, value); }
}

public static readonly DependencyProperty TitleProperty =
DependencyProperty.Register("Title", typeof(string), typeof(GitRepositoryControl), new PropertyMetadata(""));

public string Description
{
    get { return (string)GetValue(DescriptionProperty); }
    set { SetValue(DescriptionProperty, value); }
}

public static readonly DependencyProperty DescriptionProperty =
DependencyProperty.Register("Description", typeof(string), typeof(GitRepositoryControl), new PropertyMetadata(""));

public string Language
{
    get { return (string)GetValue(LanguageProperty); }
    set { SetValue(LanguageProperty, value); CircleColor = GetCircleColor(value); }
}

public static readonly DependencyProperty LanguageProperty =
DependencyProperty.Register("Language", typeof(string), typeof(GitRepositoryControl), new PropertyMetadata(""));

public int Stars
{
    get { return (int)GetValue(StarsProperty); }
    set { SetValue(StarsProperty, value); }
}

public static readonly DependencyProperty StarsProperty =
DependencyProperty.Register("Stars", typeof(int), typeof(GitRepositoryControl), new PropertyMetadata(0));

public string License
{
    get { return (string)GetValue(LicenseProperty); }
    set { SetValue(LicenseProperty, value); }
}

public static readonly DependencyProperty LicenseProperty =
DependencyProperty.Register("License", typeof(string), typeof(GitRepositoryControl), new PropertyMetadata(""));

public string LastUpdate
{
    get { return (string)GetValue(LastUpdateProperty); }
    set { SetValue(LastUpdateProperty, value); }
}

public static readonly DependencyProperty LastUpdateProperty =
DependencyProperty.Register("LastUpdate", typeof(string), typeof(GitRepositoryControl), new PropertyMetadata(""));

public string CircleColor
{
    get { return (string)GetValue(CircleColorProperty); }
    set { SetValue(CircleColorProperty, value); }
}

public static readonly DependencyProperty CircleColorProperty =
DependencyProperty.Register("CircleColor", typeof(string), typeof(GitRepositoryControl), new PropertyMetadata("Gray"));

```

Create method for Get languages color
```
        private string GetCircleColor(string lang)
        {
            switch (lang)
            {
                case "Pascal":
                    return "#E3F171";
                case "C#":
                    return "#178600";
                case "TypeScript":
                    return "#2b7489";
                case "CSS":
                    return "#563d7c";
                case "JavaScript":
                    return "#f1e05a";
                case "HTML":
                    return "#e34c26";
                case "Java":
                    return "#b07219";
                case "Python":
                    return "#3572A5";
                case "Jupyter Notebook":
                    return "#DA5B0B";
                case "Ruby":
                    return "#701516";
                case "PHP":
                    return "#4F5D95";
                default:
                    return "Gray";
            }
        }
```

Add button click method to open url in browser
```
private void Title_Click(object sender, RoutedEventArgs e)
{
    try
    {
        Process.Start(new ProcessStartInfo(Url));
    }
    catch (Exception)
    {
    }
}
```

Here is the code for ***"MainWindowViewmodel.cs"***
```
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

```
---

## MainWindow.xaml
Add a namespace for datacontext class in MainWindow: 

`xmlns:viewmodel="clr-namespace:GitHubExplorer"`

Add a namespace for add gif image

`xmlns:gif="http://wpfanimatedgif.codeplex.com"`

Set the Icon and Title properties of mainwindow
```
    Icon="Resources/git_logo.png"
    Title="Github Explorer"
```

Build the solution then add the datacontext below to MainWindow.xaml
```
<Window.DataContext>
    <viewmodel:MainWindowViewmodel/>
</Window.DataContext>
```

By default the mainwindow.xaml will contain the below code.
```
<Grid>

</Grid>
```
We will refer to this as the ***"Main Grid"*** 

Please refer to attached screen shot to understand the structure.
<br/><div style="text-align:center"><a href="https://ibb.co/3rmSvxJ"><img src="https://i.ibb.co/3rmSvxJ/MainGrid.png" alt="MainGrid" border="0"></a></div>

### Combobox styles
We are creating the style for textboxes inside the  ****<Window.Resources>****

Add resource inside "Window"
```
<Window.Resources>

</Window.Resources>
```

Add the style code below inside the above code
```
<ControlTemplate x:Key="ComboBoxToggleButton" TargetType="{x:Type ToggleButton}">
            <Grid>
                <Grid.ColumnDefinitions>
                    <ColumnDefinition />
                    <ColumnDefinition Width="20" />
                </Grid.ColumnDefinitions>
                <Border
                  x:Name="Border" 
                  Grid.ColumnSpan="2"
                  CornerRadius="0"
                  Background="#FF22334D"
                  BorderBrush="#192438"
                  BorderThickness="1" />
                <Path 
                  x:Name="Arrow"
                  Grid.Column="1"     
                  Fill="White"
                  HorizontalAlignment="Center"
                  VerticalAlignment="Center"
                  Data="M0,0 L0,2 L4,6 L8,2 L8,0 L4,4 z"
                />
            </Grid>
        </ControlTemplate>

        <ControlTemplate x:Key="ComboBoxTextBox" TargetType="{x:Type TextBox}">
            <Border x:Name="PART_ContentHost" Focusable="False" Background="{TemplateBinding Background}" />
        </ControlTemplate>

        <Style x:Key="{x:Type ComboBox}" TargetType="{x:Type ComboBox}">
            <Setter Property="OverridesDefaultStyle" Value="true"/>
            <Setter Property="ScrollViewer.HorizontalScrollBarVisibility" Value="Auto"/>
            <Setter Property="ScrollViewer.VerticalScrollBarVisibility" Value="Auto"/>
            <Setter Property="ScrollViewer.CanContentScroll" Value="true"/>
            <Setter Property="Foreground" Value="White"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="{x:Type ComboBox}">
                        <Grid>
                            <ToggleButton 
                            Name="ToggleButton" 
                            Template="{StaticResource ComboBoxToggleButton}" 
                            Grid.Column="2" 
                            Focusable="false"
                            IsChecked="{Binding Path=IsDropDownOpen,Mode=TwoWay,RelativeSource={RelativeSource TemplatedParent}}"
                            ClickMode="Press">
                            </ToggleButton>
                            <ContentPresenter Name="ContentSite" IsHitTestVisible="False"  Content="{TemplateBinding SelectionBoxItem}"
                            ContentTemplate="{TemplateBinding SelectionBoxItemTemplate}"
                            ContentTemplateSelector="{TemplateBinding ItemTemplateSelector}"
                            Margin="3,3,23,3"
                            VerticalAlignment="Center"
                            HorizontalAlignment="Left" />
                            
                            <Popup 
                            Name="Popup"
                            Placement="Bottom"
                            IsOpen="{TemplateBinding IsDropDownOpen}"
                            AllowsTransparency="True" 
                            Focusable="False"
                            PopupAnimation="Slide">

                                <Grid Name="DropDown"
                              SnapsToDevicePixels="True"                
                              MinWidth="{TemplateBinding ActualWidth}"
                              MaxHeight="{TemplateBinding MaxDropDownHeight}">
                                    <Border 
                                x:Name="DropDownBorder"
                                Background="#FF22334D"
                                BorderThickness="1"
                                BorderBrush="#FF22334D"/>
                                    <ScrollViewer Margin="4,6,4,6" SnapsToDevicePixels="True">
                                        <StackPanel IsItemsHost="True" KeyboardNavigation.DirectionalNavigation="Contained" />
                                    </ScrollViewer>
                                </Grid>
                            </Popup>
                        </Grid>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsEnabled" Value="false">
                                <Setter Property="Foreground" Value="#FF22334D"/>
                            </Trigger>
                            <Trigger Property="IsGrouping" Value="true">
                                <Setter Property="ScrollViewer.CanContentScroll" Value="false"/>
                            </Trigger>
                            <Trigger SourceName="Popup" Property="Popup.AllowsTransparency" Value="true">
                                <Setter TargetName="DropDownBorder" Property="CornerRadius" Value="0"/>
                                <Setter TargetName="DropDownBorder" Property="Margin" Value="0,2,0,0"/>
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
            <Style.Triggers>
            </Style.Triggers>
        </Style>

        <!-- SimpleStyles: ComboBoxItem -->
        <Style x:Key="{x:Type ComboBoxItem}" TargetType="{x:Type ComboBoxItem}">
            <Setter Property="SnapsToDevicePixels" Value="true"/>
            <Setter Property="Foreground" Value="White"/>
            <Setter Property="OverridesDefaultStyle" Value="true"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="{x:Type ComboBoxItem}">
                        <Border Name="Border"
                              Padding="2"
                              SnapsToDevicePixels="true">
                            <ContentPresenter />
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsHighlighted" Value="true">
                                <Setter TargetName="Border" Property="Background" Value="#FF22334D"/>
                            </Trigger>
                            <Trigger Property="IsEnabled" Value="false">
                                <Setter Property="Foreground" Value="#FF22334D"/>
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
</Style>
```

### Grid Layout
Set main grid background "#FF22334D"

The main grid will split into two rows.

Create two rows inside the main grid
```
<Grid.RowDefinitions>
    <RowDefinition Height="40"/>
    <RowDefinition Height="*"/>
</Grid.RowDefinitions>
```

## First row of main grid
In the first row we display Toggle button, Textblock, datepicker and combobox.

Add Grid for first row
```
<Grid>
</Grid>
```

Add Togglebutton inside the grid
```
<ToggleButton HorizontalAlignment="Left" Width="50"
IsChecked="{Binding IsBackDropVisible}" Background="Transparent">
            <Image Source="pack://application:,,,/Resources/HamburgerIcon.png"/>
</ToggleButton>
```

Add style for toggle button
```
<ToggleButton.Style>
    <Style TargetType="{x:Type ToggleButton}">
        <Setter Property="Template">
            <Setter.Value>
                    <ControlTemplate TargetType="ToggleButton">
                        <Border BorderBrush="{TemplateBinding BorderBrush}" Background="{TemplateBinding Background}">
                                    <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                        </Border>
                    </ControlTemplate>
                </Setter.Value>
        /Setter>
        <Style.Triggers>
            <Trigger Property="IsChecked" Value="True">
            <Setter Property="Background" Value="Transparent" />
        </Trigger>
        </Style.Triggers>
    </Style>
</ToggleButton.Style>
```

Add stackpanel inside the grid to display Textblock, Datepicker and Combobox.

```
<StackPanel HorizontalAlignment="Right" VerticalAlignment="Bottom" Orientation="Horizontal">
                <TextBlock Text="Created After" Margin="0 4 10 0" Foreground="White"/>
                <DatePicker Name="datePicker" SelectedDate="{Binding SelectedDate,UpdateSourceTrigger=PropertyChanged}" MinWidth="150" Margin="0 0 10 0"></DatePicker>
                <ComboBox MinWidth="150" Margin="0 0 10 0" ItemsSource="{Binding SortDataList,UpdateSourceTrigger=PropertyChanged}" 
                          SelectedIndex="2" SelectedItem="{Binding SelectedSortData,UpdateSourceTrigger=PropertyChanged}"></ComboBox>
</StackPanel>
```

## Second row of main grid
In the second row we display Languages list and textbox to search language and Items control to display repositories.

Add grid for second row
```
<Grid>
</Grid>
```

Add two columns inside the grid
```
<Grid.ColumnDefinitions>
    <ColumnDefinition Width="Auto"/>
    <ColumnDefinition Width="*"/>
</Grid.ColumnDefinitions>
```

Add stack panel inside first column and add textbox and listbox
```
<StackPanel Name="HamburgerMenu" Background="Transparent" MinWidth="150" HorizontalAlignment="Left">

<TextBox Name="searchTextbox" Text="{Binding SearchText,UpdateSourceTrigger=PropertyChanged}" Background="Transparent" Foreground="White" Margin="5 10 5 5"/>

<ListBox x:Name="languageList" ItemsSource="{Binding Languages,Mode=TwoWay}" Background="Transparent" Foreground="White" 
BorderThickness="0" Margin="10"  SelectionMode="Multiple"
SelectionChanged="languageList_SelectionChanged">
        <ListBox.ItemTemplate>
            <DataTemplate>
                <StackPanel Orientation="Horizontal">
                    <TextBlock Text="{Binding Name}" Margin="5"/>
                </StackPanel>
            </DataTemplate>
        </ListBox.ItemTemplate>
        <ListBox.ItemContainerStyle>
            <Style TargetType="{x:Type ListBoxItem}">
                <Setter Property="IsSelected" Value="{Binding Mode=TwoWay, Path=IsChecked}"/>
            </Style>
        </ListBox.ItemContainerStyle>
</ListBox>
```

Add stackpanel style
```
<StackPanel.Style>
    <Style TargetType="StackPanel">
        <Setter Property="Visibility" Value="Visible"/>
            <Style.Triggers>
                <DataTrigger Binding="{Binding IsBackDropVisible}" Value="True">
                        <Setter Property="Visibility" Value="Collapsed"/>
                </DataTrigger>
            </Style.Triggers>
    </Style>
</StackPanel.Style>
```

Add Grid for second column and set background white

Add ItemsControl inside the grid
```
<ScrollViewer>
    <ItemsControl x:Name="tStack" ItemsSource="{Binding RepositoryList,UpdateSourceTrigger=PropertyChanged}" Margin="0 10 0 0">
            <ItemsControl.ItemsPanel>
                <ItemsPanelTemplate>
                    <StackPanel HorizontalAlignment="Left" Orientation="Vertical"/>
                </ItemsPanelTemplate>
            </ItemsControl.ItemsPanel>
    </ItemsControl>
</ScrollViewer>
```

Add style for above grid
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

Add Grid for spinner in Second column and set grid background white

Add spinner image inside the grid
```
<Image Width="115" Height="115" gif:ImageBehavior.AnimatedSource="Spinner.gif" />
```

Add style for spinner grid
```
<Grid.Style>
    <Style TargetType="{x:Type Grid}">
        <Setter Property="Visibility" Value="Hidden" />
            <Style.Triggers>
                <DataTrigger Binding="{Binding IsBusy}" Value="True">
                    <Setter Property="Visibility" Value="Visible" />
                </DataTrigger>
            </Style.Triggers>
    </Style>
</Grid.Style>
```

### In MainWindow.xaml.cs
Add Method to select multiple items in list
```
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
```