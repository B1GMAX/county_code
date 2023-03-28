import 'package:flutter/material.dart';

import '../model/country_information.dart';

class MyBottomSheet extends StatelessWidget {
  final Stream<List<CountryInformation>> dataStream;
  final TextEditingController? text;
  final Sink countrySink;

  const MyBottomSheet({
    required this.text,
    required this.countrySink,
    required this.dataStream,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return StreamBuilder<List<CountryInformation>>(
      initialData: const [],
      stream: dataStream,
      builder: (context, snapshot) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFF8EAAFB),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(25),
              topLeft: Radius.circular(25),
            ),
          ),
          height: size.height * 0.9,
          width: double.infinity,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                    child: Text(
                      'Country code',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w800),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 7, bottom: 10, right: 20),
                    child: GestureDetector(
                      onTap: Navigator.of(context).pop,
                      child: Container(
                        height: 22,
                        width: 22,
                        child: const Icon(
                          Icons.close,
                          size: 15,
                        ),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          color: Color(0xFFB7C8FD),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Center(
                child: Container(
                  height: 50,
                  width: size.height * 0.9,
                  decoration: const BoxDecoration(
                      color: Color(0xFFB7C8FD),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: TextField(
                    controller: text,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return Center(
                      child: GestureDetector(
                        onTap: () {
                          countrySink.add(snapshot.data![index]);
                          text?.clear();
                          Navigator.of(context).pop();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 20,
                              ),
                              Image.network(
                                snapshot.data![index].countryFlag,
                                height: 20,
                                width: 30,
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Text(
                                snapshot.data![index].shortNumber,
                                style:
                                    const TextStyle(color: Color(0xFF594C74)),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Flexible(
                                child: Text(
                                  snapshot.data![index].countryName,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
