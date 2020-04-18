import 'package:flutter/widgets.dart';

class CardData {
  String title;
  String cover;

  CardData({this.title, this.cover});
}

class CardDataList {
  List<CardData> data;
  CardDataList({@required this.data});
}

CardDataList cardList = CardDataList(data: [
  CardData(
    title: "Lorem ipsum, or lipsum as it is sometimes known",
    cover: 'assets/images/help.png',
  ),
  CardData(
    title: "Lorem ipsum, or lipsum as it is sometimes known",
    cover: 'assets/images/help.png',
  ),
  CardData(
    title: "Lorem ipsum, or lipsum as it is sometimes known",
    cover: 'assets/images/help.png',
  ),
  CardData(
    title: "Lorem ipsum, or lipsum as it is sometimes known",
    cover: 'assets/images/help.png',
  ),
]);
