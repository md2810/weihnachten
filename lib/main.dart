import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weihnachten Geschenke',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: GiftPickerHomePage(),
    );
  }
}

class Person {
  String name;
  int giftCount;

  Person({required this.name, required this.giftCount});
}

class GiftPickerHomePage extends StatefulWidget {
  @override
  _GiftPickerHomePageState createState() => _GiftPickerHomePageState();
}

class _GiftPickerHomePageState extends State<GiftPickerHomePage> {
  List<Person> people = [];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _giftCountController = TextEditingController();

  void _addPerson() {
    String name = _nameController.text;
    int giftCount = int.tryParse(_giftCountController.text) ?? 0;

    if (name.isNotEmpty && giftCount > 0) {
      setState(() {
        people.add(Person(name: name, giftCount: giftCount));
      });
      _nameController.clear();
      _giftCountController.clear();
      Navigator.of(context).pop(); // Schließt den Dialog
    }
  }

  void _incrementGiftCount(Person person) {
    setState(() {
      person.giftCount++;
    });
  }

  void _decrementGiftCount(Person person) {
    setState(() {
      if (person.giftCount > 0) {
        person.giftCount--;
      }
    });
  }

  void _removePerson(Person person) {
    setState(() {
      people.remove(person);
    });
  }

  Person _pickRandomPerson() {
    int totalGifts = people.fold(0, (sum, person) => sum + person.giftCount);
    int randomIndex = Random().nextInt(totalGifts);

    int cumulativeGifts = 0;
    for (var person in people) {
      cumulativeGifts += person.giftCount;
      if (randomIndex < cumulativeGifts) {
        return person;
      }
    }
    return people.first; // Fallback
  }

  // Dialog zum Hinzufügen einer neuen Person
  void _showAddPersonDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Person hinzufügen'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name der Person',
                  icon: Icon(Icons.person),
                ),
              ),
              TextField(
                controller: _giftCountController,
                keyboardType: TextInputType.number, // Nur Zahlen
                decoration: InputDecoration(
                  labelText: 'Anzahl Geschenke',
                  icon: Icon(Icons.card_giftcard),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dialog schließen ohne hinzuzufügen
              },
              child: Text('Abbrechen'),
            ),
            OutlinedButton(
              onPressed: _addPerson,
              child: Text('Hinzufügen'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Geschenk Picker'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _showAddPersonDialog, // Zeigt den Dialog an
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: people.length,
                itemBuilder: (context, index) {
                  return OutlinedButton(
                    onPressed: () {}, // Optional: Füge eine Funktion hinzu, falls gewünscht
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.all(8)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Name der Person
                          Expanded(
                            flex: 2,
                            child: Text(
                              people[index].name,
                              style: Theme.of(context).textTheme.titleLarge, // titleLarge
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                          // Minus-Button
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () => _decrementGiftCount(people[index]),
                          ),

                          // Anzahl der Geschenke
                          Text(
                            '${people[index].giftCount}', // Zeigt die Anzahl der Geschenke
                            style: Theme.of(context).textTheme.bodyLarge, // bodyLarge
                          ),

                          // Plus-Button
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () => _incrementGiftCount(people[index]),
                          ),

                          // Entfernen-Button
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => _removePerson(people[index]),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    floatingActionButton: FloatingActionButton(
    onPressed: () {
    if (people.isNotEmpty) {
    Person selectedPerson = _pickRandomPerson();
    Navigator.push(
    context,
    MaterialPageRoute(
    builder: (context) => GiftPickerResultPage(
    person: selectedPerson,
    onGiftDecrement: () {
    setState(() {
    selectedPerson.giftCount--;
    });
    },
    ),
    ),
    );
    }
    },
    backgroundColor: Theme.of(context).colorScheme.primary, // FAB Hintergrundfarbe
    child: Icon(
    Icons.card_giftcard,
    color: Colors.white, // Setzt die Farbe des Icons auf weiß (oder jede andere Farbe)
    ),
    ),
    );
  }
}

class GiftPickerResultPage extends StatelessWidget {
  final Person person;
  final VoidCallback onGiftDecrement;

  GiftPickerResultPage({required this.person, required this.onGiftDecrement});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ausgewählte Person'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${person.name}',
              style: Theme.of(context).textTheme.displayLarge,
            ),
          ],
        ),
      ),
    );
  }
}
