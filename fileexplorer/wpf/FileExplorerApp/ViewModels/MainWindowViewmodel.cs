using FileExplorerApp.Enums;
using FileExplorerApp.Models;
using FileExplorerApp.Utils;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FileExplorerApp.ViewModels
{
    public class MainWindowViewmodel : INotifyPropertyChanged
    {
        public MainWindowViewmodel()
        {
            FilesSource = new ObservableCollection<FileSystemObjectInfo>();
            SelectedFileObject = new FileSystemObjectInfo();
            DetailFilesSource = new ObservableCollection<FileSystemObjectInfo>();
            SelectedDetailFiles = new ObservableCollection<FileSystemObjectInfo>();
            InitializeFileSystemObjects();

        }

        private string _currentPath;

        public string Currentpath
        {
            get { return _currentPath; }
            set { _currentPath = value; OnPropertyChanged(nameof(Currentpath)); }
        }


        private FileSystemObjectInfo _selectedFileObject;

        public FileSystemObjectInfo SelectedFileObject
        {
            get { return _selectedFileObject; }
            set { _selectedFileObject = value; OnPropertyChanged(nameof(SelectedFileObject)); UpdateDetailFiles(); }
        }

        private IList<FileSystemObjectInfo> _selectedDetailFileObject;

        public IList<FileSystemObjectInfo> SelectedDetailFiles
        {
            get { return _selectedDetailFileObject; }
            set { _selectedDetailFileObject = value; OnPropertyChanged(nameof(SelectedDetailFiles));
                SelectedDetailFileCount = SelectedDetailFiles == null ? 0 : SelectedDetailFiles.Count(); }
        }
        
        private int _selectedDetailFileCount;

        public int SelectedDetailFileCount
        {
            get { return _selectedDetailFileCount; }
            set { _selectedDetailFileCount = value; OnPropertyChanged(nameof(SelectedDetailFileCount)); }
        }

        private void UpdateDetailFiles()
        {
            if (SelectedFileObject.FileInfo != null)
            {
                Currentpath = SelectedFileObject.FileInfo.FilePath;
            }
            DetailFilesSource = new ObservableCollection<FileSystemObjectInfo>();
            if (SelectedFileObject.Drive?.IsReady == false)
            {
                return;
            }
            if (SelectedFileObject.FileSystemInfo is DirectoryInfo)
            {
                var directories = ((DirectoryInfo)SelectedFileObject.FileSystemInfo).GetDirectories();
                foreach (var directory in directories.OrderBy(d => d.Name))
                {
                    if ((directory.Attributes & FileAttributes.System) != FileAttributes.System &&
                        (directory.Attributes & FileAttributes.Hidden) != FileAttributes.Hidden)
                    {
                        var fileSystemObject = new FileSystemObjectInfo(directory);
                        fileSystemObject.BeforeExplore += FileSystemObject_BeforeExplore;
                        fileSystemObject.AfterExplore += FileSystemObject_AfterExplore;
                        DetailFilesSource.Add(fileSystemObject);
                    }
                }

                var files = ((DirectoryInfo)SelectedFileObject.FileSystemInfo).GetFiles();
                foreach (var file in files.OrderBy(d => d.Name))
                {
                    if ((file.Attributes & FileAttributes.System) != FileAttributes.System &&
                        (file.Attributes & FileAttributes.Hidden) != FileAttributes.Hidden)
                    {
                        DetailFilesSource.Add(new FileSystemObjectInfo(file));
                    }
                }

                NumberOfDetailItems = $"{DetailFilesSource.Count} items";
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

            PreSelect(Environment.GetFolderPath(Environment.SpecialFolder.UserProfile));
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


        private void PreSelect(string path)
        {
            if (!Directory.Exists(path))
            {
                return;
            }
            var driveFileSystemObjectInfo = GetDriveFileSystemObjectInfo(path);
            driveFileSystemObjectInfo.IsExpanded = true;
            PreSelect(driveFileSystemObjectInfo, path);
           
        }

        private void PreSelect(FileSystemObjectInfo fileSystemObjectInfo,
            string path)
        {
            foreach (var childFileSystemObjectInfo in fileSystemObjectInfo.Children)
            {
                var isParentPath = IsParentPath(path, childFileSystemObjectInfo.FileSystemInfo.FullName);
                if (isParentPath)
                {
                    if (string.Equals(childFileSystemObjectInfo.FileSystemInfo.FullName, path))
                    {
                        SelectedFileObject = childFileSystemObjectInfo;
                    }
                    else
                    {
                        childFileSystemObjectInfo.IsExpanded = true;
                        PreSelect(childFileSystemObjectInfo, path);
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
            return path.StartsWith(targetPath);
        }


        public event PropertyChangedEventHandler PropertyChanged;

        protected void OnPropertyChanged(string propertyName)
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
        }
    }
}
