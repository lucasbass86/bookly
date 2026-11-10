import 'package:bookly/models/models.dart';
import 'package:bookly/services/services.dart';
import 'package:bookly/utils/enums.dart';
import 'package:bookly/utils/extensions.dart';
import 'package:bookly/utils/utils.dart';
import 'package:bookly/widgets/widgets.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  static const String routeName = 'SearchPage';
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late BookService bookService;
  late MainProvider mainProvider;
  TextEditingController searchController = TextEditingController();
  List<BookCategory> categories = [];
  List<Book> books = [];
  bool showFilter = false;
  AdvancedSearch? advancedSearch;
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    bookService = Provider.of<BookService>(context, listen: false);
    mainProvider = Provider.of<MainProvider>(context);
    final arguments = ModalRoute.of(context)?.settings.arguments;
    if (arguments != null && arguments is AdvancedSearch && isLoading) {
      advancedSearch = arguments;
      searchController = TextEditingController(text: advancedSearch!.toSearch);
      isLoading = false;
    }
    List<BookCategory> fromService = bookService.books.map((b) => b.category).toSet().toList();
    categories = [BookCategory.all, ...fromService];
    String toSearch = searchController.text.trim().toUpperCase();
    books = bookService.books
        .where(
          (b) => mainProvider.category == BookCategory.all
              ? true
              : b.category == mainProvider.category,
        )
        .where(
          (b) => searchController.text == ''
              ? true
              : (b.author!.toUpperCase().contains(toSearch) ||
                    b.title!.toUpperCase().contains(toSearch) ||
                    b.observations!.toUpperCase().contains(toSearch) ||
                    b.publisher!.toUpperCase().contains(toSearch) ||
                    b.category.displayName.toUpperCase().contains(toSearch)),
        )
        .where((b) => mainProvider.state == BookState.all ? true : b.state == mainProvider.state)
        .toList();
    return Scaffold(
      appBar: _appBar(context),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _searchField(),
            20.h,
            _filters(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Resultado', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21)),
                Text(
                  '${books.length} libros',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21),
                ),
              ],
            ),
            20.h,
            _items(),
          ],
        ),
      ),
    );
  }

  Expanded _items() {
    return Expanded(
      child: books.isNotEmpty
          ? ListView.separated(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: books.length,
              separatorBuilder: (BuildContext context, int index) => 10.h,
              itemBuilder: (BuildContext context, int index) =>
                  BookSearchWidget(book: books[index]),
            )
          : Center(child: Opacity(opacity: 0.5, child: Image.asset(Utils.logo))),
    );
  }

  TextField _searchField() {
    return TextField(
      controller: searchController,
      maxLength: 50,
      decoration: InputDecoration(
        hint: Text('Título, autor o género...', style: TextStyle(fontSize: 17)),
        counterText: '',
        prefixIcon: Icon(Icons.search),
        suffixIcon: searchController.text.isEmpty
            ? null
            : GestureDetector(
                onTap: () => setState(() => searchController.text = ''),
                child: Icon(Icons.clear),
              ),
      ),
      onChanged: (value) => setState(() {}),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      title: GestureDetector(onTap: () => Navigator.pop(context), child: Text('Buscar libros')),
      actions: [
        IconButton(
          tooltip: 'Filtros',
          onPressed: () => setState(() => showFilter = !showFilter),
          icon: Icon(Icons.tune_rounded),
        ),
      ],
    );
  }

  Widget _filters() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SizeTransition(
            sizeFactor: animation,
            axisAlignment: -1.0, // Crece desde arriba
            child: child,
          ),
        );
      },
      child: showFilter
          ? Column(
              key: const ValueKey('filters_open'),
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                20.h,
                CategoryFilterWidget(
                  categories: categories,
                  selectedCategory: mainProvider.category,
                ),
                20.h,
                const Divider(),
                20.h,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [...BookState.values.map((s) => StateWidget(state: s))],
                ),
                20.h,
                const Divider(),
                20.h,
              ],
            )
          : const SizedBox.shrink(key: ValueKey('filters_closed')),
    );
  }
}
