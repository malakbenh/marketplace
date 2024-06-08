import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  static const String pageRoute = 'search';
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          // margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 30),
          width: double.infinity,
          height: 55,
          child: TextField(
            controller: controller,
            onChanged: (value) {
              setState(() {
                // BuildSearchMovieList(
                //   q: value,
                // );
              });
            },
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xff35A072),
              prefixIcon: InkWell(
                overlayColor:
                    const MaterialStatePropertyAll(Colors.transparent),
                onTap: () {
                  setState(() {
                    // BuildSearchMovieList(
                    //   q: controller.text,
                    // );
                  });
                },
                child: const Icon(
                  Icons.search,
                  size: 32,
                  color: Colors.white,
                ),
              ),
              hintText: 'Search',
              hintStyle: const TextStyle(color: Colors.white),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(30),
              ),
              focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(30)),
            ),
          ),
        ),
      ),
      // body:BuildSearchBodyList(q: controller.text),
    );
  }
}
