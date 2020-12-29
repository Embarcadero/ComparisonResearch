using System;

namespace GitHubExplorer.Models
{
    public class Repository
    {
        public readonly int id;
        public readonly string title;
        public readonly string url;
        public readonly string description;
        public readonly string language;
        public readonly int stars;
        public readonly string license;
        public readonly string updatedate;
        public readonly string createdate;
        public readonly string representupdatedate;

        public Repository(int id,string title,string url,string description,string language,int stars,string license,string updatedate,string createdate)
        {
            this.id = id;
            this.title = title;
            this.url = url;
            this.description = description;
            this.language = language;
            this.stars = stars;
            this.license = license;
            this.updatedate = updatedate;
            this.createdate = createdate;
            representupdatedate = ConvertUpdateDateIntoUiData(updatedate);
        }

        private string ConvertUpdateDateIntoUiData(string date)
        {
            DateTime _date = DateTime.Parse(date);
            return "Updated on " + $"{_date.Month.ToString().PadLeft(2, '0')}/{_date.Day.ToString().PadLeft(2, '0')}/{_date.Year}";
        }
    }
}
