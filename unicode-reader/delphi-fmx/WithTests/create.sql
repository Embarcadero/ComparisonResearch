drop table if exists channels cascade;
drop table if exists articles cascade;

create table channels (
    id serial,
    title varchar(1024) not null,
    description text not null,
    link varchar(2048) not null,
    constraint channels_pk primary key (id)
);

create table articles (
    id serial,
    title varchar(1024) not null,
    description text not null,
    content text not null,
    link varchar(2048) not null,
    is_read boolean default false,
    timestamp timestamp default now(),
    channel integer not null,
    constraint articles_pk primary key (id),
    constraint channels_fk foreign key (channel)
        references channels (id)
        on delete cascade
);

insert into channels values (0, 'All feed', 'All feed', 'All feed');
insert into channels values (1, 'Embarcadero Blogs', 'Blazing Fast Cross-Platform App Development Software', 'https://blogs.embarcadero.com/feed/');
insert into channels values (2, 'エンバカデロ・ブログ', 'アプリケーション開発を劇的に効率化', 'https://blogs.embarcadero.com/ja/feed/');
insert into channels values (3, 'Embarcadero Blogs', 'Blazing Fast Cross-Platform App Development Software', 'https://blogs.embarcadero.com/de/feed/');
insert into channels values (4, 'Embarcadero Blogs', 'Blazing Fast Cross-Platform App Development Software', 'https://blogs.embarcadero.com/ru/feed/');
insert into channels values (5, 'Embarcadero Blogs', 'Blazing Fast Cross-Platform App Development Software', 'https://blogs.embarcadero.com/pt/feed/');
insert into channels values (6, 'Embarcadero Blogs', 'Blazing Fast Cross-Platform App Development Software', 'https://blogs.embarcadero.com/es/feed/');
insert into channels values (7, 'TechCrunch', 'Startup and Technology News', 'https://techcrunch.com/feed/');
insert into channels values (8, 'VentureBeat', 'Transformative tech coverage that matters', 'https://venturebeat.com/feed/');
insert into channels values (9, 'Machine Learning Mastery', 'Making developers awesome at machine learning', 'https://machinelearningmastery.com/feed/');
insert into channels values (10, 'Machine Learning Mastery', 'Making developers awesome at machine learning', 'https://machinelearningmastery.com/feed/');
insert into channels values (11, 'Machine Learning Mastery', 'Making developers awesome at machine learning', 'https://machinelearningmastery.com/feed/');
insert into channels values (12, 'JavaScript Scene - Medium', 'JavaScript, software leadership, software development, and related technologies. - Medium', 'https://medium.com/feed/javascript-scene');
insert into channels values (13, 'DailyJS - Medium', 'JavaScript news and opinion. - Medium', 'https://medium.com/feed/dailyjs');
insert into channels values (14, 'Effective Software Design', 'Doing the right thing.', 'https://effectivesoftwaredesign.com/feed/');
insert into channels values (15, 'Datanami', 'Data Science • AI • Advanced Analytics', 'https://www.datanami.com/feed/');
insert into channels values (16, 'Communications of the ACM: Artificial Intelligence', 'The latest news, opinion and research in artificial intelligence, from Communications online.', 'https://cacm.acm.org/browse-by-subject/artificial-intelligence.rss');
insert into channels values (17, 'Communications of the ACM: Security', 'The latest news, opinion and research in security, from Communications online.', 'https://cacm.acm.org/browse-by-subject/security.rss');
insert into channels values (18, 'BleepingComputer', 'BleepingComputer - All Stories', 'https://www.bleepingcomputer.com/feed/');
insert into channels values (19, 'Microsoft Security', 'Expert coverage of cybersecurity topics', 'https://www.microsoft.com/security/blog/feed/');
insert into channels values (20, 'The Hacker News', 'Most trusted, widely-read independent cybersecurity news source for everyone; supported by hackers and IT professionals — Send TIPs to admin@thehackernews.com', 'http://feeds.feedburner.com/TheHackersNews?format=xml');
insert into channels values (21, 'SmartData Collective', 'News & Analysis on Big Data, the Cloud, BI and Analytics', 'https://www.smartdatacollective.com/feed/');
insert into channels values (22, 'Cary Jensen  "Let''s Get Technical"', 'Technical discussions related to software development. Particular attention is paid to Delphi development. Also expect a healthy dose of database-related content, including SQL, data modeling, and general database design.', 'http://feeds.feedburner.com/CaryJensenLetsGetTechnical?format=xml');
insert into channels values (23, 'Coding Is Like Cooking', 'by Emily Bache', 'http://coding-is-like-cooking.info/feed/');
insert into channels values (24, 'Modern Software Design', 'Serhiy Perevoznyk blog', 'https://perevoznyk.wordpress.com/feed/');
insert into channels values (25, 'RisingStack Engineering - Node.js Tutorials & Resources', 'Learn about Node.js, JavaScript & Mircoservices from the experts of RisingStack.', 'https://blog.risingstack.com/rss/');
insert into channels values (26, 'The Art of Delphi Programming', 'Opinions, thoughts and ideas mostly related to Delphi Programming', 'https://www.uweraabe.de/Blog/feed/');
insert into channels values (27, 'Learn Korean with Talk To Me In Korean', 'Books & Online Courses', 'https://talktomeinkorean.com/feed/');
insert into channels values (28, 'Fluent Arabic', 'The Quranic Arabic Blog', 'https://www.fluentarabic.net/feed/');
insert into channels values (29, 'Aftenposten Title', 'Aftenposten RSS Service', 'https://www.aftenposten.no/rss');