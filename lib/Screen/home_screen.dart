import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:new_app_api/Screen/category_news.dart';
import 'package:new_app_api/Screen/news_detail.dart';
import 'package:new_app_api/Services/services.dart';
import 'package:new_app_api/model/category_data.dart';

import '../model/new_model.dart';

class NewsHomeScreen extends StatefulWidget {
  const NewsHomeScreen({super.key});

  @override
  _NewsHomeScreenState createState() => _NewsHomeScreenState();
}

class _NewsHomeScreenState extends State<NewsHomeScreen> {
  List<NewsModel> articles = [];
  List<CategoryModel> categories = [];
  bool isLoadin = true;
  getNews() async {
    NewsApi newsApi = NewsApi();
    await newsApi.getNews();
    articles = newsApi.dataStore;
    setState(() {
      isLoadin = false;
    });
  }

  @override
  void initState() {
    categories = getCategories();
    getNews();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "News Aggregator",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white, // Set the drawer icon color to white
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.black,
              ),
              child: Text(
                'News Aggregator',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
            ),
            // for category selection in Drawer
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
              ),
              child: ListView.builder(
                itemCount: categories.length,
                shrinkWrap: true,
                // Remove or set scrollDirection to Axis.vertical for vertical scrolling
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SelectedCategoryNews(
                            category: category.categoryName!,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      color: Colors.grey[300], // Set background color for list item
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        category.categoryName!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      body: isLoadin
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : SingleChildScrollView(
        child: Column(
          children: [
            // for home screen news
            ListView.builder(
              itemCount: articles.length,
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemBuilder: (context, index) {
                final article = articles[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewsDetail(newsModel: article),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            article.urlToImage!,
                            height: 250,
                            width: 400,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          article.title!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const Divider(thickness: 2),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

}
