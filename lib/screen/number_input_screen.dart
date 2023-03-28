import 'package:county_code/model/country_information.dart';
import 'package:county_code/bloc/number_input_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../bottom_sheet/my_bottom_sheet.dart';

class NumberInputScreen extends StatelessWidget {
  const NumberInputScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider<NumberInputBloc>(
      dispose: (context, bloc) => bloc.dispose(),
      create: (context) => NumberInputBloc(),
      builder: (context, _) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: const Color(0xFF8EAAFB),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 80, left: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Get Started',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
                StreamBuilder<CountryInformation>(
                  stream: context.read<NumberInputBloc>().takeCountryStream,
                  builder: (context, snapshot) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              final bloc = context.read<NumberInputBloc>();
                              showModalBottomSheet(
                                  backgroundColor: Colors.transparent,
                                  context: context,
                                  builder: (context) {
                                    return MyBottomSheet(
                                      text: bloc.inputTextController,
                                      countrySink: bloc.takeCountrySink,
                                      dataStream: bloc.countriesStream,
                                    );
                                  },
                                  isScrollControlled: true);
                            },
                            child: Container(
                              constraints: const BoxConstraints(minWidth: 90),
                              height: 55,
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
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      snapshot.hasData
                                          ? snapshot.data!.shortNumber
                                          : '+1201',
                                      style: const TextStyle(
                                          color: Color(0xFF594C74),
                                          fontSize: 15),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Container(
                              height: 55,
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                color: Color(0xFFB7C8FD),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, top: 3),
                                child: TextField(
                                  style: const TextStyle(
                                    color: Color(0xFF594C74),
                                  ),
                                  controller: context
                                      .read<NumberInputBloc>()
                                      .numberController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: '(123)123-1234',
                                    hintStyle: TextStyle(
                                      color: const Color(0xFF594C74)
                                          .withOpacity(0.7),
                                    ),
                                  ),
                                  autofocus: true,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 30),
                    child: SizedBox(
                      width: 55,
                      height: 50,
                      child: StreamBuilder<bool>(
                        initialData: true,
                        stream: context.read<NumberInputBloc>().textStream,
                        builder: (context, snapshot) {
                          return ElevatedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                ),
                              ),
                              backgroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.pressed)) {
                                    return Colors.white;
                                  } else if (states
                                      .contains(MaterialState.disabled)) {
                                    return Colors.white24.withOpacity(0.3);
                                  }
                                  return Colors.white;
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
                                  return Colors.black;
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
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
