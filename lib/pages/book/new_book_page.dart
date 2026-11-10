import 'dart:io';

import 'package:bookly/dialogs/dialogs.dart';
import 'package:bookly/helpers/helper.dart';
import 'package:bookly/models/models.dart';
import 'package:bookly/pages/pages.dart';
import 'package:bookly/preferences/preferences.dart';
import 'package:bookly/secrets/secrets.dart';
import 'package:bookly/services/services.dart';
import 'package:bookly/theme/theme.dart';
import 'package:bookly/utils/enums.dart';
import 'package:bookly/utils/extensions.dart';
import 'package:bookly/utils/utils.dart';
import 'package:bookly/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class NewBookPage extends StatefulWidget {
  static const String routeName = 'NewBookPage';
  const NewBookPage({super.key});

  @override
  State<NewBookPage> createState() => _NewBookPageState();
}

class _NewBookPageState extends State<NewBookPage> with WidgetsBindingObserver {
  bool _searchingCover = false;
  Book? book;
  late BookService bookService;
  BookCoverResult? bookCoverResult;
  File? image;
  BookCategory? category;
  BookState state = BookState.pending;
  OpenLibrary? openLibrary;
  Google? google;
  HardcoverBook? hardcoverBook;
  List<BookCategory> categories = [...BookCategory.values];
  TextEditingController titleController = TextEditingController();
  TextEditingController authorController = TextEditingController();
  TextEditingController publisherController = TextEditingController();
  TextEditingController isbnController = TextEditingController();
  TextEditingController publishedYearController = TextEditingController();
  TextEditingController pagesController = TextEditingController();
  TextEditingController observationsController = TextEditingController();
  bool isLoading = true;
  bool gettingData = false;
  String? loadingTitle;

  String? _searchUrl;
  String? _originalCoverUrl;
  File? _newCoverImage;
  String? _newCoverLink;

  @override
  void initState() {
    super.initState();
    categories.remove(BookCategory.all);
    categories.sort((a, b) => a.displayName.compareTo(b.displayName));
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _searchingCover) {
      _searchingCover = false;
      _readClipboard(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    bookService = Provider.of(context);
    final arguments = ModalRoute.of(context)!.settings.arguments;
    if (arguments is BookCoverResult && isLoading) {
      titleController = TextEditingController(text: arguments.titulo);
      authorController = TextEditingController(text: arguments.autor);
      image = arguments.imagen;
      isLoading = false;
    } else if (arguments is OpenLibrary && isLoading) {
      openLibrary = arguments;
      fillOpenLibrary();
      isLoading = false;
    } else if (arguments is Google && isLoading) {
      google = arguments;
      fillGoogle();
      isLoading = false;
    } else if (arguments is Book && isLoading) {
      book = arguments;
      fillBook();
      isLoading = false;
    } else if (arguments is HardcoverBook && isLoading) {
      hardcoverBook = arguments;
      fillHardcover();
      isLoading = false;
    }
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Text(book != null ? 'Editar libro' : 'Agregar libro'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: !gettingData
            ? Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _cover(context),
                          Text('Título'),
                          10.h,
                          TextField(
                            controller: titleController,
                            maxLength: 100,
                            textInputAction: TextInputAction.next,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: InputDecoration(counterText: ''),
                          ),
                          20.h,
                          Text('Autor'),
                          10.h,
                          TextField(
                            controller: authorController,
                            maxLength: 100,
                            textInputAction: TextInputAction.next,
                            textCapitalization: TextCapitalization.words,
                            decoration: InputDecoration(counterText: ''),
                          ),
                          20.h,
                          Text('Género'),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: DropdownButton(
                              value: category,
                              borderRadius: BorderRadius.circular(10),
                              isExpanded: true,
                              underline: Container(),
                              iconEnabledColor: AppColors.border,
                              padding: const EdgeInsets.only(left: 10),
                              items: categories
                                  .map(
                                    (c) => DropdownMenuItem(value: c, child: Text(c.displayName)),
                                  )
                                  .toList(),
                              onChanged: (value) => setState(() {
                                category = value;
                              }),
                            ),
                          ),
                          20.h,
                          Text('Editorial'),
                          10.h,
                          TextField(
                            controller: publisherController,
                            maxLength: 100,
                            textInputAction: TextInputAction.next,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: InputDecoration(counterText: ''),
                          ),
                          20.h,
                          Text('ISBN'),
                          10.h,
                          Row(
                            spacing: 20,
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: isbnController,
                                  maxLength: 13,
                                  textAlign: TextAlign.center,
                                  textInputAction: TextInputAction.next,
                                  textCapitalization: TextCapitalization.sentences,
                                  decoration: InputDecoration(counterText: ''),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: AppColors.border),
                                ),
                                child: IconButton(
                                  onPressed: () => _searchService(context),
                                  icon: Icon(Icons.qr_code_scanner),
                                ),
                              ),
                            ],
                          ),
                          20.h,
                          Row(
                            spacing: 20,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Año de publicación'),
                                    10.h,
                                    TextField(
                                      controller: publishedYearController,
                                      maxLength: 4,
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      textInputAction: TextInputAction.next,
                                      decoration: InputDecoration(counterText: ''),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Páginas'),
                                    10.h,
                                    TextField(
                                      controller: pagesController,
                                      textAlign: TextAlign.center,
                                      maxLength: 4,
                                      keyboardType: TextInputType.number,
                                      textInputAction: TextInputAction.next,
                                      decoration: InputDecoration(counterText: ''),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          20.h,
                          Text('Observaciones'),
                          10.h,
                          TextField(
                            controller: observationsController,
                            maxLength: 500,
                            maxLines: 7,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(counterText: ''),
                          ),
                          20.h,
                          Text('Estado de lectura'),
                          10.h,
                          _states(),
                          20.h,
                        ],
                      ),
                    ),
                  ),
                  if (book == null) _saveButton(context),
                  if (book != null) _updateButton(context),
                ],
              )
            : LoadingWidget(title: loadingTitle),
      ),
    );
  }

  Widget _cover(BuildContext context) {
    Widget cover;
    if (coverChanged && _searchUrl != null) {
      cover = Image.network(_searchUrl!, height: 220, width: 150, fit: BoxFit.fitWidth);
    } else if (book?.coverUrl?.isNotEmpty == true) {
      cover = Image.network(book!.cover, height: 220, width: 150, fit: BoxFit.fitWidth);
    } else if (hardcoverBook?.imageUrl?.isNotEmpty == true) {
      cover = Image.network(
        hardcoverBook!.imageUrl!,
        height: 220,
        width: 150,
        fit: BoxFit.fitWidth,
      );
    } else if (openLibrary?.cover.isNotEmpty == true) {
      cover = Image.network(openLibrary!.cover, height: 220, width: 150, fit: BoxFit.fitWidth);
    } else if (google?.thumbnail?.isNotEmpty == true) {
      cover = Image.network(google!.thumbnail!, height: 220, width: 150, fit: BoxFit.fitWidth);
    } else if (image != null) {
      cover = Image.file(image!, height: 220, width: 150, fit: BoxFit.fitWidth);
    } else if (_searchUrl?.isNotEmpty == true) {
      cover = Image.network(_searchUrl!, height: 220, width: 150, fit: BoxFit.fitWidth);
    } else {
      cover = Container(
        color: AppColors.border,
        child: Image.asset(Utils.logo, height: 220, width: 150, fit: BoxFit.fitWidth),
      );
    }

    return Center(
      child: Stack(
        children: [
          ClipRRect(borderRadius: BorderRadiusGeometry.circular(20), child: cover),
          Positioned(
            right: 0,
            bottom: 0,
            child: GestureDetector(
              onTap: () => _chooseCover(context),
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.primary),
                child: Icon(Icons.camera_alt_outlined, color: AppColors.background),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void fillBook() {
    titleController = TextEditingController(text: book!.title);
    authorController = TextEditingController(text: book!.author);
    publisherController = TextEditingController(text: book!.publisher);
    publishedYearController = TextEditingController(text: book!.publishYear);
    isbnController = TextEditingController(text: book!.isbn);
    observationsController = TextEditingController(text: book!.observations);
    pagesController = TextEditingController(text: book!.pages.toString());
    category = book!.category;
    _originalCoverUrl = book!.coverUrl;
  }

  void fillOpenLibrary() {
    titleController = TextEditingController(text: openLibrary!.title);
    authorController = TextEditingController(
      text: openLibrary!.authors.isNotEmpty ? openLibrary?.authors[0].name : '',
    );
    publisherController = TextEditingController(text: openLibrary?.publishers[0].name ?? '');
    publishedYearController = TextEditingController(text: openLibrary?.publishDate ?? '');
    observationsController = TextEditingController(text: openLibrary?.subtitle ?? '');
    isbnController = TextEditingController(
      text: openLibrary?.identifiers?.isbn13[0].toString() ?? '',
    );
    pagesController = TextEditingController(
      text: openLibrary?.numberOfPages != null ? openLibrary!.numberOfPages.toString() : '0',
    );
  }

  void fillGoogle() {
    titleController = TextEditingController(text: google?.title ?? '');
    authorController = TextEditingController(
      text: google?.authors != null ? google?.authors[0] : '',
    );
    publisherController = TextEditingController(text: google?.publisher ?? '');
    publishedYearController = TextEditingController(text: google?.publishedDate ?? '');
    observationsController = TextEditingController(text: google?.description ?? '');
    isbnController = TextEditingController(text: google?.isbn13 ?? '');
    pagesController = TextEditingController(text: google?.pageCount.toString() ?? '0');
  }

  void fillHardcover() {
    titleController = TextEditingController(text: hardcoverBook!.title);
    authorController = TextEditingController(text: hardcoverBook!.author);
    observationsController = TextEditingController(text: hardcoverBook!.description ?? '');
    isbnController = TextEditingController(text: hardcoverBook?.isbns[0]);
    pagesController = TextEditingController(text: hardcoverBook!.pages?.toString() ?? '0');
  }

  void _searchService(BuildContext context) async {
    final String isbn = await Navigator.pushNamed(context, IsbnScannerPage.routeName) as String;
    if (isbn.isEmpty || !context.mounted) return;
    if (book == null && await Helper.checkBookExists(context, isbn)) return;
    if (!context.mounted) return;

    final resp = await searchApisDialog(context, isbn);
    if (resp != null) {
      if (resp is OpenLibrary) {
        openLibrary = resp;
        fillOpenLibrary();
      } else if (resp is Google) {
        google = resp;
        fillGoogle();
      } else if (resp is HardcoverBook) {
        hardcoverBook = resp;
        fillHardcover();
      }
      setState(() {});
    }
  }

  Widget _saveButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          if (titleController.text.isEmpty) {
            Utils.showSnackBar(context, 'Indica el título', isBad: true);
            return;
          }
          if (authorController.text.isEmpty) {
            Utils.showSnackBar(context, '¿Quién es el autor?', isBad: true);
            return;
          }
          if (category == null) {
            Utils.showSnackBar(context, 'Selecciona el género', isBad: true);
            return;
          }
          setState(() {
            loadingTitle = 'Salvando datos';
            gettingData = true;
          });
          String bookId = Utils.uuid();
          String? cover = await _urlCover(bookId);
          final resp = await bookService.insertBook(
            Book.withId(
              id: bookId,
              userId: Preferences.userId,
              title: titleController.text,
              author: authorController.text,
              category: category!,
              publisher: publisherController.text,
              publishYear: publishedYearController.text,
              pages: pagesController.text.isNotEmpty ? int.parse(pagesController.text) : 0,
              isbn: isbnController.text,
              observations: observationsController.text,
              state: state,
              coverUrl: cover,
            ),
          );
          if (resp && context.mounted) {
            Utils.showSnackBar(context, 'Libro guardado 🎉');
            Navigator.pop(context);
          } else {
            if (context.mounted) {
              Utils.showSnackBar(context, 'Algo ha fallado', isBad: true);
            }
          }
        },
        child: Text('Agregar libro'),
      ),
    );
  }

  Widget _updateButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          if (titleController.text.isEmpty) {
            Utils.showSnackBar(context, 'Indica el título', isBad: true);
            return;
          }
          if (authorController.text.isEmpty) {
            Utils.showSnackBar(context, '¿Quién es el autor?', isBad: true);
            return;
          }
          if (category == null) {
            Utils.showSnackBar(context, 'Selecciona el género', isBad: true);
            return;
          }
          setState(() {
            loadingTitle = 'Actualizando información';
            gettingData = true;
          });

          String? cover;
          if (_newCoverImage != null || _newCoverLink != null || _searchUrl != null) {
            cover = await _urlCover(book!.id);
          }

          Book updateBook = Book.withId(
            id: book!.id,
            userId: Preferences.userId,
            title: titleController.text,
            author: authorController.text,
            category: category!,
            publisher: publisherController.text,
            publishYear: publishedYearController.text,
            pages: pagesController.text.isNotEmpty ? int.parse(pagesController.text) : 0,
            isbn: isbnController.text,
            observations: observationsController.text,
            state: state,
            coverUrl: cover ?? _originalCoverUrl,
          );
          final resp = await bookService.updateBook(updateBook);
          if (resp && context.mounted) {
            Utils.showSnackBar(context, 'Libro modificado 🎉');
            Navigator.pop(context, updateBook);
          } else {
            if (context.mounted) {
              Utils.showSnackBar(context, 'Algo ha fallado', isBad: true);
            }
          }
        },
        child: Text('Actualizar'),
      ),
    );
  }

  Future<dynamic> _chooseCover(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      showDragHandle: false,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () async {
                  final resp = await Helper.takeCoverPhoto(context);
                  if (resp != null && context.mounted) {
                    setState(() {
                      image = resp;
                      _newCoverImage = image;
                      _newCoverLink = null;
                    });
                    Navigator.pop(context);
                  }
                },
                child: Row(
                  spacing: 20,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.camera_alt_outlined, size: 35),
                    Text('Hacer foto', style: TextStyle(fontSize: 21)),
                  ],
                ),
              ),
              20.h,
              OutlinedButton(
                onPressed: _searchCover,
                child: Row(
                  spacing: 20,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.image_search_rounded, size: 35),
                    Text('Buscar en internet', style: TextStyle(fontSize: 21)),
                  ],
                ),
              ),
              20.h,
              OutlinedButton(
                onPressed: () async {
                  final resp = await Helper.pickCoverFromGallery(context);
                  if (resp != null && context.mounted) {
                    setState(() {
                      image = resp;
                      _newCoverLink = Secret.baseBookly;
                      _newCoverImage = null;
                    });
                    Navigator.pop(context);
                  }
                },
                child: Row(
                  spacing: 20,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.photo_size_select_actual_outlined, size: 35),
                    Text('Elegir de la galería', style: TextStyle(fontSize: 21)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _states() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [...BookState.values.skip(1).map((s) => _stateWidget(s))],
      ),
    );
  }

  Widget _stateWidget(BookState s) {
    return GestureDetector(
      onTap: () => setState(() => state = s),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: s == state ? AppColors.read.withAlpha(100) : Colors.transparent,
        ),
        child: Text(
          s.displayName,
          style: TextStyle(fontWeight: s == state ? FontWeight.w700 : FontWeight.normal),
        ),
      ),
    );
  }

  bool get coverChanged => _newCoverImage != null || _newCoverLink != null || _searchUrl != null;

  Future<String?> _urlCover(String bookId) async {
    if (_searchUrl != null && _searchUrl!.isNotEmpty) {
      return await bookService.uploadCoverFromUrl(bookId: bookId, imageUrl: _searchUrl!);
    } else if (image != null) {
      return await bookService.uploadCover(bookId: bookId, image: image!);
    } else if (openLibrary?.cover != null && openLibrary!.cover.isNotEmpty) {
      return await bookService.uploadCoverFromUrl(bookId: bookId, imageUrl: openLibrary!.cover);
    } else if (google?.thumbnail != null && google!.thumbnail!.isNotEmpty) {
      return await bookService.uploadCoverFromUrl(bookId: bookId, imageUrl: google!.thumbnail!);
    } else if (hardcoverBook?.imageUrl != null && hardcoverBook!.imageUrl!.isNotEmpty) {
      return await bookService.uploadCoverFromUrl(
        bookId: bookId,
        imageUrl: hardcoverBook!.imageUrl!,
      );
    } else {
      return '';
    }
  }

  Future<void> _readClipboard(BuildContext context) async {
    final clipboard = await Clipboard.getData(Clipboard.kTextPlain);

    if (clipboard?.text != null && clipboard!.text!.isNotEmpty && context.mounted) {
      Clipboard.setData(ClipboardData(text: ''));
      setState(() {
        _searchUrl = clipboard.text!;
      });
      Navigator.pop(context);
    }
  }

  Future<void> _searchCover() async {
    _searchingCover = true;

    await searchBookCover(
      isbnController.text.isNotEmpty ? isbnController.text : titleController.text,
    );
  }

  Future<void> searchBookCover(String title) async {
    final uri = Uri.parse('https://www.google.com/search?tbm=isch&q=${Uri.encodeComponent(title)}');
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
