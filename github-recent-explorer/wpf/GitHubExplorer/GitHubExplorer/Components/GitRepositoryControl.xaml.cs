using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Diagnostics;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace GitHubExplorer.Components
{
    /// <summary>
    /// Interaction logic for GitRepositoryControl.xaml
    /// </summary>
    public partial class GitRepositoryControl : UserControl
    {
        public GitRepositoryControl()
        {
            InitializeComponent();
            DataContext = this;
        }

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
    }
}
