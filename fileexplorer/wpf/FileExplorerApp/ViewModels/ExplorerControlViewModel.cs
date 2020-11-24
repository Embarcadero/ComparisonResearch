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
using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;

namespace FileExplorerApp.ViewModels
{
    public class ExplorerControlViewModel : INotifyPropertyChanged
    {
        public ExplorerControlViewModel()
        {
            FilesSource = new ObservableCollection<FileSystemObjectInfo>();
            DetailFilesSource = new ObservableCollection<FileSystemObjectInfo>();
            InitializeFileSystemObjects();
            LoadCurrentPathCommand = new RelayCommand(OnLoadCurrentPathCommand);
            TreeViewSelectionChanged = new RelayCommand<RoutedPropertyChangedEventArgs<object>>(OnTreeViewSelectionChanged);
            TreeViewPreviewMouseDown = new RelayCommand<MouseButtonEventArgs>(OnTreeViewPreviewMouseDown);
            DeatailViewSelectionChanged = new RelayCommand<SelectionChangedEventArgs>(OnDeatailViewSelectionChanged);
            SearchText = string.Empty;
            SearchFilesSource = new ObservableCollection<FileinfoObj>();
            SearchCommand = new RelayCommand(FilterData);
            ClearCommand = new RelayCommand(OnClearCommand);
            SearchMode = false;
        }

        private void OnClearCommand()
        {
            SearchText = string.Empty;
        }

        public ICommand SearchCommand { get; set; }
        public ICommand ClearCommand { get; set; }

        private string _searchText;

        public string SearchText
        {
            get { return _searchText; }
            set { _searchText = value; OnPropertyChanged(nameof(SearchText)); }
        }

        private ObservableCollection<FileinfoObj> _searchFilesSource;
        public ObservableCollection<FileinfoObj> SearchFilesSource
        {
            get { return _searchFilesSource; }
            set { _searchFilesSource = value; OnPropertyChanged(nameof(SearchFilesSource)); }
        }

        private bool _searchMode;

        public bool SearchMode
        {
            get { return _searchMode; }
            set { _searchMode = value; OnPropertyChanged(nameof(SearchMode)); ChangeSearchButtonText(); }
        }

        private string _searchButtonText;

        public string SearchButtonText
        {
            get { return _searchButtonText; }
            set { _searchButtonText = value; OnPropertyChanged(nameof(SearchButtonText)); }
        }

        private void ChangeSearchButtonText()
        {
            if (SearchMode)
            {
                SearchButtonText = "Clear";
            }
            else
            {
                SearchButtonText = "Search";
                SearchText = string.Empty;
            }
        }
        private void FilterData()
        {
            if (!string.IsNullOrEmpty(SearchText.Trim()))
            {
                Application.Current.Dispatcher.Invoke(() =>
                {
                    SearchFilesSource.Clear();
                });
                var worker = new BackgroundWorker();
                worker.DoWork += (o, ea) =>
                {
                    SearchMode = true;
                    if (SearchMode)
                    {
                        GetSearchedFiles((DirectoryInfo)selectedFileObject.FileSystemInfo);
                    }
                };
                worker.RunWorkerCompleted += (o, ea) =>
                {

                };
                worker.RunWorkerAsync();
            }
        }
        private void GetSearchedFiles(DirectoryInfo directoryInfo)
        {
            if (!string.IsNullOrEmpty(SearchText.Trim()))
            {
                if (directoryInfo is DirectoryInfo)
                {
                    var directories = ((DirectoryInfo)directoryInfo).GetDirectories();
                    foreach (var directory in directories.OrderBy(d => d.Name))
                    {
                        if ((directory.Attributes & FileAttributes.System) != FileAttributes.System &&
                            (directory.Attributes & FileAttributes.Hidden) != FileAttributes.Hidden)
                        {
                            if (directory.Name.ToLower().Contains(SearchText.ToLower()))
                            {
                                UdpateSearchList(directory.FullName, ItemType.Folder, directory.Name, directory.LastWriteTime);
                            }
                            GetSearchedFiles(directory);
                        }
                    }

                    var files = ((DirectoryInfo)directoryInfo).GetFiles();
                    foreach (var file in files.OrderBy(d => d.Name).Where(g => g.Name.ToLower().Contains(SearchText.ToLower())))
                    {
                        if ((file.Attributes & FileAttributes.System) != FileAttributes.System &&
                            (file.Attributes & FileAttributes.Hidden) != FileAttributes.Hidden)
                        {
                            if (file.Name.ToLower().Contains(SearchText.ToLower()))
                            {
                                UdpateSearchList(file.FullName, ItemType.File, file.Name, file.LastWriteTime);
                            }
                        }
                    }
                }
            }
        }
        private void UdpateSearchList(string fullName, ItemType itemType, string name, DateTime dateTime)
        {
            var worker = new BackgroundWorker();
            worker.DoWork += (o, ea) =>
            {
                var fileInfoObj = ShellManager.GetFileInfo(fullName, itemType, new System.Drawing.Size(16, 16));
                fileInfoObj.Name = name;
                fileInfoObj.LastWriteTime = dateTime;
                Application.Current.Dispatcher.Invoke(() =>
                {
                    SearchFilesSource.Add(fileInfoObj);
                    SearchFilesSource = SearchFilesSource;
                });
                NumberOfDetailItems = $"{SearchFilesSource.Count} items";
            };
            worker.RunWorkerCompleted += (o, ea) =>
            {

            };
            worker.RunWorkerAsync();
        }
        private void OnDeatailViewSelectionChanged(SelectionChangedEventArgs obj)
        {
            if (obj.Source is DataGrid)
            {
                SelectedDetailFileCount = ((DataGrid)obj.Source).SelectedItems.Count;
            }
        }

        private bool IsTreeViewSelectionEditable { get; set; }
        private void OnTreeViewPreviewMouseDown(MouseButtonEventArgs obj)
        {
            IsTreeViewSelectionEditable = true;
        }

        private void OnTreeViewSelectionChanged(RoutedPropertyChangedEventArgs<object> obj)
        {
            if (IsTreeViewSelectionEditable)
            {
                SearchMode = false;
                selectedFileObject = obj.NewValue as FileSystemObjectInfo;
                UpdateDetailFiles();
                IsTreeViewSelectionEditable = false;
            }
        }

        public ICommand TreeViewSelectionChanged { get; set; }
        public ICommand TreeViewPreviewMouseDown { get; set; }
        public ICommand DeatailViewSelectionChanged { get; set; }

        private void OnLoadCurrentPathCommand()
        {
            if (Path.IsPathRooted(Currentpath) && Directory.Exists(Currentpath))
            {
                PreSelect(Currentpath);
                PreviousCurrentPath = Currentpath;
            }
            else
            {
                Currentpath = PreviousCurrentPath;
            }
        }

        public ICommand LoadCurrentPathCommand { get; set; }

        private string PreviousCurrentPath { get; set; }

        private string _currentPath;

        public string Currentpath
        {
            get { return _currentPath; }
            set { _currentPath = value; OnPropertyChanged(nameof(Currentpath)); }
        }

        private int _selectedDetailFileCount;
        public int SelectedDetailFileCount
        {
            get { return _selectedDetailFileCount; }
            set { _selectedDetailFileCount = value; OnPropertyChanged(nameof(SelectedDetailFileCount)); }
        }


        private string _headerText;
        public string HeaderText
        {
            get { return _headerText; }
            set { _headerText = value; OnPropertyChanged(nameof(HeaderText)); }
        }


        private FileSystemObjectInfo selectedFileObject { get; set; }
        private void UpdateDetailFiles()
        {
            if (selectedFileObject != null)
            {
                if (selectedFileObject.FileInfo != null)
                {
                    var currentPath = selectedFileObject.FileInfo.FilePath;
                    PreviousCurrentPath = currentPath;
                    Currentpath = currentPath;
                    HeaderText = selectedFileObject.FileInfo.Name;
                }

                DetailFilesSource = new ObservableCollection<FileSystemObjectInfo>();
                if (selectedFileObject.Drive?.IsReady == false)
                {
                    return;
                }
                if (selectedFileObject.FileSystemInfo is DirectoryInfo)
                {
                    var directories = ((DirectoryInfo)selectedFileObject.FileSystemInfo).GetDirectories();
                    foreach (var directory in directories.OrderBy(d => d.Name))
                    {
                        if ((directory.Attributes & FileAttributes.System) != FileAttributes.System &&
                            (directory.Attributes & FileAttributes.Hidden) != FileAttributes.Hidden)
                        {
                            DetailFilesSource.Add(new FileSystemObjectInfo(directory));
                        }
                    }

                    var files = ((DirectoryInfo)selectedFileObject.FileSystemInfo).GetFiles();
                    foreach (var file in files.OrderBy(d => d.Name))
                    {
                        if ((file.Attributes & FileAttributes.System) != FileAttributes.System &&
                            (file.Attributes & FileAttributes.Hidden) != FileAttributes.Hidden)
                        {
                            DetailFilesSource.Add(new FileSystemObjectInfo(file));
                        }
                    }
                    NumberOfDetailItems = $"{DetailFilesSource.Count} items";
                    //SelectedDetailFiles = DetailFilesSource;
                }
            }
        }

        private string _numberOfDetailItems;

        public string NumberOfDetailItems
        {
            get { return _numberOfDetailItems; }
            set { _numberOfDetailItems = value; OnPropertyChanged(nameof(NumberOfDetailItems)); }
        }


        private ObservableCollection<FileSystemObjectInfo> _detailFilesSource;
        public ObservableCollection<FileSystemObjectInfo> DetailFilesSource
        {
            get { return _detailFilesSource; }
            set { _detailFilesSource = value; OnPropertyChanged(nameof(DetailFilesSource)); }
        }



        private void InitializeFileSystemObjects()
        {
            var drives = DriveInfo.GetDrives();

            drives.ToList().ForEach(drive =>
            {
                var fileSystemObject = new FileSystemObjectInfo(drive);
                fileSystemObject.BeforeExplore += FileSystemObject_BeforeExplore;
                fileSystemObject.AfterExplore += FileSystemObject_AfterExplore;
                FilesSource.Add(fileSystemObject);
            });

            PreSelect(Environment.GetFolderPath(Environment.SpecialFolder.UserProfile), true);
            //SelectedFileObject = 
        }

        private ObservableCollection<FileSystemObjectInfo> _filesSource;
        public ObservableCollection<FileSystemObjectInfo> FilesSource
        {
            get { return _filesSource; }
            set { _filesSource = value; OnPropertyChanged(nameof(FilesSource)); }
        }


        private void FileSystemObject_AfterExplore(object sender, System.EventArgs e)
        {
            //Cursor = Cursors.Arrow;
        }

        private void FileSystemObject_BeforeExplore(object sender, System.EventArgs e)
        {
            //Cursor = Cursors.Wait;
        }


        private void PreSelect(string path, bool isDefaultPath = false)
        {
            if (!Directory.Exists(path))
            {
                return;
            }
            var driveFileSystemObjectInfo = GetDriveFileSystemObjectInfo(path);
            driveFileSystemObjectInfo.IsExpanded = isDefaultPath;
            driveFileSystemObjectInfo.GetDetailNodes = !isDefaultPath;
            PreSelect(driveFileSystemObjectInfo, path, isDefaultPath);
        }

        public string NormalizePath(string path)
        {
            return Path.GetFullPath(new Uri(path).LocalPath)
                       .TrimEnd(Path.DirectorySeparatorChar, Path.AltDirectorySeparatorChar)
                       .ToUpperInvariant();
        }

        private void PreSelect(FileSystemObjectInfo fileSystemObjectInfo,
            string path, bool isDefaultPath)
        {
            if (fileSystemObjectInfo.Drive != null
                && IsParentPath(path, fileSystemObjectInfo.FileSystemInfo.FullName)
                && fileSystemObjectInfo.FileSystemInfo.FullName.Contains(path))
            {
                //fileSystemObjectInfo.IsSelected = true;
                selectedFileObject = fileSystemObjectInfo;
                UpdateDetailFiles();
            }
            else
            {
                foreach (var childFileSystemObjectInfo in fileSystemObjectInfo.Children)
                {
                    var isParentPath = IsParentPath(path, childFileSystemObjectInfo.FileSystemInfo.FullName);
                    if (isParentPath)
                    {
                        if (string.Equals(NormalizePath(childFileSystemObjectInfo.FileSystemInfo.FullName), NormalizePath(path)))
                        {
                            childFileSystemObjectInfo.IsSelected = isDefaultPath;
                            selectedFileObject = childFileSystemObjectInfo;
                            UpdateDetailFiles();
                        }
                        else
                        {
                            childFileSystemObjectInfo.IsExpanded = isDefaultPath;
                            childFileSystemObjectInfo.GetDetailNodes = !isDefaultPath;
                            PreSelect(childFileSystemObjectInfo, path, isDefaultPath);
                        }
                    }
                }
            }
        }


        private FileSystemObjectInfo GetDriveFileSystemObjectInfo(string path)
        {
            var directory = new DirectoryInfo(path);
            var drive = DriveInfo
                .GetDrives()
                .Where(d => d.RootDirectory.FullName == directory.Root.FullName)
                .FirstOrDefault();
            return GetDriveFileSystemObjectInfo(drive);
        }

        private FileSystemObjectInfo GetDriveFileSystemObjectInfo(DriveInfo drive)
        {
            foreach (var fso in FilesSource.OfType<FileSystemObjectInfo>())
            {
                if (fso.FileSystemInfo.FullName == drive.RootDirectory.FullName)
                {
                    return fso;
                }
            }
            return null;
        }

        private bool IsParentPath(string path,
            string targetPath)
        {
            return (path.ToLower().StartsWith(targetPath.ToLower())) || (targetPath.ToLower().StartsWith(path.ToLower()));
        }


        public event PropertyChangedEventHandler PropertyChanged;

        protected void OnPropertyChanged(string propertyName)
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
        }
    }
}
