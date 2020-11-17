using FileExplorerApp.Enums;
using FileExplorerApp.Structs;
using FileExplorerApp.Utils;
using System;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Windows.Interop;
using System.Windows.Media;
using System.Windows.Media.Imaging;

namespace FileExplorerApp.Models
{
    public class FileSystemObjectInfo : BaseModel
    {
        public FileSystemObjectInfo()
        {

        }
        public FileSystemObjectInfo(FileSystemInfo info)
        {
           
            if (this is DummyFileSystemObjectInfo)
            {
                return;
            }
            UpdateFileSystem(info);
        }

        public FileSystemObjectInfo(DriveInfo drive)
        {
            if (this is DummyFileSystemObjectInfo)
            {
                return;
            }
            UpdateFileSystem(drive.RootDirectory, drive);
        }

        private void UpdateFileSystem(FileSystemInfo info, DriveInfo drive = null)
        {
            Children = new ObservableCollection<FileSystemObjectInfo>();
            FileSystemInfo = info;

            if (FileSystemInfo is DirectoryInfo)
            {
                FileInfo = ShellManager.GetFileInfo(FileSystemInfo.FullName, ItemType.Folder, new Size(16, 16));
                if ((drive != null && drive.IsReady) || (drive == null && Directory.GetDirectories(FileSystemInfo.FullName).Count() > 0))
                {
                    AddDummy();
                }
            }
            else if (FileSystemInfo is FileInfo)
            {
                FileInfo = ShellManager.GetFileInfo(FileSystemInfo.FullName, ItemType.File, new Size(16, 16));
                FileInfo.Size = $"{Math.Ceiling(((System.IO.FileInfo)FileSystemInfo).Length / 1024.00).ToString("N0")} KB";
            }

            PropertyChanged += new PropertyChangedEventHandler(FileSystemObjectInfo_PropertyChanged);
        }
        #region Events

        public event EventHandler BeforeExpand;

        public event EventHandler AfterExpand;

        public event EventHandler BeforeExplore;

        public event EventHandler AfterExplore;

        private void RaiseBeforeExpand()
        {
            BeforeExpand?.Invoke(this, EventArgs.Empty);
        }

        private void RaiseAfterExpand()
        {
            AfterExpand?.Invoke(this, EventArgs.Empty);
        }

        private void RaiseBeforeExplore()
        {
            BeforeExplore?.Invoke(this, EventArgs.Empty);
        }

        private void RaiseAfterExplore()
        {
            AfterExplore?.Invoke(this, EventArgs.Empty);
        }

        #endregion

        #region EventHandlers

        void FileSystemObjectInfo_PropertyChanged(object sender, PropertyChangedEventArgs e)
        {
            if (FileSystemInfo is DirectoryInfo)
            {
                if (string.Equals(e.PropertyName, "IsExpanded", StringComparison.CurrentCultureIgnoreCase))
                {
                    RaiseBeforeExpand();
                    if (IsExpanded)
                    {
                        //ImageSource = ShellManager.GetIcon(FileInfo.hIcon, new Size(16, 16));
                        if (HasDummy())
                        {
                            RaiseBeforeExplore();
                            RemoveDummy();
                            ExploreDirectories();
                            //if (IsDetailView)
                            //{
                            //    ExploreFiles();
                            //}
                            RaiseAfterExplore();
                        }
                    }
                    else
                    {
                        //ImageSource = ShellManager.GetIcon(FileInfo.hIcon, new Size(16, 16));
                    }
                    RaiseAfterExpand();
                }
            }
        }

        #endregion

        #region Properties

        public ObservableCollection<FileSystemObjectInfo> Children
        {
            get { return GetValue<ObservableCollection<FileSystemObjectInfo>>("Children"); }
            private set { SetValue("Children", value); }
        }

        public ImageSource ImageSource
        {
            get { return GetValue<ImageSource>("ImageSource"); }
            private set { SetValue("ImageSource", value); }
        }


        public FileinfoObj FileInfo
        {
            get { return GetValue<FileinfoObj>("FileInfo"); }
            private set { SetValue("FileInfo", value); }
        }

        public bool IsExpanded
        {
            get { return GetValue<bool>("IsExpanded"); }
            set { SetValue("IsExpanded", value); }
        }

        public FileSystemInfo FileSystemInfo
        {
            get { return GetValue<FileSystemInfo>("FileSystemInfo"); }
            private set { SetValue("FileSystemInfo", value); }
        }

        public DriveInfo Drive
        {
            get { return GetValue<DriveInfo>("Drive"); }
            set { SetValue("Drive", value); }
        }

        #endregion

        #region Methods

        private void AddDummy()
        {
            Children.Add(new DummyFileSystemObjectInfo());
        }

        private bool HasDummy()
        {
            return GetDummy() != null;
        }

        private DummyFileSystemObjectInfo GetDummy()
        {
            return Children.OfType<DummyFileSystemObjectInfo>().FirstOrDefault();
        }

        private void RemoveDummy()
        {
            Children.Remove(GetDummy());
        }

        private void ExploreDirectories()
        {
            if (Drive?.IsReady == false)
            {
                return;
            }
            if (FileSystemInfo is DirectoryInfo)
            {
                var directories = ((DirectoryInfo)FileSystemInfo).GetDirectories();
                foreach (var directory in directories.OrderBy(d => d.Name))
                {
                    if ((directory.Attributes & FileAttributes.System) != FileAttributes.System &&
                        (directory.Attributes & FileAttributes.Hidden) != FileAttributes.Hidden)
                    {
                        var fileSystemObject = new FileSystemObjectInfo(directory);
                        fileSystemObject.BeforeExplore += FileSystemObject_BeforeExplore;
                        fileSystemObject.AfterExplore += FileSystemObject_AfterExplore;
                        Children.Add(fileSystemObject);
                    }
                }
            }
        }

        private void FileSystemObject_AfterExplore(object sender, EventArgs e)
        {
            RaiseAfterExplore();
        }

        private void FileSystemObject_BeforeExplore(object sender, EventArgs e)
        {
            RaiseBeforeExplore();
        }

        //private void ExploreFiles()
        //{
        //    if (Drive?.IsReady == false)
        //    {
        //        return;
        //    }
        //    if (FileSystemInfo is DirectoryInfo)
        //    {
        //        var files = ((DirectoryInfo)FileSystemInfo).GetFiles();
        //        foreach (var file in files.OrderBy(d => d.Name))
        //        {
        //            if ((file.Attributes & FileAttributes.System) != FileAttributes.System &&
        //                (file.Attributes & FileAttributes.Hidden) != FileAttributes.Hidden)
        //            {
        //                Children.Add(new FileSystemObjectInfo(file));
        //            }
        //        }
        //    }
        //}

        #endregion
    }
}
