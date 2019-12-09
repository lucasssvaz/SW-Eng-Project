import 'package:flutter_test/flutter_test.dart';
import 'package:job_adventure/Screens/LoginScreen.dart';

void main(){
  testWidgets('Teste do login',(WidgetTester tester) async{
    await tester.pumpWidget(LoginScreen());
    final taskFinder = find.text('Para falhar');
    expect(taskFinder,findsOneWidget);
  });
}