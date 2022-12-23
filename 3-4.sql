-- задание 3
drop schema if exists db_course_project cascade;
create schema db_course_project;
set search_path = db_course_project;

drop table if exists position cascade;
create table position (
    position_id    integer  primary key,
    position_name  text     not null,
    salary         integer
);


drop table if exists laboratory cascade;
create table laboratory (
    lab_id           integer  primary key,
    lab_head_id      integer,
    lab_name         text     not null,
    university_name  text
);

drop table if exists staff cascade;
create table staff (
    staff_id       integer    not null,
    position_id    integer    not null,
    lab_id         integer    not null,
    first_name     text       not null,
    last_name      text       not null,
    email_address  text       check (regexp_match(email_address, '[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$') notnull),
    valid_from     timestamp  not null,
    valid_to       timestamp,

    constraint pk_staff primary key (staff_id, valid_from),

    foreign key (position_id) references position   (position_id) on delete set null,
    foreign key (lab_id)      references laboratory (lab_id)      on delete set null
);

alter table staff alter column valid_to set default '9999-12-31';


drop table if exists conference cascade;
create table conference (
    conference_id    integer    primary key,
    conference_name  text       not null,
    start_date       timestamp,
    end_date         timestamp
);


drop table if exists research_paper cascade;
create table research_paper (
    paper_name     text     primary key,
    conference_id  integer,
    year           integer,
    publisher      text,

    foreign key (conference_id) references conference (conference_id) on delete set null
);


drop table if exists funding_source cascade;
create table funding_source (
    funding_source_id    integer  primary key,
    funding_source_name  text     not null,
    funding_source_type  text     check (funding_source_type in ('грант', 'кредит', 'добровольное пожертвование'))
);


drop table if exists conference_x_funding_source cascade;
create table conference_x_funding_source (
    conference_id      integer  not null,
    funding_source_id  integer  not null,
    money_amount       integer,

    constraint pk_conference_x_funding_source primary key (conference_id, funding_source_id),

    foreign key (conference_id)     references conference     (conference_id)     on delete cascade,
    foreign key (funding_source_id) references funding_source (funding_source_id) on delete cascade
);


drop table if exists lab_x_funding_source cascade;
create table lab_x_funding_source (
    lab_id             integer  not null,
    funding_source_id  integer  not null,
    money_amount       integer,

    constraint pk_lab_x_funding_source primary key (lab_id, funding_source_id),

    foreign key (lab_id)            references laboratory     (lab_id)            on delete cascade,
    foreign key (funding_source_id) references funding_source (funding_source_id) on delete cascade
);


drop table if exists staff_x_conference cascade;
create table staff_x_conference (
    staff_id       integer  not null,
    conference_id  integer  not null,

    constraint pk_staff_x_conference primary key (staff_id, conference_id),

    foreign key (conference_id) references conference (conference_id) on delete cascade
);


drop table if exists researcher_x_paper cascade;
create table researcher_x_paper (
    researcher_id  integer  not null,
    paper_name     text     not null,

    constraint pk_researcher_x_paper primary key (researcher_id, paper_name),

    foreign key (paper_name) references research_paper (paper_name) on delete cascade
);



-- задание 4

-- заполняем таблицу position
insert into position(position_id, position_name, salary)
values (1, 'младший научный сотрудник', 16000),
       (2, 'стажер-исследователь', 4000),
       (3, 'старший научный сотрудник', 30000),
       (4, 'руководитель лаборатории',  30000),
       (5, 'студент-практикант', 0);


-- заполняем таблицу laboratory
insert into laboratory(lab_id, lab_name, university_name)
values (1, 'Лаборатория естественного языка', 'ВШЭ'),
       (2, 'Лаборатория теории информации  и кодирования', 'ИТМО'),
       (3, 'Лаборатория финансовых технологий', 'МФТИ'),
       (4, 'Международная лаборатория теории игр и принятия решений', 'ВШЭ');

insert into laboratory(lab_id, lab_name)
values (5, 'Методы машинного обучения в области программной инженерии'),
       (6, 'Лаборатория языковых инструментов'),
       (7, 'Astroparticle physics')
;


-- заполняем таблицу  staff
insert into staff (staff_id, position_id, lab_id, first_name, last_name, email_address, valid_from)
values (1, 3, 1, 'Елизавета', 'Жемчужина', 'needsugardaddy@gmail.com', '2021-09-01'),
       (2, 1, 1, 'Сергей', 'Разумовский', 'plaguemaster@gmail.com', '2020-04-21'),
       (3, 1, 7, 'Анастасия', 'Чайкова', 'cutienastyushka@edu.hse.ru', '2021-10-11'),
       (4, 4, 1, 'Иван', 'Ямщиков', 'iyamschikov@yandex.ru', '2021-02-01'),
       (5, 3, 3, 'Полина', 'Курносова', 'femboyz4life@gmail.com', '2022-03-08'),
       (6, 2, 6, 'Чад', 'Гопота', 'chatgptwillmakeusunemployed@gmail.com', '2022-11-30'),
       (7, 2, 5, 'Егор', 'Лебедев', 'MLenjoyer@mail.ru', '2022-12-19'),
       (8, 3, 4, 'Александра', 'Семенова', 'asemenova@gmail.com', '2021-12-09'),
       (9, 2, 3, 'Олег', 'Тиньков', 'tinkoff@rambler.ru', '2022-10-31'),
       (10, 3, 6, 'Елена', 'Прекрасная', 'elenap@gmail.com', '2020-10-30');


-- заполняем таблицу conference
insert into conference(conference_id, conference_name, start_date, end_date)
values (1, 'EMNLP 2022', '2022-12-7', '2022-12-11'),
       (2, 'AI in Finance Summit London 2022', '2022-03-23', '2022-03-24'),
       (3, 'ODSC West 2022', '2022-11-1', '2022-11-3'),
       (4, 'DSC Europe 22', '2022-11-14', '2022-11-18'),
       (5, 'IEEE ICDM', '2022-11-17', '2022-11-20');


-- заполняем таблицу research_paper
insert into research_paper(paper_name, conference_id, year, publisher)
values ('Embeddings and polysemy', 1, 2022, 'NLP journal'),
       ('New approach on loosing money', 2, 2022, 'Coolest journal about finances'),
       ('New DL model for speech recognition', 1, 2022, 'The Journal of Machine Learning Research');

insert into research_paper(paper_name, year, publisher)
values ('Model-independent classification of events', 2021, 'Astrophysics today'),
       ('Some other old research paper', 2019, 'The Journal of Machine Learning Research');


-- заполняем таблицу funding_source
insert into funding_source(funding_source_id, funding_source_name, funding_source_type)
values (1, 'Yandex Research', 'грант'),
       (2, 'Тинькофф', 'грант'),
       (3, 'всероссийский фонд поддержки молодых ученых', 'грант'),
       (4, 'анонимный благотворитель', 'добровольное пожертвование'),
       (5, 'Марк Цукерберг', 'добровольное пожертвование'),
       (6, 'Google Research', 'добровольное пожертвование'),
       (7, 'Jetbrains Research', 'добровольное пожертвование');


-- заполняем таблицу conference_x_funding_source
insert into conference_x_funding_source(conference_id, funding_source_id, money_amount)
values (1, 6, 1000000),
       (2, 2, 50000),
       (2, 5, 2000000),
       (3, 7, 100500),
       (4, 4, 2020000),
       (4, 6, 3000000),
       (5, 6, 4000000);

-- заполняем таблицу lab_x_funding_source
insert into lab_x_funding_source(lab_id, funding_source_id, money_amount)
values (1, 1, 1000000),
       (2, 3, 100),
       (3, 2, 1020200),
       (4, 3, 3824300),
       (4, 5, 43000),
       (5, 7, 3000000),
       (6, 7, 2000000),
       (7, 7, 1000000);

-- заполняем таблицу staff_x_conference
insert into staff_x_conference(staff_id, conference_id)
values (1, 1),
       (1, 4),
       (8, 2),
       (9, 2),
       (2, 3),
       (4, 3),
       (5, 4),
       (10, 4),
       (7, 4),
       (2, 5),
       (9, 5);

-- заполняем таблицу researcher_x_paper
insert into researcher_x_paper (researcher_id, paper_name)
values (1, 'Embeddings and polysemy'),
       (4, 'Embeddings and polysemy'),
       (3, 'Model-independent classification of events'),
       (9, 'New approach on loosing money'),
       (6, 'New DL model for speech recognition'),
       (2, 'Some other old research paper')



-- задание 5

-- запросы к таблицe position

insert into position(position_id, position_name, salary)
values (6, 'ведущий научный сотрудник', 100000);

delete from position where position_name='студент-практикант';

select * from position where salary < 20000;

update position set salary = salary + 5000 where salary < 20000;

-- запросы к таблице research_paper

insert into research_paper(paper_name, conference_id, year)
values ('Cool new paper', 1, 2022);

delete from research_paper where conference_id is null;

select paper_name from research_paper where year = 2022;

update research_paper set publisher = 'NLP journal' where paper_name = 'Cool new paper';

