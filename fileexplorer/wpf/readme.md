# Directions to Recreate the Windows File Explorer Using WPF. 

### Requirements:-
Either Visual Studio 2017 or 2019
   <br/>.NET Version 4.6.1 or above
   

## Initial Setup
- Open Visual studio Editor.
- Go to "File" => "New" => "Project".
- Select "Wpf app (.NET framework)" from New Project dialog.
- Give the project name ***"FileExplorerApp"*** then click OK.

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
        2 - System.IO.FileSystem

<a href="https://ibb.co/Hqqy9Cn"><img src="https://i.ibb.co/XttPGDS/Reference.png" alt="Reference" border="0"></a>

## Enums

We need some enums to get rid out of hardcoaded string values.

Create below enum class files in ***"Enums Folder"*** 
1. FileAttribute.cs
2. IconSize.cs
3. ItemState.cs
4. ItemType.cs
5. ShellAttribute.cs

Follow the below instruction to create the enum class files.

<br/><div style="text-align:center">
<a href="https://ibb.co/HF5XfG8"><img src="https://i.ibb.co/HF5XfG8/Enums.png" alt="Enums"></a>
</div>


 ***FileAttribute.cs***

    namespace FileExplorerApp.Enums
    {
        public enum FileAttribute : uint
        {
            Directory = 16,
            File = 256
        }
    }


***IconSize.cs***

    namespace FileExplorerApp.Enums
    {
        public enum IconSize : short
        {
            Small,
            Large
        }
    }



***ItemState.cs***

    namespace FileExplorerApp.Enums
    {
        public enum ItemState : short
        {
            Undefined,
            Open,
            Close
        }
    }

***ItemType.cs***

    namespace FileExplorerApp.Enums
    {
        public enum ItemType
        {
            Drive,
            Folder,
            File
        }
    }



***ShellAttribute.cs***


    using System;

    namespace FileExplorerApp.Enums
    {
        [Flags]
        public enum ShellAttribute : uint
        {
            LargeIcon = 0,              // 0x000000000
            SmallIcon = 1,              // 0x000000001
            OpenIcon = 2,               // 0x000000002
            ShellIconSize = 4,          // 0x000000004
            Pidl = 8,                   // 0x000000008
            UseFileAttributes = 16,     // 0x000000010
            AddOverlays = 32,           // 0x000000020
            OverlayIndex = 64,          // 0x000000040
            Others = 128,               // Not defined, really?
            Icon = 256,                 // 0x000000100  
            DisplayName = 512,          // 0x000000200
            TypeName = 1024,            // 0x000000400
            Attributes = 2048,          // 0x000000800
            IconLocation = 4096,        // 0x000001000
            ExeType = 8192,             // 0x000002000
            SystemIconIndex = 16384,    // 0x000004000
            LinkOverlay = 32768,        // 0x000008000 
            Selected = 65536,           // 0x000010000
            AttributeSpecified = 131072 // 0x000020000
        }
    }




# Graphical User Interface

## UserControl

- Create Folder "UserControls"
    ##### ( Note - follow the same instruction to create folder what we used to create the enum folder )
- Create new Xaml haing name ***"ExplorerControl.xaml"*** <br/><div style="text-align:center"><a href="https://ibb.co/CvGRgJ2"><img src="https://i.ibb.co/CvGRgJ2/User-Control.png" alt="User-Control" border="0"></a></div>



By default the ExplorerControl.xaml will contain the below code.
```
<Grid>

</Grid>
```

### Textbox Styles
We are creating the style for textboxes inside the  ****<UserControl.Resources>****

Add resource inside "UserControl"
```
<UserControl.Resources>

</UserControl.Resources>
```

Add the style code below inside the above code
```
<Style TargetType="{x:Type TextBox}">
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="{x:Type TextBox}">
                        <Grid>
                            <Border x:Name="border" Background="White" BorderBrush="{TemplateBinding BorderBrush}" BorderThickness="1" CornerRadius="5"/>
                            <ScrollViewer x:Name="PART_ContentHost" Margin="5,0,0,0" VerticalAlignment="Center" />
                            <Label Margin="5,0,0,0" x:Name="WaterMarkLabel" Content="{TemplateBinding Tag}" VerticalAlignment="Center"
                               Visibility="Collapsed" Foreground="Gray" FontFamily="Arial"/>
                        </Grid>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsFocused" Value="True">
                                <Setter Property="BorderBrush" TargetName="border" Value="black"/>
                                <Setter Property="BorderThickness" TargetName="border" Value="2"/>
                            </Trigger>
                            <MultiTrigger>
                                <MultiTrigger.Conditions>
                                    <Condition Property="Text" Value=""/>
                                </MultiTrigger.Conditions>
                                <Setter Property="Visibility" TargetName="WaterMarkLabel" Value="Visible"/>
                            </MultiTrigger>
                            <Trigger Property="IsEnabled" Value="False">
                                <Setter Property="Foreground" Value="DimGray"/>
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>
```

### Grid Layout
The main grid will split into 3 rows.

Please refer to attached screen shot to understand the structure. 

<div style="text-align:center"><a href="https://ibb.co/W5Qbgfn"><img src="https://i.ibb.co/W5Qbgfn/GridRows.png" alt="GridRows" border="0"></a></div>

Create 3 row inside the main grid
```
<Grid.RowDefinitions>
   <RowDefinition Height="Auto"/>
   <RowDefinition Height="*"/>
   <RowDefinition Height="Auto"/>
</Grid.RowDefinitions>
```

---

## First Row of Main Grid (Header Row)
In first row we need 3 columns to display textboxes and buttons.

<div style="text-align:center"><a href="https://ibb.co/qBhB1vn"><img src="https://i.ibb.co/qBhB1vn/Grid-Column-Row1.png" alt="Grid-Column-Row1" border="0"></a></div>

Create Grid inside the Main Grid for Header row 
```
<Grid>

</Grid>
```

Add 3 columns in Header row
```
<Grid.ColumnDefinitions>
    <ColumnDefinition Width="*"/>
    <ColumnDefinition Width="Auto"/>
    <ColumnDefinition Width="Auto"/>
</Grid.ColumnDefinitions>
```
- In First Column of Header grid add Textbox for display Path
```
 <TextBox Text="{Binding Currentpath,UpdateSourceTrigger=PropertyChanged}" Height="25"  Margin="2 0 2 0">
        <TextBox.InputBindings>
            <KeyBinding Key="Enter" Command="{Binding LoadCurrentPathCommand}" />
        </TextBox.InputBindings>
 </TextBox>
```

- In second column of Header grid add Textbox for Search
```
<TextBox x:Name="txtSearch" Margin="2 0 0 0" Height="25" HorizontalAlignment="Left" VerticalAlignment="Center"
Tag="Search" Grid.Column="1" Width="150" Text="{Binding SearchText,UpdateSourceTrigger=PropertyChanged}">
        <TextBox.InputBindings>
            <KeyBinding Key="Enter" Command="{Binding SearchCommand}" />
        </TextBox.InputBindings>
</TextBox>
```

- In third column of Header grid we have 2 buttons for "Search" and "Clear".
```
<StackPanel Grid.Column="2" Orientation="Horizontal">
        <Button  Margin="2" Content=" Search " Height="25" Command="{Binding SearchCommand}"/>
        <Button  Margin="2" Content=" Clear " Height="25" Command="{Binding ClearCommand}"/>
</StackPanel>
```

Add trigger to display button visible or collapsed inside the above stack panel

```
<StackPanel.Style>
    <Style TargetType="StackPanel">
        <Setter Property="Visibility" Value="Visible"/>
        <Style.Triggers>
            <DataTrigger Binding="{Binding SearchText}" Value="">
                <Setter Property="Visibility" Value="Collapsed"/>
            </DataTrigger>
        </Style.Triggers>
    </Style>
</StackPanel.Style>
```
---
## In Second Row
In second row we need 2 columns to display Treeview and Datagrid.
<br><div style="text-align:center"><a href="https://ibb.co/7GWbB9v"><img src="https://i.ibb.co/7GWbB9v/Grid-Column-Row2.png" alt="Grid-Column-Row2" border="0"></a></div>

Add new Grid for second row of Main grid
```
<Grid>

</Grid>
```

Create two columns inside above grid.
```
<Grid.ColumnDefinitions>
    <ColumnDefinition Width="3*"/>
    <ColumnDefinition Width="7*"/>
</Grid.ColumnDefinitions>
```

- Add the tree view inside the first column
```
<TreeView x:Name="treeView" Margin="5" ItemsSource="{Binding FilesSource}">
                <i:Interaction.Triggers>
                    <i:EventTrigger EventName="SelectedItemChanged">
                        <cmd:EventToCommand Command="{Binding TreeViewSelectionChanged}" PassEventArgsToCommand="True"/>
                    </i:EventTrigger>
                    <i:EventTrigger EventName="PreviewMouseDown">
                        <cmd:EventToCommand Command="{Binding TreeViewPreviewMouseDown}" PassEventArgsToCommand="True"/>
                    </i:EventTrigger>
                </i:Interaction.Triggers>
                <TreeView.ItemContainerStyle>
                    <Style TargetType="{x:Type TreeViewItem}">
                        <Setter Property="IsSelected" Value="{Binding IsSelected, Mode=TwoWay}" />
                        <Setter Property="IsExpanded" Value="{Binding IsExpanded, Mode=TwoWay}" />
                        <Setter Property="KeyboardNavigation.AcceptsReturn" Value="True" />
                    </Style>
                </TreeView.ItemContainerStyle>
                <TreeView.Resources>
                    <HierarchicalDataTemplate DataType="{x:Type classes:FileSystemObjectInfo}" ItemsSource="{Binding Path=Children}">
                        <StackPanel Orientation="Horizontal">
                            <Image Source="{Binding Path=FileInfo.Icon, UpdateSourceTrigger=PropertyChanged}" Margin="0,1,8,1"></Image>
                            <TextBlock Text="{Binding Path=DriveLabel}"></TextBlock>
                            <TextBlock Text="{Binding Path=FileInfo.Name}"></TextBlock>
                        </StackPanel>
                    </HierarchicalDataTemplate>
                </TreeView.Resources>
</TreeView>
```

- In second column add 2 Datagrid
    Files detail grid (To show detail files)
    Search Files grid. (To show search result)

1. DataGrid for Files
```
<DataGrid ItemsSource="{Binding DetailFilesSource}"
SelectionMode="Extended" Background="White" RowHeaderWidth="0" IsReadOnly="True" AutoGenerateColumns="False" 
Grid.Column="1" GridLinesVisibility="None"
Margin="5" HorizontalContentAlignment="Stretch">

</DataGrid>
```
Add style in DataGrid
```
<DataGrid.Style>

</DataGrid.Style>
```
Add style code inside datagrid style
```
<Style TargetType="DataGrid">
    <Setter Property="Visibility" Value="Visible"/>
    <Style.Triggers>
            <DataTrigger Binding="{Binding SearchMode}" Value="True">
                <Setter Property="Visibility" Value="Collapsed"/>
            </DataTrigger>
    </Style.Triggers>
</Style>
```

Add interaction trigger inside datagrid for event when selected item change.
```
<i:Interaction.Triggers>
    <i:EventTrigger EventName="SelectionChanged">
        <cmd:EventToCommand Command="{Binding DeatailViewSelectionChanged}" PassEventArgsToCommand="True"/>
    </i:EventTrigger>

    <i:EventTrigger EventName="MouseDoubleClick">
        <cmd:EventToCommand Command="{Binding DetailGridDoubleClick}"  
        CommandParameter="{Binding Path=SelectedItem, RelativeSource={RelativeSource AncestorType=DataGrid}}" />
    </i:EventTrigger>
</i:Interaction.Triggers>
```

Add columns inside datagrid
```
<DataGrid.Columns>

</DataGrid.Columns>
```

Add below code inside datagrid columns
```
 <DataGridTemplateColumn Header="Name" Width="*">
                        <DataGridTemplateColumn.CellTemplate>
                            <DataTemplate>
                                <Grid Margin="2 0 0 0">
                                    <Grid.ColumnDefinitions>
                                        <ColumnDefinition Width="Auto"/>
                                        <ColumnDefinition Width="*"/>
                                    </Grid.ColumnDefinitions>
                                    <Image Source="{Binding Path=FileInfo.Icon, UpdateSourceTrigger=PropertyChanged}" Margin="0,1,8,1"></Image>
                                    <TextBlock Text="{Binding Path=FileSystemInfo.Name}" TextTrimming="CharacterEllipsis" Grid.Column="1"
                                               ToolTip="{Binding Text, RelativeSource={RelativeSource Self}}"></TextBlock>
                                </Grid>
                            </DataTemplate>
                        </DataGridTemplateColumn.CellTemplate>
                    </DataGridTemplateColumn>
                    <DataGridTextColumn Header="Date modified" Binding="{Binding FileSystemInfo.LastWriteTime, StringFormat=\{0:dd-MM-yyyy HH:mm tt\}}" Width="*">
                        <DataGridTextColumn.ElementStyle>
                            <Style TargetType="TextBlock">
                                <Setter Property="TextTrimming" Value="CharacterEllipsis"/>
                                <Setter Property="ToolTip" Value="{Binding Text, 
                                 RelativeSource={RelativeSource Self}}"/>
                            </Style>
                        </DataGridTextColumn.ElementStyle>
                    </DataGridTextColumn>
                    <DataGridTextColumn Header="Type" Binding="{Binding FileInfo.Type}" Width="*">
                        <DataGridTextColumn.ElementStyle>
                            <Style TargetType="TextBlock">
                                <Setter Property="TextTrimming" Value="CharacterEllipsis"/>
                                <Setter Property="ToolTip" Value="{Binding Text, 
                                 RelativeSource={RelativeSource Self}}"/>
                            </Style>
                        </DataGridTextColumn.ElementStyle>
                    </DataGridTextColumn>
                    <DataGridTextColumn Header="Size" Binding="{Binding FileInfo.Size}" Width="*">
                        <DataGridTextColumn.ElementStyle>
                            <Style TargetType="TextBlock">
                                <Setter Property="TextTrimming" Value="CharacterEllipsis"/>
                                <Setter Property="ToolTip" Value="{Binding Text, 
                                 RelativeSource={RelativeSource Self}}"/>
                            </Style>
                        </DataGridTextColumn.ElementStyle>
</DataGridTextColumn>
```


2. DataGrid for Search

```
<DataGrid ItemsSource="{Binding SearchFilesSource,Mode=OneWay}"
SelectionMode="Extended" Background="White" RowHeaderWidth="0" IsReadOnly="True" AutoGenerateColumns="False" 
Grid.Column="1" GridLinesVisibility="None"
Margin="5" HorizontalContentAlignment="Stretch">

</DataGrid>
```

Add style in DataGrid
```
<DataGrid.Style>

</DataGrid.Style>
```
Add style code inside datagrid style
```
<Style TargetType="DataGrid">
    <Setter Property="Visibility" Value="Visible"/>
    <Style.Triggers>
        <DataTrigger Binding="{Binding SearchMode}" Value="False">
            <Setter Property="Visibility" Value="Collapsed"/>
        </DataTrigger>
    </Style.Triggers>
</Style>
```

Add interaction trigger inside datagrid for event when selected item change.
```
<i:Interaction.Triggers>
    <i:EventTrigger EventName="SelectionChanged">
        <cmd:EventToCommand Command="{Binding DeatailViewSelectionChanged}" PassEventArgsToCommand="True"/>
    </i:EventTrigger>
</i:Interaction.Triggers>
```

Add below code inside Datagrid columns
```
<DataGridTemplateColumn Header="Name" Width="*">
                        <DataGridTemplateColumn.CellTemplate>
                            <DataTemplate>
                                <StackPanel Name="FolderSearchResult">
                                    <Grid Height="40" HorizontalAlignment="Stretch">
                                        <Grid.Style>
                                            <Style TargetType="Grid">
                                                <Setter Property="Visibility" Value="Collapsed"/>
                                                <Style.Triggers>
                                                    <DataTrigger Binding="{Binding IsDirectory}" Value="True">
                                                        <Setter Property="Visibility" Value="Visible"/>
                                                    </DataTrigger>
                                                </Style.Triggers>
                                            </Style>
                                        </Grid.Style>
                                        <Grid.ColumnDefinitions>
                                            <ColumnDefinition Width="Auto"/>
                                            <ColumnDefinition Width="*"/>
                                            <ColumnDefinition Width="2*"/>
                                        </Grid.ColumnDefinitions>
                                        <Image Source="{Binding Path=Icon, UpdateSourceTrigger=PropertyChanged}" Margin="5"></Image>
                                        <StackPanel Grid.Column="1">
                                            <TextBlock Margin="10,2" 
                                              Text="{Binding Name,UpdateSourceTrigger=PropertyChanged}"
                                              TextTrimming="CharacterEllipsis"/>

                                            <TextBlock Margin="10,2" TextTrimming="CharacterEllipsis">    
                                                <Run Text="Date modified: "/>
                                                <Run Text="{Binding LastWriteTime, StringFormat=\{0:dd-MM-yyyy HH:mm tt\}}"/>
                                            </TextBlock>
                                        </StackPanel>
                                        <TextBlock Margin="10,2" Text="{Binding FilePath,UpdateSourceTrigger=PropertyChanged}" Grid.Column="2" TextTrimming="CharacterEllipsis"/>
                                    </Grid>


                                    <Grid Height="40" HorizontalAlignment="Stretch">
                                        <Grid.Style>
                                            <Style TargetType="Grid">
                                                <Setter Property="Visibility" Value="Collapsed"/>
                                                <Style.Triggers>
                                                    <DataTrigger Binding="{Binding IsDirectory}" Value="False">
                                                        <Setter Property="Visibility" Value="Visible"/>
                                                    </DataTrigger>
                                                </Style.Triggers>
                                            </Style>
                                        </Grid.Style>
                                        <Grid.ColumnDefinitions>
                                            <ColumnDefinition Width="Auto"/>
                                            <ColumnDefinition Width="*"/>
                                            <ColumnDefinition Width="1*"/>
                                            <ColumnDefinition Width="1*"/>
                                        </Grid.ColumnDefinitions>
                                        <Image Source="{Binding Path=Icon, UpdateSourceTrigger=PropertyChanged}" Margin="5"></Image>
                                        <StackPanel Grid.Column="1">
                                            <TextBlock Margin="10,2" Text="{Binding Name}" TextTrimming="CharacterEllipsis"
                                                       />

                                            <TextBlock Margin="10,2" Text="{Binding FilePath}" Grid.Column="2" TextTrimming="CharacterEllipsis"
                                                  />
                                        </StackPanel>
                                        <TextBlock Margin="10,2" TextTrimming="CharacterEllipsis" Grid.Column="2"
                                                       >    
                                                <Run Text="Type: "/>
                                                <Run Text="{Binding Type}"/>
                                        </TextBlock>

                                        <StackPanel Grid.Column="3">
                                            <TextBlock Margin="10,2" TextTrimming="CharacterEllipsis" 
                                                      >    
                                                <Run Text="Date modified: "/>
                                                <Run Text="{Binding LastWriteTime, StringFormat=\{0:dd-MM-yyyy HH:mm tt\}}"/>
                                            </TextBlock>
                                            <TextBlock Margin="10,2" TextTrimming="CharacterEllipsis"
                                                      >    
                                                <Run Text="Size: "/>
                                                <Run Text="{Binding Size}"/>
                                            </TextBlock>
                                        </StackPanel>
                                    </Grid>
                                    <Separator/>
                                </StackPanel>
                            </DataTemplate>
                        </DataGridTemplateColumn.CellTemplate>
</DataGridTemplateColumn>
```

## In Third Row of Main Grid
Add 2 Textblock inside the Stackpanel

1. To display number of detail Items
```
<TextBlock Margin="10 2 0 2" Text="{Binding NumberOfDetailItems,UpdateSourceTrigger=PropertyChanged}" VerticalAlignment="Center"/>
```
2. To display number of selected Items
```
<TextBlock Margin="20 2 0 2" VerticalAlignment="Center">
        <Run Text="{Binding SelectedDetailFileCount}"/>
        <Run Text="items selected"/>
</TextBlock>
```

Add Textblock style for second Textblock
```
<TextBlock.Style>

</TextBlock.Style>
```
Add style inside textblock style 
```
<Style TargetType="TextBlock">
    <Setter Property="Visibility" Value="Visible" />
    <Style.Triggers>
        <DataTrigger Binding="{Binding SelectedDetailFileCount}" Value="0">
            <Setter Property="Visibility" Value="Collapsed" />
        </DataTrigger>
    </Style.Triggers>
</Style>
```
Here is the code for usercontrol is Completed.

---
## Structure

- Create ***Structs*** Folder
- Inside this folder Create struct class having name ***"ShellFileInfo.cs"***

##### ( Note - follow the same instruction to create folder what we used to create the enum folder )

<br/>

***ShellFileInfo.cs***

```
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
```

## Utilities

- Create ***Utils*** Folder
    ##### ( Note - follow the same instruction to create folder what we used to create the enum folder )
- Inside this folder Create below classes.
```
    Interop.cs
    ShellManager.cs
```

Here is the code for ***Interop.cs***
```
using FileExplorerApp.Structs;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading.Tasks;

namespace FileExplorerApp.Utils
{
    public static class Interop
    {
        [DllImport("shell32.dll", CharSet = CharSet.Auto)]
        public static extern IntPtr SHGetFileInfo(string path,
            uint attributes,
            out ShellFileInfo fileInfo,
            uint size,
            uint flags);

        [StructLayout(LayoutKind.Sequential)]
        public struct SHFILEINFO
        {
            public IntPtr hIcon;
            public int iIcon;
            public uint dwAttributes;
            [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 260)]
            public string szDisplayName;
            [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 80)]
            public string szTypeName;
        };

        public static class FILE_ATTRIBUTE
        {
            public const uint FILE_ATTRIBUTE_NORMAL = 0x80;
        }

        public static class SHGFI
        {
            public const uint SHGFI_TYPENAME = 0x000000400;
            public const uint SHGFI_USEFILEATTRIBUTES = 0x000000010;
        }

        [DllImport("user32.dll", SetLastError = true)]
        [return: MarshalAs(UnmanagedType.Bool)]
        public static extern bool DestroyIcon(IntPtr pointer);
    }
}
```

Here is the code for ***"ShellManager.cs"***
```
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
```

## Models

- Create ***Models*** Folder
     ##### ( Note - follow the same instruction to create folder what we used to create the enum folder )
- Inside this folder Create below classes.
```
    BaseModel.cs
    FileSystemObjectInfo.cs
    DummyFileSystemObjectInfo.cs
```


Here is the code for ***"BaseModel.cs"***
```
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FileExplorerApp.Models
{
    [Serializable]
    public abstract class BaseModel : INotifyPropertyChanged
    {

        private IDictionary<string, object> m_values = new Dictionary<string, object>(StringComparer.OrdinalIgnoreCase);

        public T GetValue<T>(string key)
        {
            var value = GetValue(key);
            return (value is T) ? (T)value : default(T);
        }

        private object GetValue(string key)
        {
            if (string.IsNullOrEmpty(key))
            {
                return null;
            }
            return m_values.ContainsKey(key) ? m_values[key] : null;
        }

        public void SetValue(string key, object value)
        {
            if (!m_values.ContainsKey(key))
            {
                m_values.Add(key, value);
            }
            else
            {
                m_values[key] = value;
            }
            OnPropertyChanged(key);
        }


        [field: NonSerialized]
        public event PropertyChangedEventHandler PropertyChanged;

        protected void OnPropertyChanged(string propertyName)
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
        }
    }
}
```

Here is the code for ***"FileSystemObjectInfo.cs"***
```
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
            IsDirectory = info.Attributes.ToString().ToLower().Contains("directory");
            if (this is DummyFileSystemObjectInfo)
            {
                return;
            }
            UpdateFileSystem(info);
        }

        public FileSystemObjectInfo(DriveInfo drive)
        {
            Drive = drive;
            if (drive.IsReady)
            {
                DriveLabel = string.IsNullOrEmpty(drive.VolumeLabel) ? "Local Disk" : drive.VolumeLabel;
            }
            if (this is DummyFileSystemObjectInfo)
            {
                return;
            }
            UpdateFileSystem(drive.RootDirectory, drive);
        }

        public string NormalizePath(string path)
        {
            return Path.GetFullPath(new Uri(path).LocalPath)
                       .TrimEnd(Path.DirectorySeparatorChar, Path.AltDirectorySeparatorChar)
                       .ToUpperInvariant();
        }

        private void UpdateFileSystem(FileSystemInfo info, DriveInfo drive = null)
        {
            Children = new ObservableCollection<FileSystemObjectInfo>();
            FileSystemInfo = info;

            if (FileSystemInfo is DirectoryInfo)
            {
                FileInfo = ShellManager.GetFileInfo(FileSystemInfo.FullName, ItemType.Folder, new Size(16, 16));
                FileInfo.Name = Drive != null ? $" ({NormalizePath(FileSystemInfo.Name)})" :FileSystemInfo.Name;
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
                if (string.Equals(e.PropertyName, "IsExpanded", StringComparison.CurrentCultureIgnoreCase)
                    ||
                    string.Equals(e.PropertyName, "GetDetailNodes", StringComparison.CurrentCultureIgnoreCase))
                {   
                    RaiseBeforeExpand();
                    if (IsExpanded || GetDetailNodes)
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

        public bool IsDirectory
        {
            get { return GetValue<bool>("IsDirectory"); }
            set { SetValue("IsDirectory", value); }
        }

        private bool _isSelected;
        public bool IsSelected
        {
            get { return _isSelected; }
            set
            {
                if (_isSelected != value)
                {
                    _isSelected = value;
                    OnPropertyChanged("IsSelected");
                }
            }
        }

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

        public bool GetDetailNodes
        {
            get { return GetValue<bool>("GetDetailNodes"); }
            set { SetValue("GetDetailNodes", value); }
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

        public string DriveLabel
        {
            get { return GetValue<string>("DriveLabel"); }
            set { SetValue("DriveLabel", value); }
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
```

Here is the code for ***"DummyFileSystemObjectInfo.cs"***
```
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FileExplorerApp.Models
{
    internal class DummyFileSystemObjectInfo : FileSystemObjectInfo
    {
        public DummyFileSystemObjectInfo() : base(new DirectoryInfo("DummyFileSystemObjectInfo"))
        {
        }
    }
}
```

---

## View Models
- Create folder having name "ViewModels"
    ##### ( Note - follow the same instruction to create folder what we used to create the enum folder )
- Inside this folder Create below classes.
```
    ExplorerControlViewModel.cs
    MainWindowViewmodel.cs
```



***"ExplorerControlViewModel"*** and ***"MainWindowViewmodel"*** will contain the FileExplorerApp logic.

Here is the code for ***"ExplorerControlViewModel.cs"***
```
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

            DetailGridDoubleClick = new RelayCommand<FileSystemObjectInfo>(OnDetailGridDoubleClick);
        }

        private void OnDetailGridDoubleClick(FileSystemObjectInfo obj)
        {
            if (obj.FileInfo.IsDirectory)
            {
                selectedFileObject = obj;
                UpdateDetailFiles();
            }
            else
            {
                try
                {
                    System.Diagnostics.Process.Start(obj.FileSystemInfo.FullName);
                }
                catch (Exception e)
                {

                    MessageBox.Show(e.Message);
                }
            }
        }

        private void OnClearCommand()
        {
            SearchText = string.Empty;
        }

        public ICommand DetailGridDoubleClick { get; set; }
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
```

Here is the code for ***"MainWindowViewmodel.cs"***
```
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
using System.Windows.Input;

namespace FileExplorerApp.ViewModels
{
    public class MainWindowViewmodel
    {
        public MainWindowViewmodel()
        {
            Items = new ObservableCollection<TabModel>()
            {
                new TabModel(){ Header = $"File Explorer #{Items.Count+1}",DataContext = new ExplorerControlViewModel()},
            };
            CloseTabCommand = new RelayCommand<object>(OnCloseTabCommand);
            AddTabCommand = new RelayCommand(OnAddTabCommand);
        }

        private void OnAddTabCommand()
        {
            Items.Add(new TabModel() { Header = $"File Explorer #{Items.Count + 1}", DataContext = new ExplorerControlViewModel() });
        }

        private void OnCloseTabCommand(object obj)
        {
            Items.Remove((TabModel)obj);
        }

        public ObservableCollection<TabModel> Items { get; set; } = new ObservableCollection<TabModel>();

        public ICommand CloseTabCommand { get; set; }
        public ICommand AddTabCommand { get; set; }
    }

    public class TabModel
    {
        public string Header { get; set; }
        public ExplorerControlViewModel DataContext { get; set; }
    }
}
```
---
### Add  Icons 

- Create Folder "Icons"
    ##### ( Note - follow the same instruction to create folder what we used to create the enum folder )

Add the image inside this folder with below instructions

<br/><div style="text-align:center"><a href="https://ibb.co/pJqdNXH"><img src="https://i.ibb.co/pJqdNXH/Icons.png" alt="Icons" border="0"></a></div> 

Paste icons in the folder and go to visual studio and follow instructions <br/><div style="text-align:center"><a href="https://ibb.co/MshRrw4"><img src="https://i.ibb.co/MshRrw4/Include-Icons.png" alt="Include-Icons" border="0"></a></div>

---
## MainWindow.xaml

Add a namespace for datacontext class in MainWindow: 

`xmlns:viewmodel="clr-namespace:FileExplorerApp.ViewModels"`

Add a namespace for add usercontrol

`xmlns:userControl="clr-namespace:FileExplorerApp.UserControls"`

Build the solution then add the datacontext below to MainWindow.xaml:
```
<Window.DataContext>
    <viewmodel:MainWindowViewmodel/>
</Window.DataContext>
```

### Setting up the Main Grid
By default the mainwindow.xaml will contain the below code.
```
<Grid>

</Grid>
```
We will refer to this as the ***"Main Grid"*** 

The main grid will be split into 2 rows.
<br/><div style="text-align:center"><a href="https://ibb.co/DkDc6GW"><img src="https://i.ibb.co/DkDc6GW/Main-Grid-Rows.png" alt="Main-Grid-Rows" border="0"></a></div>

Copy this code in the Main Grid block to create 2 rows:
```
<Grid.RowDefinitions>
   <RowDefinition Height="*"/>
    <RowDefinition Height="Auto"/>
</Grid.RowDefinitions>
```

Create a TabControl in First row.
```
<TabControl ItemsSource="{Binding Items}" TabStripPlacement="Bottom">
    <TabControl.ItemTemplate>
        <DataTemplate >
            <StackPanel Orientation="Horizontal">
                <TextBlock Text="{Binding DataContext.HeaderText}"/>
                <Button Content="X" Cursor="Hand" DockPanel.Dock="Right" Focusable="False" FontFamily="Courier" FontSize="9" FontWeight="Bold"  Margin="8,1,0,0" Padding="0" 
            VerticalContentAlignment="Bottom" Width="16" Height="16" Background="Transparent" Command="{Binding DataContext.CloseTabCommand,RelativeSource={RelativeSource AncestorType={x:Type Window}}}"CommandParameter="{Binding}"/>
            </StackPanel>
        </DataTemplate>
    </TabControl.ItemTemplate>
    <TabControl.ContentTemplate>
        <DataTemplate>
            <userControl:ExplorerControl DataContext="{Binding DataContext}"/>
        </DataTemplate>
    </TabControl.ContentTemplate>
</TabControl>
```

Create a button in Second row.
```
<Button Grid.Row="1" Margin="5" HorizontalAlignment="Right" Command="{Binding AddTabCommand}">
</Button>
```

Add image as a content in button
```
<Button.Content>
    <Image Source="pack://application:,,,/Icons/add.png" Height="25"/>
</Button.Content>
```

Here you Go!!

## Build the application and test the functionalities.
