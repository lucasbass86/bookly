import 'package:bookly/theme/theme.dart';
import 'package:flutter/material.dart';

enum BookState { all, read, reading, pending }

extension BookStateEx on BookState {
  String get displayName {
    switch (this) {
      case BookState.all:
        return 'Todo';
      case BookState.read:
        return 'Leído';
      case BookState.reading:
        return 'Leyendo';
      case BookState.pending:
        return 'Pendiente';
    }
  }

  Color get color {
    switch (this) {
      case BookState.all:
        return AppColors.read;
      case BookState.read:
        return AppColors.read;
      case BookState.reading:
        return AppColors.reading;
      case BookState.pending:
        return AppColors.pending;
    }
  }

  Color get backgroundColor {
    switch (this) {
      case BookState.all:
        return AppColors.readBackground;
      case BookState.read:
        return AppColors.readBackground;
      case BookState.reading:
        return AppColors.readingBackground;
      case BookState.pending:
        return AppColors.pendingBackground;
    }
  }
}

enum BookCategory {
  all,
  novelaContemporanea,
  romance,
  fantasia,
  cienciaFiccion,
  misterio,
  thrillerYSuspense,
  terror,
  novelaHistorica,
  aventura,
  accion,
  drama,
  humorYComedia,
  poesia,
  teatro,
  cuentosYRelatos,
  literaturaClasica,
  biografiaYAutobiografia,
  memoriasYDiarios,
  desarrolloPersonal,
  psicologia,
  filosofia,
  historia,
  cienciaYDivulgacion,
  tecnologiaEInformatica,
  economiaYFinanzas,
  politicaYSociedad,
  arteYFotografia,
  cocinaYGastronomia,
  viajesYNaturaleza,
  comicsYNovelasGraficas,
  infantil,
  juvenil,
  educacionYLibrosDeTexto,
  idiomas,
  religionYEspiritualidad,
  saludYBienestar,
  deportes,
  manualidadesYBricolaje,
  guiasYManuales,
  otros,
  ceramica,
  pasatiempos,
  cozymystery,
}

extension BookCategoryEx on BookCategory {
  String get displayName {
    switch (this) {
      case BookCategory.cozymystery:
        return 'Cozy Mystery';
      case BookCategory.all:
        return 'Todos';
      case BookCategory.novelaContemporanea:
        return 'Novela contemporánea';
      case BookCategory.romance:
        return 'Romance';
      case BookCategory.fantasia:
        return 'Fantasía';
      case BookCategory.cienciaFiccion:
        return 'Ciencia ficción';
      case BookCategory.misterio:
        return 'Misterio';
      case BookCategory.thrillerYSuspense:
        return 'Thiller y suspense';
      case BookCategory.terror:
        return 'Terror';
      case BookCategory.novelaHistorica:
        return 'Novela histórica';
      case BookCategory.aventura:
        return 'Aventura';
      case BookCategory.accion:
        return 'Acción';
      case BookCategory.drama:
        return 'Drama';
      case BookCategory.humorYComedia:
        return 'Humor y comedia';
      case BookCategory.poesia:
        return 'Poesía';
      case BookCategory.teatro:
        return 'Teatro';
      case BookCategory.cuentosYRelatos:
        return 'Cuentos y relatos';
      case BookCategory.literaturaClasica:
        return 'Literatura clásica';
      case BookCategory.biografiaYAutobiografia:
        return 'Biografía y autobiografía';
      case BookCategory.memoriasYDiarios:
        return 'Memorias y diarios';
      case BookCategory.desarrolloPersonal:
        return 'Desarrollo personal';
      case BookCategory.psicologia:
        return 'Psicología';
      case BookCategory.filosofia:
        return 'Filosofía';
      case BookCategory.historia:
        return 'Historia';
      case BookCategory.cienciaYDivulgacion:
        return 'Ciencia y divulgación';
      case BookCategory.tecnologiaEInformatica:
        return 'Tecnología e informática';
      case BookCategory.economiaYFinanzas:
        return 'Economía y finanzas';
      case BookCategory.politicaYSociedad:
        return 'Política y sociedad';
      case BookCategory.arteYFotografia:
        return 'Arte y fotografía';
      case BookCategory.cocinaYGastronomia:
        return 'Cocina y gastronimía';
      case BookCategory.viajesYNaturaleza:
        return 'Viajes y naturaleza';
      case BookCategory.comicsYNovelasGraficas:
        return 'Comics y novelas gráficas';
      case BookCategory.infantil:
        return 'Infantil';
      case BookCategory.juvenil:
        return 'Juvenil';
      case BookCategory.educacionYLibrosDeTexto:
        return 'Educación y libros de texto';
      case BookCategory.idiomas:
        return 'Idiomas';
      case BookCategory.religionYEspiritualidad:
        return 'Religión y espiritualidad';
      case BookCategory.saludYBienestar:
        return 'Salud y bienestar';
      case BookCategory.deportes:
        return 'Deportes';
      case BookCategory.manualidadesYBricolaje:
        return 'Manualidades y bricolaje';
      case BookCategory.guiasYManuales:
        return 'Guías y manuales';
      case BookCategory.otros:
        return 'Otros';
      case BookCategory.ceramica:
        return 'Cerámica';
      case BookCategory.pasatiempos:
        return 'Pasatiempos';
    }
  }
}

enum BookOrder { title, author, category, publisher, publisherYear, pages }

extension BookOrderEx on BookOrder {
  String get displayName {
    switch (this) {
      case BookOrder.title:
        return 'Título';
      case BookOrder.author:
        return 'Autor';
      case BookOrder.category:
        return 'Categoría';
      case BookOrder.publisher:
        return 'Editorial';
      case BookOrder.publisherYear:
        return 'Año publicación';
      case BookOrder.pages:
        return 'Páginas';
    }
  }
}

enum BookSort { asc, desc }

extension BookSortEx on BookSort {
  String get displayName {
    switch (this) {
      case BookSort.asc:
        return 'Ascendente';
      case BookSort.desc:
        return 'Descentente';
    }
  }
}

enum Search { author, publisher }
