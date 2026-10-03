class Passenger {
   String name;
   String age;
   String gender;
   String? deckType;
   String? seatNo;

   Passenger({required this.name, required this.age,required this.gender,this.deckType,this.seatNo});

  Map<String, dynamic> toJson() => {
        "deck_type": deckType,
        "seat_no": seatNo,
        "name": name,
        "gender": gender,
        "age": age
      };

  @override
  String toString() => '''{
        "deck_type": $deckType,
        "seat_no": $seatNo,
        "name": $name,
        "gender": $gender,
        "age": $age
      }''';
}