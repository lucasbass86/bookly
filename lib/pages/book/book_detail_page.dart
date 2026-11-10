import 'package:bookly/dialogs/dialogs.dart';
import 'package:bookly/models/models.dart';
import 'package:bookly/pages/pages.dart';
import 'package:bookly/services/services.dart';
import 'package:bookly/theme/theme.dart';
import 'package:bookly/utils/enums.dart';
import 'package:bookly/utils/extensions.dart';
import 'package:bookly/utils/utils.dart';
import 'package:bookly/widgets/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BookDetailPage extends StatefulWidget {
  static const String routeName = 'BookDetailPage';
  const BookDetailPage({super.key});

  @override
  State<BookDetailPage> createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  late BookService bookService;
  late Book book;
  bool isLoading = true;
  late BookState state;
  List<Book> relateds = [];

  @override
  Widget build(BuildContext context) {
    bookService = Provider.of<BookService>(context);
    if (isLoading) {
      book = ModalRoute.of(context)!.settings.arguments as Book;
      state = book.state;
      isLoading = false;
    }
    Widget image = CachedNetworkImage(
      imageUrl: book.cover,
      fit: BoxFit.cover,
      placeholder: (context, url) => Center(
        child: SizedBox(width: 30, height: 30, child: CircularProgressIndicator(strokeWidth: 3)),
      ),
      errorWidget: (context, url, error) => Image.asset(Utils.logo, width: 150, height: 200),
      imageBuilder: (context, imageProvider) =>
          Image(image: imageProvider, width: 150, fit: BoxFit.fitWidth),
    );
    return Scaffold(
      appBar: _appBar(context),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          if (book.cover != '') {
                            Navigator.pushNamed(
                              context,
                              CoverDetailPage.routeName,
                              arguments: book,
                            );
                          }
                        },
                        child: Container(
                          color: book.cover.isEmpty ? AppColors.border : Colors.transparent,
                          child: ClipRRect(
                            borderRadius: BorderRadiusGeometry.circular(20),
                            child: Hero(tag: book.id, child: image),
                          ),
                        ),
                      ),
                    ),
                    20.h,
                    if (book.title != null)
                      Text(
                        book.title ?? '',
                        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    10.h,
                    if (book.author != null)
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(
                          context,
                          SearchPage.routeName,
                          arguments: AdvancedSearch(toSearch: book.author!, type: Search.author),
                        ),
                        child: Text(book.author!),
                      ),
                    20.h,
                    Divider(),
                    20.h,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          spacing: 10,
                          children: [Icon(Icons.label_important_outline_rounded), Text('Género')],
                        ),
                        Text(
                          book.category.displayName,
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    if (book.pages != 0)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          10.h,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                spacing: 10,
                                children: [Icon(Icons.menu_book_rounded), Text('Páginas')],
                              ),
                              Text(
                                book.pages.toString(),
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ],
                      ),
                    if (book.publisher != null && book.publisher!.isNotEmpty)
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(
                          context,
                          SearchPage.routeName,
                          arguments: AdvancedSearch(
                            toSearch: book.publisher!,
                            type: Search.publisher,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            10.h,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  spacing: 10,
                                  children: [Icon(Icons.business_outlined), Text('Editorial')],
                                ),
                                Text(
                                  book.publisher ?? '',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    if (book.publishYear != '')
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          10.h,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                spacing: 10,
                                children: [Icon(Icons.calendar_month), Text('Año de publicación')],
                              ),
                              Text(
                                book.publishYear ?? '',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ],
                      ),
                    if (book.isbn != '')
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          10.h,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(spacing: 10, children: [Icon(Icons.qr_code), Text('ISBN')]),
                              SelectableText(
                                book.isbn ?? '',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ],
                      ),
                    if (book.observations != '')
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          10.h,
                          Row(
                            spacing: 10,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.person_2_outlined),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  spacing: 10,
                                  children: [
                                    Text('Observaciones'),
                                    Text(
                                      book.observations ?? '',
                                      style: TextStyle(fontWeight: FontWeight.w500),
                                      textAlign: TextAlign.justify,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    20.h,
                    Divider(),
                    20.h,
                    ListTile(
                      shape: StadiumBorder(),
                      onTap: () async {
                        final resp = await _changeState(context, state);
                        if (resp != null && context.mounted) {
                          final updatedBook = book.copyWith(state: resp);
                          final bookService = Provider.of<BookService>(context, listen: false);
                          final success = await bookService.updateBookState(updatedBook);
                          if (success && context.mounted) {
                            Utils.snackBar(context, 'Estado actualizado');
                            state = resp;
                            setState(() {});
                          } else {
                            if (context.mounted) {
                              Utils.snackBar(context, 'Algo ha fallado...', isBad: true);
                            }
                          }
                        }
                      },
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Estado de lectura', style: TextStyle(fontWeight: FontWeight.w700)),
                          BookStateWidget(state: state),
                        ],
                      ),
                      trailing: Icon(Icons.arrow_forward_ios_sharp, size: 17),
                    ),
                    20.h,
                    _related(),
                    20.h,
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final resp = await Navigator.pushNamed(
                  context,
                  NewBookPage.routeName,
                  arguments: book,
                );
                if (resp != null && resp is Book) {
                  book = resp;
                  setState(() {});
                }
              },
              child: Row(
                spacing: 20,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.edit_outlined, size: 30),
                  Text('Editar libro', style: TextStyle(fontSize: 20)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      title: GestureDetector(onTap: () => Navigator.pop(context), child: Text('Mi libro')),
      actions: [
        PopupMenuButton(
          tooltip: 'Más opciones',
          shape: StadiumBorder(),
          constraints: BoxConstraints(maxWidth: 50),
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                onTap: () async {
                  List<Book> related = await bookService.getRelatedBooks(id: book.id);
                  final resp = await _addRelated(related);
                  if (resp != null) {
                    final success = await bookService.insertRelatedBook(
                      userId: book.userId,
                      id: book.id,
                      idrelated: resp.id,
                    );
                    if (success && context.mounted) {
                      Utils.snackBar(context, 'Ha comenzado una nueva relación 🎉');
                      setState(() {});
                    }
                  }
                },
                child: Icon(Icons.bookmarks_rounded),
              ),
              PopupMenuItem(
                onTap: () async {
                  final resp = await showMessage(
                    context: context,
                    title: '¿Eliminar libro?',
                    showCancel: true,
                    header: Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(bottom: 20),
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.error.withAlpha(100),
                      ),
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: Icon(Icons.delete, color: AppColors.background),
                      ),
                    ),
                    subtitle: 'Esta acción no se puede deshacer',
                  );
                  if (resp != null && resp && context.mounted) {
                    final success = await bookService.deleteBook(book);
                    if (success && context.mounted) {
                      Utils.snackBar(context, 'Libro borrado 😭');
                      Navigator.pop(context);
                    } else {
                      if (context.mounted) {
                        Utils.snackBar(context, 'Algo ha fallado...', isBad: true);
                      }
                    }
                  }
                },
                child: Icon(Icons.delete),
              ),
            ];
          },
        ),
      ],
    );
  }

  Widget _related() {
    return FutureBuilder(
      future: bookService.getRelatedBooks(id: book.id),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData && snapshot.data.isNotEmpty) {
          List<Book> list = snapshot.data;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(),
              20.h,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Libros relacionados',
                    style: TextStyle(fontSize: 21, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    '${list.length}',
                    style: TextStyle(fontSize: 21, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              20.h,
              SizedBox(
                height: 180,
                child: list.isNotEmpty
                    ? ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: list.length,
                        separatorBuilder: (BuildContext context, int index) => 10.w,
                        itemBuilder: (context, index) => RelatedBookWidget(
                          book: list[index],
                          onLongPress: () async {
                            final resp = await showMessage(
                              context: context,
                              title: '¿Eliminar libro relacionado?',
                              showCancel: true,
                              header: Container(
                                padding: const EdgeInsets.all(10),
                                margin: const EdgeInsets.only(bottom: 20),
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.error.withAlpha(100),
                                ),
                                child: FittedBox(
                                  fit: BoxFit.cover,
                                  child: Icon(Icons.delete, color: AppColors.background),
                                ),
                              ),
                              subtitle: 'Esta acción no se puede deshacer',
                            );
                            if (resp != null && resp) {
                              final success = await bookService.deleteRelatedBook(
                                id: book.id,
                                idrelated: list[index].id,
                              );
                              if (success && context.mounted) {
                                Utils.snackBar(context, 'Relación terminada 😭');
                                setState(() {});
                              }
                            }
                          },
                        ),
                      )
                    : Center(
                        child: Opacity(
                          opacity: 0.5,
                          child: Image.asset(Utils.logo, width: 200, height: 200),
                        ),
                      ),
              ),
              20.h,
              Divider(),
            ],
          );
        }
        return SizedBox.shrink();
      },
    );
  }

  Future<Book?> _addRelated(List<Book> related) async {
    TextEditingController searchController = TextEditingController();
    Book? selectedBook;
    if (!context.mounted) return null;
    return showModalBottomSheet(
      showDragHandle: false,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            List<Book> list = bookService.books.where((value) => value.id != book.id).toList();
            String toSearch = searchController.text.trim().toUpperCase();
            list = list
                .where(
                  (b) => searchController.text.isEmpty
                      ? true
                      : b.author!.toUpperCase().contains(toSearch) ||
                            b.title!.toUpperCase().contains(toSearch) ||
                            b.observations!.toUpperCase().contains(toSearch),
                )
                .where((b) => related.every((c) => b.id != c.id))
                .toList();
            return Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Relacionar con...',
                      style: TextStyle(fontSize: 21, fontWeight: FontWeight.w700),
                    ),
                    20.h,
                    TextField(
                      controller: searchController,
                      maxLength: 50,
                      decoration: InputDecoration(
                        hint: Text('Título, autor o género...', style: TextStyle(fontSize: 17)),
                        counterText: '',
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (value) => setState(() {}),
                    ),
                    20.h,
                    SizedBox(
                      height: 250,
                      child: list.isNotEmpty
                          ? ListView.separated(
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemCount: list.length,
                              separatorBuilder: (BuildContext context, int index) => 10.w,
                              itemBuilder: (context, index) => RelatedSearchBookWidget(
                                book: list[index],
                                isSelected: selectedBook == list[index],
                                onTap: () {
                                  setState(() {
                                    if (selectedBook == list[index]) {
                                      selectedBook = null;
                                    } else {
                                      selectedBook = list[index];
                                    }
                                  });
                                },
                              ),
                              // BookWidget(
                              //   book: list[index],
                              //   isSelected: selectedBook == list[index],
                              //   onTap: () {
                              //     setState(() {
                              //       if (selectedBook == list[index]) {
                              //         selectedBook = null;
                              //       } else {
                              //         selectedBook = list[index];
                              //       }
                              //     });
                              //   },
                              // ),
                            )
                          : Center(
                              child: Opacity(
                                opacity: 0.5,
                                child: Image.asset(Utils.logo, width: 200, height: 200),
                              ),
                            ),
                    ),
                    20.h,
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: selectedBook != null
                            ? () {
                                Navigator.pop(context, selectedBook);
                              }
                            : null,
                        child: Text('Agregar'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<BookState?> _changeState(BuildContext context, BookState newState) {
    return showModalBottomSheet<BookState>(
      showDragHandle: false,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    spacing: 30,
                    children: [
                      Text('Nuevo estado', style: TextStyle(fontSize: 20)),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: DropdownButton(
                            value: newState,
                            borderRadius: BorderRadius.circular(10),
                            isExpanded: true,
                            underline: Container(),
                            iconEnabledColor: AppColors.border,
                            padding: const EdgeInsets.only(left: 10),
                            items: BookState.values
                                .skip(1)
                                .map((s) => DropdownMenuItem(value: s, child: Text(s.displayName)))
                                .toList(),
                            onChanged: (value) => setState(() => newState = value!),
                          ),
                        ),
                      ),
                    ],
                  ),
                  20.h,
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context, newState),
                      child: Text('Cambiar'),
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
}
