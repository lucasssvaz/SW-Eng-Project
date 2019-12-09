import 'package:flutter_test/flutter_test.dart';
import 'package:job_adventure/models/user.dart';

void main(){
  test('Login usuario Trello Key', (){
    final String userTrelloKey = "3b7b3d9cae92dd09da1f04315ae95309a2ce10fbfe7f9bd002f0720ba2de44ec";
    var thread = initialRoute(userTrelloKey);
    thread.then((User user){
      // Comparacao username
      expect(user.userName, 'leonsilva7');
      // Comparacao trelloKey
      expect(user.userKey, userTrelloKey);
    });
  });
}