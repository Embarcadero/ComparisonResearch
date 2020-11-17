using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading.Tasks;

namespace FileExplorerApp.Structs
{
    [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Auto)]
    public struct ShellFileInfo
    {
        public IntPtr hIcon;

        public int iIcon;

        public uint dwAttributes;

        [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 260)]
        public string szDisplayName;

        [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 80)]
        public string szTypeName;
    }
}
