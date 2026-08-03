import '../models/staff_document_model.dart';


class StaffDocumentData {

  static List<StaffDocumentModel> documentList = [];


  static void addDocument(
    StaffDocumentModel document,
  ) {

    documentList.add(document);

  }


  static void clearDocuments() {

    documentList.clear();

  }

}