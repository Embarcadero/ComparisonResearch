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
insert into channels values (1, 'https://blogs.embarcadero.com/feed/', 'EN feed', 'https://blogs.embarcadero.com/feed/');
insert into channels values (2, 'https://blogs.embarcadero.com/ja/feed/', 'JA feed', 'https://blogs.embarcadero.com/ja/feed/');
insert into channels values (3, 'https://blogs.embarcadero.com/de/feed/', 'DE feed', 'https://blogs.embarcadero.com/de/feed/');
insert into channels values (4, 'https://blogs.embarcadero.com/ru/feed/', 'RU feed', 'https://blogs.embarcadero.com/ru/feed/');
insert into channels values (5, 'https://blogs.embarcadero.com/pt/feed/', 'PT feed', 'https://blogs.embarcadero.com/pt/feed/');
insert into channels values (6, 'https://blogs.embarcadero.com/es/feed/', 'ES feed', 'https://blogs.embarcadero.com/es/feed/');
