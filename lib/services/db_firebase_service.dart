import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class DbFirebaseService {
  Future<void> writeUserNotes({
    required String noteId,
    required String type,
    required bool pinned,
    required String labelColor,
    required String versionApp,
    required List<String> tags,
    required String title,
    required String note,
    required String subtitle,
  }) async {
    final DatabaseReference ref = FirebaseDatabase.instance.ref();

    DateTime date = DateTime.now();
    User? user = FirebaseAuth.instance.currentUser;
    print(noteId);

    if (user != null && title.isNotEmpty && note.isNotEmpty) {
      String uid = user.uid;

      Map<String, dynamic> newNote = {
        "type": type,
        "pinned": pinned,
        "labelColor": labelColor,
        "customData": {
          "date": date.toString(),
          "versionApp": versionApp,
        },
        "tags": tags,
        "title": title,
        "subtitle": subtitle,
        "note": note,
      };
      DatabaseReference userNotesRef =
          ref.child("users").child(uid).child("notes");

      if (noteId.isNotEmpty) {
        print("CLEVE EN noNULL");
        userNotesRef.child(noteId).set(newNote);
      } else {
        print("CLEVE EN NULL");
        DatabaseReference newNoteRef = userNotesRef.push();

        // Obtener el id para agregar a la lista
        noteId = newNoteRef.key.toString();
        DatabaseReference notesInfoRef =
            ref.child("users").child(uid).child("notesIDs");

        try {
          DatabaseEvent snapshot = await notesInfoRef.once();
          dynamic snapshotValue = snapshot.snapshot.value;
          List<String> idList =
              (snapshotValue is List) ? List<String>.from(snapshotValue) : [];
          if (!idList.contains(noteId)) {
            idList.add(noteId);
            notesInfoRef.set(idList);
            userNotesRef.child(noteId).set(newNote);
          }
        } catch (e) {
          print(e);
        }
      }
    }
  }

  Future<Map<String, List<Map<String, dynamic>>>> readProducts() async {
    final User? user = FirebaseAuth.instance.currentUser;
    Map<String, List<Map<String, dynamic>>> categorizedProducts = {};

    try {
      final DatabaseReference ref = FirebaseDatabase.instance.ref();

      if (user != null) {
        final categoriesSnapshot = await ref.child("categories").get();

        if (categoriesSnapshot.exists && categoriesSnapshot.value != null) {
          final dynamic categoriesValue = categoriesSnapshot.value;
          if (categoriesValue is Map<dynamic, dynamic>) {
            List<String> categories =
                categoriesValue.keys.cast<String>().toList();

            for (int i = 0; i < categories.length && i < 5; i++) {
              String category = categories[i];
              final categorySnapshot =
                  await ref.child("products/$category").limitToFirst(5).get();

              if (categorySnapshot.exists && categorySnapshot.value != null) {
                final dynamic categoryProductsValue = categorySnapshot.value;
                if (categoryProductsValue is Map<dynamic, dynamic>) {
                  List<Map<String, dynamic>> products = [];
                  categoryProductsValue.forEach((key, product) {
                    products.add(Map<String, dynamic>.from(product));
                  });

                  categorizedProducts[category] = products;
                }
              }
            }
            return categorizedProducts;
          } else {
            print("No hay categorías existentes.");
          }
        }
      }
    } catch (e) {
      print("Error al leer productos: $e");
    }
    return categorizedProducts;
  }

  Future<List<Map<String, String>>> readUserNoteFront(List notesIDs) async {
    final User? user = FirebaseAuth.instance.currentUser;
    final List<Map<String, String>> dataList = [];

    await Future.wait(notesIDs.map((noteId) async {
      try {
        final DatabaseReference ref = FirebaseDatabase.instance.ref();
        //  ref.keepSynced(true);
        if (user != null) {
          String uid = user.uid;
          final DataSnapshot title =
              await ref.child("users/$uid/notes/$noteId/title").get();
          final DataSnapshot subtitle =
              await ref.child("users/$uid/notes/$noteId/subtitle").get();
          if (title.exists &&
              title.value != null &&
              subtitle.exists &&
              subtitle.value != null) {
            final dynamic value = title.value;
            final dynamic valueSub = subtitle.value;
            if (value is String && valueSub is String) {
              final String noteTitle = value.toString();
              final String noteSubtitle = valueSub.toString();
              dataList.add({"title": noteTitle, "subtitle": noteSubtitle});
            } else {
              print("Los datos no son válidos");
            }
          }
        }
      } catch (e) {
        print("error in data $e");
      }
    }));

    return dataList;
  }

  Future<Map<String, Map<String, String>>> readUserNoteFront_test(
      List notesIDs) async {
    final User? user = FirebaseAuth.instance.currentUser;
    final Map<String, Map<String, String>> dataList = {};

    await Future.wait(notesIDs.map((noteId) async {
      try {
        final DatabaseReference ref = FirebaseDatabase.instance.ref();
        if (user != null) {
          String uid = user.uid;
          final DataSnapshot title =
              await ref.child("users/$uid/notes/$noteId/title").get();
          final DataSnapshot subtitle =
              await ref.child("users/$uid/notes/$noteId/subtitle").get();
          if (title.exists &&
              title.value != null &&
              subtitle.exists &&
              subtitle.value != null) {
            final dynamic value = title.value;
            final dynamic valueSub = subtitle.value;
            if (value is String && valueSub is String) {
              final String noteTitle = value.toString();
              final String noteSubtitle = valueSub.toString();
              dataList[noteId] = {"title": noteTitle, "subtitle": noteSubtitle};
            } else {
              print("Los datos no son válidos");
            }
          }
        }
      } catch (e) {
        print("error in data");
      }
    }));

    return dataList;
  }

  Future<List<String>> readNoteId() async {
    final User? user = FirebaseAuth.instance.currentUser;
    final List<String> itemsList = [];

    try {
      final DatabaseReference ref = FirebaseDatabase.instance.ref();
      // ref.keepSynced(true);
      //final snapshot = await ref.limitToFirst(10).once();

      if (user != null) {
        String uid = user.uid;
        final data = await ref.child("users/$uid/notesIDs").get();
        if (data.exists && data.value != null) {
          dynamic snapshotValue = data.value;
          List<String> idList =
              (snapshotValue is List) ? List<String>.from(snapshotValue) : [];
          return idList;
        } else {
          return itemsList;
        }
      }
    } catch (e) {
      print("error in data $e");
    }
    return itemsList;
  }

  Future<void> deleteNote(String noteId) async {
    final User? user = FirebaseAuth.instance.currentUser;
    final List<String> noteIdsList = await readNoteId();

    if (user != null) {
      final String uid = user.uid;
      final DatabaseReference ref = FirebaseDatabase.instance.ref();

      DatabaseReference toDelete = ref.child("users/$uid");
      DatabaseReference noteToDelete = toDelete.child("notes/$noteId");
      DatabaseReference noteIdDelete = toDelete.child("notesIDs");

      try {
        noteToDelete.remove();

        noteIdsList.remove(noteId);

        noteIdDelete.set(noteIdsList);
      } catch (e) {
        print("Error deleting note: $e");
      }
    }
  }
}
