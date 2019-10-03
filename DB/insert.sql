DELIMITER $$
CREATE PROCEDURE insert_Class(in class_name varchar(30), in description varchar(50))
BEGIN
	DECLARE EXIT HANDLER FOR 1062
    BEGIN
        ROLLBACK;
		select 'This class already exists' as 'Erro';
    END;
	DECLARE EXIT HANDLER FOR 1048
    BEGIN
        ROLLBACK;
		select 'Null field' as 'Erro';
    END;
	insert into Class(class_name, description) values (class_name, description);
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE insert_Item(in item_name varchar(30), in item_level integer, in description varchar(50), in stats integer)
BEGIN
	DECLARE EXIT HANDLER FOR 1062
    BEGIN
        ROLLBACK;
		select 'This item already exists' as 'Erro';
    END;
	DECLARE EXIT HANDLER FOR 1048
    BEGIN
        ROLLBACK;
		select 'Null field' as 'Erro';
    END;
	insert into Items(item_name, item_level, description, stats) values (item_name, item_level, description, stats);
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE insert_Team(in team_name varchar(30), in guild_name varchar(30))
BEGIN
	declare codGuild integer;
	DECLARE EXIT HANDLER FOR 1062
    BEGIN
        ROLLBACK;
		select 'This Team already exists' as 'Erro';
    END;
	DECLARE EXIT HANDLER FOR 1048
    BEGIN
        ROLLBACK;
		select 'Null field' as 'Erro';
    END;
    
    select g.id into codGuild from Guild g where (g.guild_name=guild_name);
    
    if(codGuild is null) then
		select 'This guild does not exists' as 'Erro';
	else
		insert into Teams(team_name, codGuild) values (team_name, codGuild);
    END IF;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE insert_Quest(in quest_name varchar(30), in xp integer)
BEGIN
	DECLARE EXIT HANDLER FOR 1062
    BEGIN
        ROLLBACK;
		select 'This quest already exists' as 'Erro';
    END;
	DECLARE EXIT HANDLER FOR 1048
    BEGIN
        ROLLBACK;
		select 'Null field' as 'Erro';
    END;
	insert into Quest(quest_name, xp) values (quest_name, xp);
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE insert_ClassItemRestriction(in item_name varchar(30), in class_name varchar(30))
BEGIN
	declare codItem integer;
    declare codClass integer;
	DECLARE EXIT HANDLER FOR 1048
    BEGIN
        ROLLBACK;
		select 'Null field' as 'Erro';
    END;
    
    select i.item_name into codItem from Items i where (i.item_name=item_name);
    
    select c.class_name into codClass from Class c where (c.class_name=class_name);
    
    if(codItem is null) then
		select 'This item does not exist' as 'Erro';
	else
	BEGIN
		if(codClass is null) then
			select 'This class does not exist' as 'Erro';
		else
        BEGIN
			insert into ClassItemsRestrictions(codClass, codItem) values (codClass, codItem);
        END;
        END IF;
    END;
    END IF;
	insert into ClassItemsRestrictions(codClass, codItem) values (codClass, codItem);
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE insert_TrelloUser(in user_name varchar(30), in email varchar(30), in burthday date, in user_key integer)
BEGIN
	DECLARE EXIT HANDLER FOR 1062
    BEGIN
        ROLLBACK;
		select 'This user name or email already exists' as 'Erro';
    END;
	DECLARE EXIT HANDLER FOR 1048
    BEGIN
        ROLLBACK;
		select 'Null field' as 'Erro';
    END;
    
    insert into TrelloUser(user_key, user_name, email, burthday) values (user_key, user_name, email, burthday);
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE insert_TrelloUser_Team(in user_name varchar(30), in team_name varchar(30))
BEGIN
    declare codTeam integer;
    
    select t.id into codTeam from Teams t where (t.team_name=team_name);
    
    if(codTeam is null) then
		select 'This team does not exist' as 'Erro';
	else
		UPDATE TrelloUser SET codTeam=codTeam where (TrelloUser.user_name=user_name);
    END IF;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE insert_Guild(in guild_name varchar(30), in description varchar(50), in name_guild_master varchar(30))
BEGIN
	declare codGuildMaster integer;
    declare codTrelloUserGuildMaster integer;
    declare codGuild integer;
	DECLARE EXIT HANDLER FOR 1062
    BEGIN
        ROLLBACK;
		select 'This guild already exists' as 'Erro';
    END;
	DECLARE EXIT HANDLER FOR 1048
    BEGIN
        ROLLBACK;
		select 'Null field' as 'Erro';
    END;
    
    select u.cod into codTrelloUserGuildMaster from TrelloUser u where (u.user_name=name_guild_master);
    
    if(codTrelloUserGuildMaster is null) then
		select 'This Guild Master user does not exists' as 'Error';
    else
		select u.cod into codGuildMaster from UserGuildMaster u where (u.codTrelloUser=codTrelloUserGuildMaster);
        
        if(codGuildMaster is null) then
			select 'This Guild Master does not exist' as 'Error';
		else
			insert into Guild(guild_name, description) values (guild_name, description);
            
            select g.id into codGuild from Guild g where (g.guild_name=guild_name);
            
            update UserGuildMaster set codGuild=codGuild where (cod=codGuildMaster);
        end if;
    end if;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE insert_UserAdmin(in user_name varchar(30))
BEGIN
	declare codTrelloUser integer;
	DECLARE EXIT HANDLER FOR 1062
    BEGIN
        ROLLBACK;
		select 'This Admin already exists' as 'Erro';
    END;
    select u.cod into codTrelloUser from TrelloUser u where (u.user_name=user_name);
    
    if(codTrelloUser is null) then
		select 'Something wrong is happend' as 'Error';
	else
		insert into UserAdmin(codTrelloUser) values (codTrelloUser);
    end if;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE insert_GuildMaster(in user_name varchar(30), in admin_name varchar(30))
BEGIN
	declare codTrelloUserAdmin integer;
    declare codTrelloUser integer;
	declare codAdmin integer;
	DECLARE EXIT HANDLER FOR 1062
    BEGIN
        ROLLBACK;
		select 'This Guild Master already exists' as 'Erro';
    END;
    select u.cod into codTrelloUser from TrelloUser u where (u.user_name=user_name);
    
    if(codTrelloUser is null) then
		select 'Something wrong is happend' as 'Error';
	else
    begin
		select u.cod into codTrelloUserAdmin from TrelloUser u where (u.user_name=admin_name);
        
        if(codTrelloUserAdmin is null) then
			select 'This admin user does not exists' as 'Error';
		else
        begin
			select u.cod into codAdmin from UserAdmin u where(u.codTrelloUser=codTrelloUserAdmin);
            
            if(codAdmin is null) then
				select 'This user is not admin' as 'Error';
			else
				insert into UserGuildMaster(codAdmin, user_level, codTrelloUser) values (codAdmin, 0, codTrelloUser);
            end if;
        end;
        end if;
    end;
    end if;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE insert_UserAdventure(in user_name varchar(30))
BEGIN
	declare codTrelloUser integer;
	DECLARE EXIT HANDLER FOR 1062
    BEGIN
        ROLLBACK;
		select 'This Adventure already exists' as 'Erro';
    END;
    select u.cod into codTrelloUser from TrelloUser u where (u.user_name=user_name);
    
    if(codTrelloUser is null) then
		select 'Something wrong is happend' as 'Error';
	else
		insert into UserAdventure(user_level, codTrelloUser) values (0, codTrelloUser);
    end if;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE insert_User(in user_name varchar(30), in email varchar(30), in burthday date, in user_key integer, in admin_name varchar(30), in tipo varchar(30))
BEGIN
	DECLARE EXIT HANDLER FOR 1062
    BEGIN
        ROLLBACK;
		select 'This User already exists' as 'Erro';
    END;
    
    call insert_TrelloUser(user_name, email, burthday, user_key);
    
    if(strcmp(tipo, 'admin')=0) then
		call insert_UserAdmin(user_name);
	else 
    begin
		if(strcmp(tipo, 'guild master')=0) then
			call insert_GuildMaster(user_name, admin_name);
		else 
        begin
			if(strcmp(tipo, 'adventure')=0) then
				call insert_UserAdventure(user_name);
			else
				select 'Tipe of user is not found' as 'Error';
			end if;
		end;
        end if;
	end;
    end if;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE insert_UserAdventure_Class(in user_name varchar(30), in class_name varchar(30))
BEGIN
	declare codTrelloUser integer;
    declare codClass integer;
    declare codUserAdventure integer;
    
    select u.cod into codTrelloUser from TrelloUser u where (u.user_name=user_name);
    
    if(codTrelloUser is null) then
		select 'This user does not exists' as 'Error';
	else
        select c.cod into codClass from Class c where (c.class_name=class_name);
        
        if(codClass is null) then
			select 'This class does not exists' as 'Error';
		else
		begin
			select u.cod into codUserAdventure from UserAdventure u where (u.codTrelloUser=codTrelloUser);
            
            if(codUserAdventure is null) then
				select 'This user is not a Adventure' as 'Error';
			else
				update UserAdventure set codClass=codClass where (cod=codUserAdventure);
			end if;
        end;
        end if;
    end if;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE insert_AdventureHasItem(in adventure_name varchar(30), in item_name varchar(30))
BEGIN
	declare codAdventure integer;
	declare codItem integer;
	declare codTrelloUser integer;
    
	select u.cod into codTrelloUser from TrelloUser u where (u.user_name=adventure_name);
	if(codTrelloUser is null) then
	begin
		select 'This user does not exists' as 'Error';
	end;
	else
	begin
		select u.cod into codAdventure from UserAdventure u where (u.codTrelloUser=codTrelloUser);
		if(codAdventure is null) then
		begin
			select 'This user is not Adventure' as 'Error';
		end;
		else
		begin
			select i.cod into codItem from Items i where(i.item_name=item_name);         
			if(codItem is null) then
			begin
				select 'This item does not exists' as 'Error';
			end;
			else
			begin
				insert into AdventureHasItems(codAdventure, codItem) values (codAdventure, codItem);
			end;
			end if;
		end;
		end if;
	end;
	end if;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE insert_Project(in project_name varchar(30), in description varchar(50), in team_name varchar(30))
BEGIN
	declare TeamID integer;
    DECLARE EXIT HANDLER FOR 1062
    BEGIN
        ROLLBACK;
		select 'This project already exists' as 'Erro';
    END;
    
    select t.id into TeamID from Teams t where (t.team_name=team_name);
    
    if(TeamID is null) then
		select 'This team does not exists' as 'Error';
	else
		insert into Project(project_name, description, TeamID) values (project_name, description, TeamID);
    end if;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE insert_Goal(in goal_name varchar(30), in description varchar(50), in quest_name varchar(30), in xp integer)
BEGIN
	declare QuestID integer;
	DECLARE EXIT HANDLER FOR 1048
    BEGIN
        ROLLBACK;
		select 'Null field' as 'Erro';
    END;
    
    select q.id into QuestID from Quest q where (q.quest_name=quest_name);
    
    if(QuestID is null) then
		select 'This quest does not exists' as 'Error';
	else
		insert into Goal(goal_name, description, QuestID, xp) values (goal_name, description, QuestID, xp);
    end if;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE insert_ProjectQuest(in user_name varchar(30), in project_name varchar(30), in quest_name varchar(30))
BEGIN
	declare QuestID integer;
    declare codTrelloUser integer;
    declare ProjectID integer;
    
    select q.id into QuestID from Quest q where (q.quest_name=quest_name);
    
    if(QuestID is null) then
		select 'This quest does not exists' as 'Error';
	else
		select u.cod into codTrelloUser from TrelloUser u where (u.user_name=user_name);
        
		if(codTrelloUser is null) then
			select 'This user does not exists' as 'Error';
		else
			select p.id into ProjectID from Project p where (p.project_name=project_name);
            
            if(ProjectID is null) then
				select 'This project does not exists' as 'Error';
			else
				insert into ProjectQuests(codTrelloUser, ProjectID, QuestID) values (codTrelloUser, ProjectID, QuestID);
            end if;
        end if;
    end if;
END $$
DELIMITER ;