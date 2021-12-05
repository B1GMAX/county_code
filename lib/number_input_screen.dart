import 'package:county_code/country_information.dart';
import 'package:county_code/number_input_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class NumberInputScreen extends StatelessWidget {
  const NumberInputScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider<NumberInputBloc>(
      dispose: (context,bloc)=>bloc.dispose(),
      create: (context) => NumberInputBloc(),
      builder: (context, _) {
        return Scaffold(
          backgroundColor: const Color(0xFF8EAAFB),
          body: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 80, right: 200),
                child: Text(
                  'Get Started',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w800),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 300),
                child: StreamBuilder<CountryInformation>(
                    stream: context.read<NumberInputBloc>().takeCountryStream,
                    builder: (context, snapshot) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              final bloc = context.read<NumberInputBloc>();
                              _showDialog(
                                  bloc.countriesStream,
                                  context,
                                  bloc.inputTextController,
                                  bloc.takeCountrySink);
                            },
                            child: Container(
                                height: 50,
                                width: !snapshot.hasData
                                    ? 82
                                    : snapshot.data!.shortNumber.length > 5
                                        ? 107
                                        : 82,
                                decoration: const BoxDecoration(
                                    color: Color(0xFFB7C8FD),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.network(
                                        !snapshot.hasData
                                            ? 'https://flagcdn.com/w320/us.png'
                                            : snapshot.data!.countryFlag,
                                        height: 20,
                                        width: 30,
                                      ),
                                      Text(
                                          !snapshot.hasData
                                              ? '+1201'
                                              : snapshot.data!.shortNumber,
                                          style: const TextStyle(
                                              color: Color(0xFF594C74)))
                                    ],
                                  ),
                                )),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                            width: 250,
                            height: 50,
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              color: Color(0xFFB7C8FD),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: TextField(
                                style:
                                    const TextStyle(color: Color(0xFF594C74)),
                                controller: context
                                    .read<NumberInputBloc>()
                                    .numberController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: '(123)123-1234',
                                    hintStyle: TextStyle(
                                        color: const Color(0xFF594C74)
                                            .withOpacity(0.7))),
                              ),
                            ),
                          )
                        ],
                      );
                    }),
              ),
              StreamBuilder<bool>(
                  initialData: true,
                  stream: context.read<NumberInputBloc>().textStream,
                  builder: (context, snapshot) {
                    return Padding(
                      padding: const EdgeInsets.only(
                        top: 90,
                        left: 270,
                      ),
                      child: SizedBox(
                        width: 55,
                        height: 50,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            )),
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.pressed)) {
                                  return Colors.white;
                                } else if (states
                                    .contains(MaterialState.disabled)) {
                                  return Colors.white24.withOpacity(0.3);
                                }
                                return Colors
                                    .white; // Use the component's default.
                              },
                            ),
                            foregroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.pressed)) {
                                  return Colors.black;
                                } else if (states
                                    .contains(MaterialState.disabled)) {
                                  return Colors.black.withOpacity(0.3);
                                }
                                return Colors
                                    .black; // Use the component's default.
                              },
                            ),
                          ),
                          onPressed: snapshot.data!
                              ? null
                              : () {
                                  print('the button was pressed');
                                },
                          child: const Icon(
                            Icons.arrow_forward,
                            size: 28,
                          ),
                        ),
                      ),
                    );
                  }),
            ],
          ),
        );
      },
    );
  }

  void _showDialog(
          Stream<List<CountryInformation>> dataStream,
          BuildContext context,
          TextEditingController? text,
          Sink countrySink) =>
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return StreamBuilder<List<CountryInformation>>(
                initialData: const [],
                stream: dataStream,
                builder: (context, snapshot) {
                  return Container(
                    color: const Color(0xFF8EAAFB),
                    height: 600,
                    width: double.infinity,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Padding(
                              padding:
                                  EdgeInsets.symmetric(vertical: 15),
                              child: Text(
                                'Country code',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w800),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 7, bottom: 10, left: 150),
                              child: GestureDetector(
                                onTap:
                                  Navigator.of(context).pop,

                                child: Container(
                                  height: 22,
                                  width: 22,
                                  child: const Icon(
                                    Icons.close,
                                    size: 15,
                                  ),
                                  decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
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
                            width: 370,
                            decoration: const BoxDecoration(
                                color: Color(0xFFB7C8FD),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
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
                                    Navigator.of(context).pop();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, bottom: 10),
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
                                          style: const TextStyle(
                                              color: Color(0xFF594C74)),
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Text(
                                          snapshot.data![index].countryName,
                                          style: const TextStyle(
                                              color: Colors.white),
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
                });
          },
          isScrollControlled: true);
}
