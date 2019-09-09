create table Class(
	#OK
	cod integer auto_increment,
    class_name varchar(30) unique not null,
    description varchar(50),
    primary key(cod)
)Engine=INNODB;

create table Items(
	#OK
	cod integer auto_increment,
    item_name varchar(30) unique not null,
    item_level integer,
    description varchar(50),
    stats integer not null,
    primary key(cod)
)Engine=INNODB;

create table ClassItemsRestrictions(
	#OK
		codClass integer not null,
		codItem integer not null,
    primary key(codClass, codItem),
    foreign key(codClass) REFERENCES Class(cod) ON DELETE CASCADE,
    foreign key(codItem) REFERENCES Items(cod) ON DELETE CASCADE
)Engine=INNODB;

create table Guild(
	#OK
	id integer auto_increment,
    guild_name varchar(30) unique not null,
    description varchar(50),
    primary key(id)
)Engine=INNODB;

create table Teams(
	#OK
	id integer auto_increment,
    team_name varchar(30) unique not null,
    codGuild integer not null,
    foreign key(codGuild) REFERENCES Guild(id) ON DELETE CASCADE,
    primary key(id)
)Engine=INNODB;

create table TrelloUser(
	#OK
	cod integer auto_increment,
	user_key integer not null,
    user_name varchar(30) unique not null,
    email varchar(30) unique not null,
    burthday date not null,
		codTeam integer,
    foreign key(codTeam) REFERENCES Teams(id) ON DELETE SET NULL,
    primary key(cod)
)Engine=INNODB;

create table UserAdmin(
	#OK
	cod integer auto_increment,
    primary key(cod),
		codTrelloUser integer unique not null,
    foreign key(codTrelloUser) REFERENCES TrelloUser(cod) ON DELETE CASCADE
)Engine=INNODB;

create table UserGuildMaster(
	#OK
	cod integer auto_increment,
		codAdmin integer,
		codGuild integer,
    user_level integer not null,
		codTrelloUser integer unique,
    foreign key(codTrelloUser) REFERENCES TrelloUser(cod) ON DELETE SET NULL,
    primary key(cod),
    foreign key(codAdmin) REFERENCES UserAdmin(cod) ON DELETE SET NULL,
    foreign key(codGuild) REFERENCES Guild(id) ON DELETE CASCADE
)Engine=INNODB;

create table UserAdventure(
	#OK
	cod integer auto_increment,
		codClass integer,
    user_level integer not null,
		codTrelloUser integer unique not null,
    foreign key(codTrelloUser) REFERENCES TrelloUser(cod) ON DELETE CASCADE,
    primary key(cod),
    foreign key(codClass) REFERENCES Class(cod) ON DELETE SET NULL
)Engine=INNODB;

create table AdventureHasItems(
	#OK
		codAdventure integer not null,
		codItem integer not null,
    primary key(codAdventure, codItem),
    foreign key(codAdventure) REFERENCES UserAdventure(cod) ON DELETE CASCADE,
    foreign key(codItem) REFERENCES Items(cod) ON DELETE CASCADE
)Engine=INNODB;

create table Project(
	#OK
	id integer auto_increment,
    project_name varchar(30) unique not null,
    description varchar(50),
		TeamID integer not null,
    primary key(id),
    foreign key(TeamID) REFERENCES Teams(id) ON DELETE CASCADE
)Engine=INNODB;

create table Quest(
	#OK
	id integer auto_increment,
    quest_name varchar(30) unique not null,
	xp integer not null,
    primary key(id)
)Engine=INNODB;

create table Goal(
	#OK
	id integer auto_increment,
    goal_name varchar(30) not null,
    description varchar(50),
		QuestID integer not null,
	xp integer not null,
	primary key(id),
    foreign key(QuestID) REFERENCES Quest(id) ON DELETE CASCADE
)Engine=INNODB;

create table ProjectQuests(
	#OK
		codTrelloUser integer,
		ProjectID integer not null,
		QuestID integer not null,
    primary key(codTrelloUser, ProjectID, QuestID),
    foreign key(codTrelloUser) REFERENCES TrelloUser(cod) ON DELETE CASCADE,
    foreign key(ProjectID) REFERENCES Project(id) ON DELETE CASCADE,
    foreign key(QuestID) REFERENCES Quest(id) ON DELETE CASCADE
)Engine=INNODB;