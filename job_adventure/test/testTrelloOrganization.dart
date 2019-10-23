import 'package:flutter_test/flutter_test.dart';

import 'package:http/http.dart';
import 'dart:convert';
import 'package:job_adventure/models/TrelloOrganization.dart';

const String APIKey = "57a893b02ea2046b82ac861766a34bed";

void main(){
  group('Testes', (){
    test('Quantidade de organizacoes', (){
      String tokenUser = "eeb43529b467074ea181012e932417534d748d686150da5fcae726c71da02565";
      get("https://api.trello.com/1/members/me/?key="+APIKey+"&token="+tokenUser).then((Response request){
        var jsonreponse = json.decode(request.body);
        List<String> idOrganizations = jsonreponse['idOrganizations'].cast<String>();
        expect(idOrganizations.length, 1);
      });
    });

    test('ID da organização', () {
      String tokenUser = "eeb43529b467074ea181012e932417534d748d686150da5fcae726c71da02565";
      get("https://api.trello.com/1/members/me/?key=" + APIKey + "&token=" +
          tokenUser).then((Response request) {
        var jsonreponse = json.decode(request.body);
        List<String> idOrganizations = jsonreponse['idOrganizations'].cast<
            String>();
        expect(idOrganizations[0], "5daf8dc6a13a93592f5af2a0");
      });
    });

    test('Organization Name', (){
      String tokenUser = "eeb43529b467074ea181012e932417534d748d686150da5fcae726c71da02565";
      organizationTrello organization = organizationTrello("5daf8dc6a13a93592f5af2a0", tokenUser);
      organization.getRead(tokenUser).then((void v){
        expect(organization.name, "TrelloOrganization Teste");
      });
    });

    test('Quantidade de membros da organizacacao', (){
      String tokenUser = "eeb43529b467074ea181012e932417534d748d686150da5fcae726c71da02565";
      organizationTrello organization = organizationTrello("5daf8dc6a13a93592f5af2a0", tokenUser);
      organization.getRead(tokenUser).then((void v){
        List<String> organizationMembers = organization.getListMembers(tokenUser);
        expect(organizationMembers.length, 2);
      });
    });

    test('Primeiro membro da organizacao', (){
      String tokenUser = "eeb43529b467074ea181012e932417534d748d686150da5fcae726c71da02565";
      organizationTrello organization = organizationTrello("5daf8dc6a13a93592f5af2a0", tokenUser);
      organization.getRead(tokenUser).then((void v){
        List<String> organizationMembers = organization.getListMembers(tokenUser);
        expect(organizationMembers[0], "leontenoriodasilva");
      });
    });

    test('Segundo membro da organizacao', (){
      String tokenUser = "eeb43529b467074ea181012e932417534d748d686150da5fcae726c71da02565";
      organizationTrello organization = organizationTrello("5daf8dc6a13a93592f5af2a0", tokenUser);
      organization.getRead(tokenUser).then((void v){
        List<String> organizationMembers = organization.getListMembers(tokenUser);
        expect(organizationMembers[1], "leonsilva7");
      });
    });

    test('Quantidade de Boards', (){
      String tokenUser = "eeb43529b467074ea181012e932417534d748d686150da5fcae726c71da02565";
      organizationTrello organization = organizationTrello("5daf8dc6a13a93592f5af2a0", tokenUser);
      organization.getRead(tokenUser).then((void v){
        List<Board> organizationBoards = organization.getListBoards(tokenUser);
        expect(organizationBoards.length, 1);
      });
    });

    test('Nome do Board', (){
      String tokenUser = "eeb43529b467074ea181012e932417534d748d686150da5fcae726c71da02565";
      organizationTrello organization = organizationTrello("5daf8dc6a13a93592f5af2a0", tokenUser);
      organization.getRead(tokenUser).then((void v){
        List<Board> organizationBoards = organization.getListBoards(tokenUser);
        expect(organizationBoards[0].name, "Team Board Test");
      });
    });

    test('Quantidade de Boards - IDs', (){
      String tokenUser = "eeb43529b467074ea181012e932417534d748d686150da5fcae726c71da02565";
      organizationTrello organization = organizationTrello("5daf8dc6a13a93592f5af2a0", tokenUser);
      organization.getRead(tokenUser).then((void v){
        List<Board> organizationBoards = organization.getListBoards(tokenUser);
        organizationBoards[0].getListCardRead(tokenUser).then((void v){
          List<String> cardIDs = organizationBoards[0].getListCardIds(tokenUser);
          expect(cardIDs.length, 5);
        });
      });
    });

    test('Quantidade de Boards - Names', (){
      String tokenUser = "eeb43529b467074ea181012e932417534d748d686150da5fcae726c71da02565";
      organizationTrello organization = organizationTrello("5daf8dc6a13a93592f5af2a0", tokenUser);
      organization.getRead(tokenUser).then((void v){
        List<Board> organizationBoards = organization.getListBoards(tokenUser);
        organizationBoards[0].getListCardRead(tokenUser).then((void v){
          List<String> cardNames = organizationBoards[0].getListCardNames(tokenUser);
          expect(cardNames.length, 5);
        });
      });
    });

    test('Quantidade de Boards - Stats', (){
      String tokenUser = "eeb43529b467074ea181012e932417534d748d686150da5fcae726c71da02565";
      organizationTrello organization = organizationTrello("5daf8dc6a13a93592f5af2a0", tokenUser);
      organization.getRead(tokenUser).then((void v){
        List<Board> organizationBoards = organization.getListBoards(tokenUser);
        organizationBoards[0].getListCardRead(tokenUser).then((void v){
          List<bool> cardStats = organizationBoards[0].getListCardStats(tokenUser);
          expect(cardStats.length, 5);
        });
      });
    });

    test('ID Card[0]', (){
      String tokenUser = "eeb43529b467074ea181012e932417534d748d686150da5fcae726c71da02565";
      organizationTrello organization = organizationTrello("5daf8dc6a13a93592f5af2a0", tokenUser);
      organization.getRead(tokenUser).then((void v){
        List<Board> organizationBoards = organization.getListBoards(tokenUser);
        organizationBoards[0].getListCardRead(tokenUser).then((void v){
          List<String> cardIDs = organizationBoards[0].getListCardIds(tokenUser);
          expect(cardIDs[0], "5daf8e08d963d079dfbae2a2");
        });
      });
    });

    test('ID Card[1]', (){
      String tokenUser = "eeb43529b467074ea181012e932417534d748d686150da5fcae726c71da02565";
      organizationTrello organization = organizationTrello("5daf8dc6a13a93592f5af2a0", tokenUser);
      organization.getRead(tokenUser).then((void v){
        List<Board> organizationBoards = organization.getListBoards(tokenUser);
        organizationBoards[0].getListCardRead(tokenUser).then((void v){
          List<String> cardIDs = organizationBoards[0].getListCardIds(tokenUser);
          expect(cardIDs[1], "5daf8e0b2644e04e515bdda6");
        });
      });
    });

    test('ID Card[2]', (){
      String tokenUser = "eeb43529b467074ea181012e932417534d748d686150da5fcae726c71da02565";
      organizationTrello organization = organizationTrello("5daf8dc6a13a93592f5af2a0", tokenUser);
      organization.getRead(tokenUser).then((void v){
        List<Board> organizationBoards = organization.getListBoards(tokenUser);
        organizationBoards[0].getListCardRead(tokenUser).then((void v){
          List<String> cardIDs = organizationBoards[0].getListCardIds(tokenUser);
          expect(cardIDs[2], "5daf8e0dcf0c9f3141f8ae8f");
        });
      });
    });

    test('ID Card[3]', (){
      String tokenUser = "eeb43529b467074ea181012e932417534d748d686150da5fcae726c71da02565";
      organizationTrello organization = organizationTrello("5daf8dc6a13a93592f5af2a0", tokenUser);
      organization.getRead(tokenUser).then((void v){
        List<Board> organizationBoards = organization.getListBoards(tokenUser);
        organizationBoards[0].getListCardRead(tokenUser).then((void v){
          List<String> cardIDs = organizationBoards[0].getListCardIds(tokenUser);
          expect(cardIDs[3], "5daf8e1887a69d445b10e5f9");
        });
      });
    });

    test('ID Card[4]', (){
      String tokenUser = "eeb43529b467074ea181012e932417534d748d686150da5fcae726c71da02565";
      organizationTrello organization = organizationTrello("5daf8dc6a13a93592f5af2a0", tokenUser);
      organization.getRead(tokenUser).then((void v){
        List<Board> organizationBoards = organization.getListBoards(tokenUser);
        organizationBoards[0].getListCardRead(tokenUser).then((void v){
          List<String> cardIDs = organizationBoards[0].getListCardIds(tokenUser);
          expect(cardIDs[4], "5daf8e1944e44f5d6d85a65c");
        });
      });
    });

    test('Name Card[0]', (){
      String tokenUser = "eeb43529b467074ea181012e932417534d748d686150da5fcae726c71da02565";
      organizationTrello organization = organizationTrello("5daf8dc6a13a93592f5af2a0", tokenUser);
      organization.getRead(tokenUser).then((void v){
        List<Board> organizationBoards = organization.getListBoards(tokenUser);
        organizationBoards[0].getListCardRead(tokenUser).then((void v){
          List<String> cardNames = organizationBoards[0].getListCardNames(tokenUser);
          expect(cardNames[0], "Card1");
        });
      });
    });

    test('Name Card[1]', (){
      String tokenUser = "eeb43529b467074ea181012e932417534d748d686150da5fcae726c71da02565";
      organizationTrello organization = organizationTrello("5daf8dc6a13a93592f5af2a0", tokenUser);
      organization.getRead(tokenUser).then((void v){
        List<Board> organizationBoards = organization.getListBoards(tokenUser);
        organizationBoards[0].getListCardRead(tokenUser).then((void v){
          List<String> cardNames = organizationBoards[0].getListCardNames(tokenUser);
          expect(cardNames[1], "Card2");
        });
      });
    });

    test('Name Card[2]', (){
      String tokenUser = "eeb43529b467074ea181012e932417534d748d686150da5fcae726c71da02565";
      organizationTrello organization = organizationTrello("5daf8dc6a13a93592f5af2a0", tokenUser);
      organization.getRead(tokenUser).then((void v){
        List<Board> organizationBoards = organization.getListBoards(tokenUser);
        organizationBoards[0].getListCardRead(tokenUser).then((void v){
          List<String> cardNames = organizationBoards[0].getListCardNames(tokenUser);
          expect(cardNames[2], "Card3");
        });
      });
    });

    test('Name Card[3]', (){
      String tokenUser = "eeb43529b467074ea181012e932417534d748d686150da5fcae726c71da02565";
      organizationTrello organization = organizationTrello("5daf8dc6a13a93592f5af2a0", tokenUser);
      organization.getRead(tokenUser).then((void v){
        List<Board> organizationBoards = organization.getListBoards(tokenUser);
        organizationBoards[0].getListCardRead(tokenUser).then((void v){
          List<String> cardNames = organizationBoards[0].getListCardNames(tokenUser);
          expect(cardNames[3], "T2Card1");
        });
      });
    });

    test('Name Card[4]', (){
      String tokenUser = "eeb43529b467074ea181012e932417534d748d686150da5fcae726c71da02565";
      organizationTrello organization = organizationTrello("5daf8dc6a13a93592f5af2a0", tokenUser);
      organization.getRead(tokenUser).then((void v){
        List<Board> organizationBoards = organization.getListBoards(tokenUser);
        organizationBoards[0].getListCardRead(tokenUser).then((void v){
          List<String> cardNames = organizationBoards[0].getListCardNames(tokenUser);
          expect(cardNames[4], "T2Card2");
        });
      });
    });

    test('Stats Card[0]', (){
      String tokenUser = "eeb43529b467074ea181012e932417534d748d686150da5fcae726c71da02565";
      organizationTrello organization = organizationTrello("5daf8dc6a13a93592f5af2a0", tokenUser);
      organization.getRead(tokenUser).then((void v){
        List<Board> organizationBoards = organization.getListBoards(tokenUser);
        organizationBoards[0].getListCardRead(tokenUser).then((void v){
          List<bool> cardStats = organizationBoards[0].getListCardStats(tokenUser);
          expect(cardStats[0], false);
        });
      });
    });

    test('Stats Card[1]', (){
      String tokenUser = "eeb43529b467074ea181012e932417534d748d686150da5fcae726c71da02565";
      organizationTrello organization = organizationTrello("5daf8dc6a13a93592f5af2a0", tokenUser);
      organization.getRead(tokenUser).then((void v){
        List<Board> organizationBoards = organization.getListBoards(tokenUser);
        organizationBoards[0].getListCardRead(tokenUser).then((void v){
          List<bool> cardStats = organizationBoards[0].getListCardStats(tokenUser);
          expect(cardStats[1], true);
        });
      });
    });

    test('Stats Card[2]', (){
      String tokenUser = "eeb43529b467074ea181012e932417534d748d686150da5fcae726c71da02565";
      organizationTrello organization = organizationTrello("5daf8dc6a13a93592f5af2a0", tokenUser);
      organization.getRead(tokenUser).then((void v){
        List<Board> organizationBoards = organization.getListBoards(tokenUser);
        organizationBoards[0].getListCardRead(tokenUser).then((void v){
          List<bool> cardStats = organizationBoards[0].getListCardStats(tokenUser);
          expect(cardStats[2], true);
        });
      });
    });

    test('Stats Card[3]', (){
      String tokenUser = "eeb43529b467074ea181012e932417534d748d686150da5fcae726c71da02565";
      organizationTrello organization = organizationTrello("5daf8dc6a13a93592f5af2a0", tokenUser);
      organization.getRead(tokenUser).then((void v){
        List<Board> organizationBoards = organization.getListBoards(tokenUser);
        organizationBoards[0].getListCardRead(tokenUser).then((void v){
          List<bool> cardStats = organizationBoards[0].getListCardStats(tokenUser);
          expect(cardStats[3], false);
        });
      });
    });

    test('Stats Card[4]', (){
      String tokenUser = "eeb43529b467074ea181012e932417534d748d686150da5fcae726c71da02565";
      organizationTrello organization = organizationTrello("5daf8dc6a13a93592f5af2a0", tokenUser);
      organization.getRead(tokenUser).then((void v){
        List<Board> organizationBoards = organization.getListBoards(tokenUser);
        organizationBoards[0].getListCardRead(tokenUser).then((void v){
          List<bool> cardStats = organizationBoards[0].getListCardStats(tokenUser);
          expect(cardStats[4], false);
        });
      });
    });

  });
}