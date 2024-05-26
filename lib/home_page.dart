import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:final_api_project/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

//widget için consumer kullanmamızın nedeni, widget içinde
//riverpod fonksiyonlarını kullanabilmek için

//the reason why we use consumerstatefulwidget instead of the normal one
//with this we can use ref.watch(), ref.read() and other riverpod functions
//in our widget
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: ListView.builder(
          itemBuilder: (context, index) {
            return RecipeItems(index);
          },
          itemCount: ref.watch(recipeList).length),
    );
  }
}

class RecipeItems extends ConsumerWidget {
  const RecipeItems(this.index, {super.key});
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: EdgeInsets.only(top: 1.h, bottom: 0.1.h, right: 1.w, left: 1.w),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 0.6.w),
        // recipelerin resimlerini ve ayrıntılarını görebilmek için
        // genişletilebilen tilecard kullanıyoruz

        //to see our recipe images and their description
        //we use the expansiontilecard
        child: ExpansionTileCard(
          initialElevation: 1,
          baseColor: const Color.fromARGB(255, 27, 50, 56),
          expandedColor: const Color.fromARGB(255, 27, 50, 56),
          elevation: 0,
          trailing: const Icon(null),
          //recipe adı

          //recipe name
          title: Text(
            ref.watch(recipeList)[index].name,
            maxLines: 3,
            style: const TextStyle(color: Colors.white),
          ),
          children: [
            const Divider(
              thickness: 5.0,
              color: Colors.blueGrey,
              height: 1.0,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.h, vertical: 1.w)),
            ),
            Column(
              children: [
                SizedBox(
                  width: 3.w,
                ),
                //recipe ayrıntıları

                //recipe descriptions
                Text(
                  "Ingredients:\n${ref.watch(recipeList)[index].ingredients.join(', ')}\n\nInstructions:\n${ref.watch(recipeList)[index].instructions.join(' ')}\n\nServings:\n${ref.watch(recipeList)[index].servings}\n\nCalories:\n${ref.watch(recipeList)[index].caloriesPerServing}\n",
                  style: const TextStyle(color: Colors.white),
                ),
                SizedBox(
                  width: 3.w,
                ),
               // recipe resimleri

               // recipe images
                Image.network(ref.watch(recipeList)[index].image)
              ],
            )
          ],
        ),
      ),
    );
  }
}
