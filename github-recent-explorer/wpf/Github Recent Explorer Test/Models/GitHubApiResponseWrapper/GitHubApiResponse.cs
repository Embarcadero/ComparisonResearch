using Github_Recent_Explorer_Test.Models.GitHubApiResponseWrapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Github_Recent_Explorer_Test.Models
{
    class GitHubApiResponse
    {
        public string total_count { get; set; }
        public bool incomplete_results { get; set; }
        public Item[] items { get; set; }
    }
}
