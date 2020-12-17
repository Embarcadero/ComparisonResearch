using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Github_Recent_Explorer_Test.Models
{
    class Repository
    {
        public readonly ulong id;
        public readonly string title;
        public readonly string url;
        public readonly string description;
        public readonly string language;
        public readonly int stars;
        public readonly string license;
        public readonly string updatedate;
        public readonly string createdate;
        public readonly string representupdatedate;

        private string ConvertUpdateDateIntoUiData(string date)
        {

            DateTime _date = DateTime.Parse(date);

            return "Updated on " + $"{_date.Month.ToString().PadLeft(2, '0')}/{_date.Day.ToString().PadLeft(2, '0')}/{_date.Year}";
        }
        public Repository(ulong id, string title, string url, string description,string language, int stars, string license, string updatedate, string createdate)
        {
            this.id = id;
            this.title = title;
            this.url = url;
            this.description = description;
            this.language = language;
            this.stars = stars;
            this.license = license;
            this.updatedate = updatedate;
            this.representupdatedate = ConvertUpdateDateIntoUiData(updatedate);
            this.createdate = createdate;
        }
    }
}
