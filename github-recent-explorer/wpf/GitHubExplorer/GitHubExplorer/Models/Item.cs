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
