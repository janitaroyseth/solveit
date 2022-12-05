import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project/models/message.dart';

void main() {
  group("from map", () {
    test("null data", () {
      final message = Message.fromMap(null);
      expect(message, null);
    });

    test(
      "missing data",
      () {
        String messageId = "some id";
        String otherId = "some other id";
        String author = "an author";
        Timestamp date = Timestamp.fromDate(DateTime.now());

        final message = Message.fromMap({
          "messageId": messageId,
          "otherId": otherId,
          "author": author,
          "date": date,
        });

        expect(message, null);
      },
    );

    test("image message valid data", () {
      String messageId = "some id";
      String otherId = "some other id";
      String author = "an author";
      Timestamp date = Timestamp.fromDate(DateTime.now());
      String imageUrl = "https://someurl/withanimage";

      final message = Message.fromMap({
        "messageId": messageId,
        "otherId": otherId,
        "author": author,
        "date": date,
        "imageUrl": imageUrl,
      }) as ImageMessage;

      expect(message, isNot(null));
      expect(
        message,
        ImageMessage(
          messageId: messageId,
          otherId: otherId,
          author: author,
          imageUrl: imageUrl,
        ),
      );
    });
  });

  group(
    "to map",
    () {
      test("image message", () {
        String messageId = "some id";
        String otherId = "some other id";
        String author = "an author";
        Timestamp date = Timestamp.fromDate(DateTime.now());
        String imageUrl = "https://someurl/withanimage";

        final message = Message.toMap(ImageMessage(
          messageId: messageId,
          otherId: otherId,
          author: author,
          date: date.toDate(),
          imageUrl: imageUrl,
        ));

        expect(message, isNot(null));
        expect(message, {
          "messageId": messageId,
          "otherId": otherId,
          "author": author,
          "date": date.toDate(),
          "imageUrl": imageUrl,
        });
      });
    },
  );
}
