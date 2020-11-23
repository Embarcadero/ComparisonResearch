using FileExplorerApp.Enums;
using FileExplorerApp.Structs;
using System;
using System.Drawing;
using System.IO;
using System.Runtime.InteropServices;
using System.Windows.Interop;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Threading;

namespace FileExplorerApp.Utils
{
    public class FileinfoObj 
    {
        public string FilePath { get; set; }
        public ImageSource Icon { get; set; }

        //private ImageSource _icon;

        //public ImageSource Icon
        //{
        //    get { return Dispatcher.CurrentDispatcher.Invoke(() => _icon);  }
        //    set { _icon = value; }
        //}

        public string Type { get; set; }

        public string Name { get; set; }
        public string Size { get; set; }

        public bool IsDirectory { get; set; }

        public DateTime LastWriteTime { get; set; }
    }
    public class ShellManager
    {
        //public static Icon GetIcon(string path, ItemType type)
        //{
        //    var fileInfo = new ShellFileInfo();
        //    var size = (uint)Marshal.SizeOf(fileInfo);

        //    uint dwFileAttributes = Interop.FILE_ATTRIBUTE.FILE_ATTRIBUTE_NORMAL | 
        //        (uint)(type == ItemType.Folder ? FileAttribute.Directory : FileAttribute.File);

        //    uint uFlags = (uint)(Interop.SHGFI.SHGFI_TYPENAME | Interop.SHGFI.SHGFI_USEFILEATTRIBUTES
        //        | (uint)ShellAttribute.LargeIcon | (uint)ShellAttribute.SmallIcon | (uint)ShellAttribute.OpenIcon |
        //        (uint)(ShellAttribute.Icon | ShellAttribute.UseFileAttributes));

        //    var result =  Interop.SHGetFileInfo(path, dwFileAttributes, out fileInfo, size, uFlags);

        //    if (result == IntPtr.Zero)
        //    {
        //        throw Marshal.GetExceptionForHR(Marshal.GetHRForLastWin32Error());
        //    }

        //    try
        //    {
        //        return (Icon)Icon.FromHandle(fileInfo.hIcon).Clone();
        //    }
        //    catch
        //    {
        //        throw;
        //    }
        //    finally
        //    {
        //        Interop.DestroyIcon(fileInfo.hIcon);
        //    }
        //}

        public static ImageSource GetIcon(IntPtr icon, Size size)
        {

            try
            {
                using (var iconObj = (Icon)Icon.FromHandle(icon).Clone())
                {
                    return Imaging.CreateBitmapSourceFromHIcon(iconObj.Handle,
                  System.Windows.Int32Rect.Empty,
                  BitmapSizeOptions.FromWidthAndHeight(size.Width, size.Height));
                }
            }
            catch
            {
                throw;
            }
            finally
            {
                Interop.DestroyIcon(icon);
            }
            return null;
        }

        public static FileinfoObj GetFileInfo(string path, ItemType type,Size iconSize)
        {
            var fileInfoObj = new FileinfoObj();

            var fileInfo = new ShellFileInfo();
            var size = (uint)Marshal.SizeOf(fileInfo);

            uint dwFileAttributes = Interop.FILE_ATTRIBUTE.FILE_ATTRIBUTE_NORMAL |
                (uint)(type == ItemType.Folder ? FileAttribute.Directory : FileAttribute.File);

            uint uFlags = (uint)(Interop.SHGFI.SHGFI_TYPENAME | Interop.SHGFI.SHGFI_USEFILEATTRIBUTES
                | (uint)ShellAttribute.LargeIcon | (uint)ShellAttribute.SmallIcon | (uint)ShellAttribute.OpenIcon |
                (uint)(ShellAttribute.Icon | ShellAttribute.UseFileAttributes));

            var result = Interop.SHGetFileInfo(path, dwFileAttributes, out fileInfo, size, uFlags);
            var size1 = (uint)Marshal.SizeOf(fileInfo);
            if (result == IntPtr.Zero)
            {
                throw Marshal.GetExceptionForHR(Marshal.GetHRForLastWin32Error());
            }

            try
            {
                var iconObj = (Icon)Icon.FromHandle(fileInfo.hIcon).Clone();
                var iconImageSOurce = Imaging.CreateBitmapSourceFromHIcon(iconObj.Handle,
                  System.Windows.Int32Rect.Empty,
                  BitmapSizeOptions.FromWidthAndHeight(iconSize.Width, iconSize.Height));

                iconImageSOurce.Freeze();
                Dispatcher.CurrentDispatcher.Invoke(() => fileInfoObj.Icon = iconImageSOurce);

                //fileInfoObj.Icon = iconImageSOurce;
                fileInfoObj.FilePath = path;
                fileInfoObj.Type = fileInfo.szTypeName;
                fileInfoObj.IsDirectory = type == ItemType.Folder;

                return fileInfoObj;
            }
            catch(Exception e)
            {
                throw;
            }
            finally
            {
                Interop.DestroyIcon(fileInfo.hIcon);
            }
        }
    }
}
