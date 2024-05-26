

import 'package:dio/dio.dart';

import 'package:final_api_project/home_page.dart';
import 'package:final_api_project/recipe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

final dio = Dio();

//json datayı Recipe'ye çevirerek oluşturduklarımızı recipeList içine kayıt ediyoruz
//state provider kullanmamızın sebebi, listede widget build edilmişken bir değişiklik olursa
//setstate yapmaya gerek kalmadan widgetların kendilerini yenimelerini sağlamak(listview etc)

//we transform json data to our recipe class and add it to our recipelist
//the reason why we are using the stateprovider because if the list is altered somehow
//app can detect it and refresh the interface accordingly without using any setstate
Future<void> getRecipe(Ref ref) async {
  final response = await dio.get('https://dummyjson.com/recipes');
  List<dynamic> list = response.data['recipes'];

  for (var item in list) {
    ref.read(recipeList.notifier).state.add(Recipe.fromJson(item));
  }
}

// recipe listesi

//recipe list
StateProvider<List<Recipe>> recipeList = StateProvider<List<Recipe>>((ref) {
  return [];
});

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //riverpod kullanmak için ProviderScope ile sarmaladık

  //to use riverpod in our app we wrapped the entire thing with providerscope
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  Widget build(BuildContext context) {
    // widget boyutlarını kolayca ekrana göre ayarlayabilmek için ResponsiveSizer kullanıyoruz

    //to ensure that our app works on any device we wrapped it with responsivesizer
    return ResponsiveSizer(builder: (context, orientation, screentype) {
      return const SafeArea(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: HomeScreen(),
        ),
      );
    });
  }
}

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        backgroundColor: Colors.lightBlue,
        body: Center(
          child: SizedBox(
            width: 30.w,
            child: ElevatedButton(
              child: const Row(
                children: [
                  Icon(Icons.restaurant),
                  Text("Recipes", textDirection: TextDirection.ltr)
                ],
              ),
              onPressed: () async {
                // uygulama içindeyken zaten recipeleri internetten çektiysek
                // bir daha bunları çalıştırmamıza gerek kalmadı

                //if we already have the recipes in our list, we dont have to
                //use dio.get once again
                if(ref.watch(recipeList).isEmpty){
                final response = await dio.get('https://dummyjson.com/recipes');
                List<dynamic> list = response.data['recipes'];

                for (var item in list) {
                  ref
                      .read(recipeList.notifier)
                      .state
                      .add(Recipe.fromJson(item));
                }}
                //recipelerin olduğu ekrana animasyonlu bir şekilde gidiyoruz

                //when clicked on recipes, we will be redirected to that page with animations
                Navigator.of(context).push(animatedRoute());
              },
            ),
          ),
        ));
  }
}

// route animasyonu

//route animation
Route animatedRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => const HomePage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
