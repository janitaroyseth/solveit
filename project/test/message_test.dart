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

    test("text message valid data", () {
      String messageId = "some id";
      String otherId = "some other id";
      String author = "an author";
      Timestamp date = Timestamp.fromDate(DateTime.now());
      String text = "some text conent";

      final message = Message.fromMap({
        "messageId": messageId,
        "otherId": otherId,
        "author": author,
        "date": date,
        "text": text,
      }) as TextMessage;

      expect(message, isNot(null));
      expect(
        message,
        TextMessage(
          messageId: messageId,
          otherId: otherId,
          author: author,
          text: text,
        ),
      );
    });

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

    test(
      "from maps",
      () {
        final List<Map<String, dynamic>> maps = [
          {
            "messageId": "image message id",
            "otherId": "image other id",
            "author": "author of image",
            "date": Timestamp.fromDate(DateTime.now()),
            "imageUrl": "https://urlofanimage/image",
          },
          {
            "messageId": "text message id",
            "otherId": "text other id",
            "author": "author of text",
            "date": Timestamp.fromDate(DateTime.now()),
            "text": "some text",
          }
        ];

        final messages = Message.fromMaps(maps);

        expect(messages, isNot(null));
        expect(messages.length, 2);
        assert(messages[0] is ImageMessage);
        assert(messages[1] is TextMessage);
      },
    );
  });

  group(
    "to map",
    () {
      test("text message", () {
        String messageId = "some id";
        String otherId = "some other id";
        String author = "an author";
        Timestamp date = Timestamp.fromDate(DateTime.now());
        String text = "some text content";
        final message = Message.toMap(TextMessage(
          messageId: messageId,
          otherId: otherId,
          author: author,
          date: date.toDate(),
          text: text,
        ));

        expect(message, isNot(null));
        expect(message, {
          "messageId": messageId,
          "otherId": otherId,
          "author": author,
          "date": date.toDate(),
          "text": text,
        });
      });

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
