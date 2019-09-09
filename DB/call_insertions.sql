call insert_Class("Fighter", NULL);
call insert_Class("Monge", NULL);
call insert_Class("Bardo", NULL);
call insert_Class("Rogue", NULL);

call insert_Item("Wood Arrow", 1, null, 10);
call insert_Item("Iron Arrow", 15, null, 150);
call insert_Item("Wood Sword", 5, null, 45);
call insert_Item("Iron Sword", 25, null, 185);
call insert_Item("Magic Sword", 100, null, 1500);
call insert_Item("Magic Arrow", 95, null, 1300);

call insert_ClassItemRestriction("Fighter", "Magic Arrow");
call insert_ClassItemRestriction("Monge", "Magic Sword");

call insert_User("leon_silva", "teste@test.com", "1998-07-20", 123456, null, "admin");
call insert_User("vlad_junior", "teste2@test.com", "1998-03-10", 234567, "leon_silva", "guild master");
call insert_User("luiz_zafiro", "teste3@test.com", "1999-04-24", 345678, null, "adventure");
call insert_User("malcoln", "teste4@test.com", "2001-01-01", 456789, null, "adventure");
call insert_User("lucas_vaz", "teste5@test.com", "2010-01-01", 456781, null, "adventure");

/*Problems
call insert_AdventureHasItem("luiz_zafiro", "Iron Arrow");
call insert_AdventureHasItem("malcoln", "Iron Sword");
call insert_AdventureHasItem("lucas_vaz", "Magic Arrow");*/

call insert_Guild("Enginner", null, "vlad_junior");

call insert_Team("Database", "Enginner");
call insert_Team("Trello API", "Enginner");
call insert_Team("App", "Enginner");
call insert_Team("Logo", "Enginner");

call insert_TrelloUser_Team("luiz_zafiro", "Logo");
call insert_TrelloUser_Team("lucas_vaz", "TrelloAPI");
call insert_TrelloUser_Team("malcoln", "App");
call insert_TrelloUser_Team("leon_silva", "Database");

call insert_UserAdventure_Class("luiz_zafiro", "Fighter");
call insert_UserAdventure_Class("malcoln", "Monge");
call insert_UserAdventure_Class("lucas_vaz", "Bardo");

call insert_Project("App", null, "App");

call insertQuest("Create logo", 100);
call insertQuest("Connect", 100);
call insertQuest("Create interface", 1000);
call insertQuest("Create Navigation Bar", 500);
call insertQuest("Cloud database", 1000);

call insert_ProjectQuest("luiz_zafiro", "App", "Create logo");
call insert_ProjectQuest("lucas_vaz", "App", "Connect");
call insert_ProjectQuest("luiz_zafiro", "App", "Create interface");
call insert_ProjectQuest("luiz_zafiro", "App", "Create Navigation Bar");
call insert_ProjectQuest("leon_silva", "App", "Cloud database");

call insert_Goal("do", null, "Create logo", 100);
call insert_Goal("study", null, "Create logo", 100);
call insert_Goal("do", null, "Connect", 100);
call insert_Goal("study", null, "Connect", 100);
call insert_Goal("do", null, "Create interface", 100);
call insert_Goal("study", null, "Create interface", 100);
call insert_Goal("do", null, "Create Navigation Bar", 100);
call insert_Goal("study", null, "Create Navigation Bar", 100);
call insert_Goal("do", null, "Cloud database", 100);
call insert_Goal("study", null, "Cloud database", 100);