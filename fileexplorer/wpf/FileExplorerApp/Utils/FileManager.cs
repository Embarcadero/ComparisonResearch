using FileExplorerApp.Enums;
using System.Drawing;
using System.IO;
using System.Windows.Interop;
using System.Windows.Media;
using System.Windows.Media.Imaging;

namespace FileExplorerApp.Utils
{
    public static class FileManager
    {
        public static ImageSource GetImageSource(string filename)
        {
            return GetImageSource(filename, new Size(16, 16));
        }

        public static ImageSource GetImageSource(string filename, Size size)
        {
            using (var icon = ShellManager.GetIcon(Path.GetExtension(filename), ItemType.File))
            {
                return Imaging.CreateBitmapSourceFromHIcon(icon.Handle,
                    System.Windows.Int32Rect.Empty,
                    BitmapSizeOptions.FromWidthAndHeight(size.Width, size.Height));
            }
        }
    }
}
