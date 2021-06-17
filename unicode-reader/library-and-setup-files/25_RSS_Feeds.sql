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

insert into channels values (1, 'Embarcadero English Blog', 'Blazing Fast Cross-Platform App Development Software', 'https://blogs.embarcadero.com/feed/');
insert into channels values (2, 'Embarcadero Japanese Blog', 'アプリケーション開発を劇的に効率化', 'https://blogs.embarcadero.com/ja/feed/');
insert into channels values (3, 'Embarcadero German Blog', 'Blazing Fast Cross-Platform App Development Software', 'https://blogs.embarcadero.com/de/feed/');
insert into channels values (4, 'Embarcadero Russian Blog', 'Blazing Fast Cross-Platform App Development Software', 'https://blogs.embarcadero.com/ru/feed/');
insert into channels values (5, 'Embarcadero Portuguese Blog', 'Blazing Fast Cross-Platform App Development Software', 'https://blogs.embarcadero.com/pt/feed/');
insert into channels values (6, 'Embarcadero Spanish Blog', 'Blazing Fast Cross-Platform App Development Software', 'https://blogs.embarcadero.com/es/feed/');
insert into channels values (7, 'Machine Learning Mastery', 'Making developers awesome at machine learning', 'https://machinelearningmastery.com/feed/');
insert into channels values (8, 'JavaScript Scene - Medium', 'JavaScript, software leadership, software development, and related technologies. - Medium', 'https://medium.com/feed/javascript-scene');
insert into channels values (9, 'DailyJS - Medium', 'JavaScript news and opinion. - Medium', 'https://medium.com/feed/dailyjs');
insert into channels values (10, 'Datanami', 'Data Science • AI • Advanced Analytics', 'https://www.datanami.com/feed/');
insert into channels values (11, 'Microsoft Security', 'Expert coverage of cybersecurity topics', 'https://www.microsoft.com/security/blog/feed/');
insert into channels values (12, 'Coding Is Like Cooking', 'by Emily Bache', 'http://coding-is-like-cooking.info/feed/');
insert into channels values (13, 'RisingStack Engineering - Node.js Tutorials & Resources', 'Learn about Node.js, JavaScript & Mircoservices from the experts of RisingStack.', 'https://blog.risingstack.com/rss/');
insert into channels values (14, 'The Art of Delphi Programming', 'Opinions, thoughts and ideas mostly related to Delphi Programming', 'https://www.uweraabe.de/Blog/feed/');
insert into channels values (15, 'Learn Korean with Talk To Me In Korean', 'Books & Online Courses', 'https://talktomeinkorean.com/feed/');
insert into channels values (16, 'The Crazy Programmer', 'Guides you through the simplest basics of C, C , Android, PHP, SQL and many more coding languages', 'http://www.thecrazyprogrammer.com/feed');
insert into channels values (17, 'Web Damn', 'Tutorial focused on Web Development, PHP, CodeIgniter, jQuery, JavaScript, and MySQL', 'https://webdamn.com/feed/');
insert into channels values (18, 'MIT Technology Review', 'Leading the conversation about technologies that matter', 'https://www.technologyreview.com/feed/');
insert into channels values (19, 'Stack Abuse', 'News, articles, and ideas for software engineers and web developers', 'https://stackabuse.com/rss/');
insert into channels values (20,  'Programe Secure', 'Shares new programming related books and pdfs', 'https://programesecure.com/feed/');
insert into channels values (21, 'ScienceSoft', 'Professional Software Development', 'https://www.scnsoft.com/blog/rss');
insert into channels values (22, 'Tech Cracked', 'Tech education', 'https://www.techcracked.com/feeds/posts/default?alt=rss');
insert into channels values (23, 'Hackaday', 'For the serious techie', 'https://hackaday.com/blog/feed/');
insert into channels values (24, 'GeekWire', 'Tech news, commentary and other nerdiness from Seattle', 'https://www.geekwire.com/feed/');
insert into channels values (25, 'Techquila', 'Your daily shot of PC, video-game, smartphone, entertainment, lifestyle and science news', 'https://www.techquila.co.in/feed/');



