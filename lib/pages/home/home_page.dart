import 'package:bookly/models/models.dart';
import 'package:bookly/pages/pages.dart';
import 'package:bookly/preferences/preferences.dart';
import 'package:bookly/services/services.dart';
import 'package:bookly/theme/theme.dart';
import 'package:bookly/utils/enums.dart';
import 'package:bookly/utils/extensions.dart';
import 'package:bookly/utils/utils.dart';
import 'package:bookly/widgets/widgets.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  static const String routeName = 'HomePage';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _hasRun = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkData(context));
  }

  @override
  Widget build(BuildContext context) {
    BookService bookService = Provider.of<BookService>(context);
    MainProvider mainProvider = Provider.of<MainProvider>(context);
    List<Book> books = bookService.books
        .where((b) => mainProvider.state == BookState.all ? true : b.state == mainProvider.state)
        .toList();
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Mi biblioteca', style: TextStyle(fontSize: 35)),
            Text(
              'Mis libros, siempre conmigo',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w300),
            ),
          ],
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, SearchPage.routeName),
            icon: Icon(Icons.search),
          ),
          IconButton(
            onPressed: () async {
              await _showOrder(context);
              bookService.sortBooks();
            },
            icon: Icon(Icons.tune_rounded),
          ),
          IconButton(
            onPressed: () => Navigator.pushNamed(context, SettingsPage.routeName),
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, AddBookPage.routeName),
        child: Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [...BookState.values.map((s) => StateWidget(state: s))],
            ),
            20.h,
            Expanded(
              child: books.isNotEmpty
                  ? GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        mainAxisExtent: 240,
                      ),
                      itemCount: books.length,
                      itemBuilder: (BuildContext context, int index) =>
                          BookWidget(book: books[index]),
                    )
                  : Opacity(opacity: 0.3, child: Image.asset(Utils.logo)),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showOrder(BuildContext context) async {
    BookOrder bookOrder = Preferences.bookOrder;
    BookSort bookSort = Preferences.bookSort;
    return showModalBottomSheet(
      showDragHandle: false,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              child: Column(
                spacing: 20,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Ordenar libros por:',
                    style: TextStyle(fontSize: 23, fontWeight: FontWeight.w700),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: DropdownButton(
                      value: bookOrder,
                      borderRadius: BorderRadius.circular(10),
                      isExpanded: true,
                      underline: Container(),
                      iconEnabledColor: AppColors.border,
                      padding: const EdgeInsets.only(left: 10),
                      items: BookOrder.values
                          .map((o) => DropdownMenuItem(value: o, child: Text(o.displayName)))
                          .toList(),
                      onChanged: (value) {
                        bookOrder = value!;
                        setState(() {});
                      },
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: DropdownButton(
                      value: bookSort,
                      borderRadius: BorderRadius.circular(10),
                      isExpanded: true,
                      underline: Container(),
                      iconEnabledColor: AppColors.border,
                      padding: const EdgeInsets.only(left: 10),
                      items: BookSort.values
                          .map((o) => DropdownMenuItem(value: o, child: Text(o.displayName)))
                          .toList(),
                      onChanged: (value) {
                        bookSort = value!;
                        setState(() {});
                      },
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Preferences.bookOrder = bookOrder;
                        Preferences.bookSort = bookSort;
                        Navigator.pop(context);
                      },
                      child: Text('Aceptar'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _checkData(BuildContext context) async {
    if (!_hasRun) {
      _hasRun = true;
      Future.delayed(const Duration(seconds: 1), () async {
        if (context.mounted) await LicenseService.checkLicense(context);
        if (context.mounted) await UpdateService.checkUpdates(context);
        //INSERTAR EL USUARIO EL BOOKLY_USERS
        final userId = await BookService.getUserId(Preferences.email);
        if (userId != null) {
          Preferences.userId = userId;
        }
      });
    }
  }
}
