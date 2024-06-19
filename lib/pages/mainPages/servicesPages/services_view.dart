import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/services_bloc/services_event.dart';
import '../../../bloc/services_bloc/services_bloc.dart';
import '../../../bloc/services_bloc/services_state.dart';

Color backGroundColor = Color(0xFFFAFDFF);
Color buttonColor = Colors.green;

class ServicesView extends StatelessWidget {
  const ServicesView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ServicesBloc()..add(LoadServices()),
      child: ServicesPage(),
    );
  }
}

class ServicesPage extends StatefulWidget {
  @override
  _ServicesPageState createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backGroundColor,
        toolbarHeight: 100,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo.png',
              fit: BoxFit.contain,
              height: 60,
            ),
            SizedBox(height: 4),
            Text(
              "Сервисы",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
        centerTitle: true,
      ),
      backgroundColor: backGroundColor,
      body: BlocBuilder<ServicesBloc, ServicesState>(
        builder: (context, state) {
          if (state is ServicesLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.green,
              ),
            );
          } else if (state is ServicesLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<ServicesBloc>().add(LoadServices());
              },
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  _buildServiceItem(
                    context,
                    icon: Icons.local_laundry_service,
                    service: 'Cтирка и химчистка',
                    price: '1.00 RUB',
                    onTap: () => _showAdditionalServicesDialog(context),
                  ),
                  SizedBox(height: 8),
                  _buildServiceItem(
                    context,
                    icon: Icons.lock,
                    service: 'Пользование камерой хранения или сейфом',
                    price: '1.00 RUB',
                  ),
                  SizedBox(height: 8),
                  _buildServiceItem(
                    context,
                    icon: Icons.grass,
                    service: 'Стрижка газона',
                    price: '10.00 USD',
                  ),
                  SizedBox(height: 8),
                  _buildServiceItem(
                    context,
                    icon: Icons.delete,
                    service: 'Убрать мусор в тумбочке',
                    price: '10.00 USD',
                    onTap: () => _showAdditionalServicesTrashDialog(context),
                  ),
                ],
              ),
            );
          } else {
            return Center(child: Text(""));
          }
        },
      ),
    );
  }

  Widget _buildServiceItem(
      BuildContext context, {
        required IconData icon,
        required String service,
        required String price,
        Function()? onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  service,
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Icon(icon, size: 30),
                  ),
                  Text(
                    price,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAdditionalServicesDialog(BuildContext parentContext) {
    showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        String? selectedItem;
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            width: 400,
            height: 220,
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                    child: Text('Дополнительные услуги',
                        style: TextStyle(fontSize: 16))),
                SizedBox(height: 16),
                Text('Название продукта'),
                SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      isExpanded: true,
                      value: selectedItem,
                      hint: Text("Выбрать"),
                      iconEnabledColor: buttonColor,
                      items: ['Рубашка', 'Джинсы', 'Футболка', 'Носки']
                          .map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedItem = newValue;
                        });
                        BlocProvider.of<ServicesBloc>(parentContext).add(SelectAdditionalService(newValue!));
                      },
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding:
                        EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                      ),
                      child: Text('Готово'),
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

  void _showAdditionalServicesTrashDialog(BuildContext parentContext) {
    showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        int serviceCount = 0;

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            width: 400,
            height: 420,
            padding: EdgeInsets.all(16),
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                String? selectedItem;
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                        child: Text('Дополнительные услуги',
                            style: TextStyle(fontSize: 16))),
                    SizedBox(height: 8),
                    Text('Услуга'),
                    SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: TextField(
                        onChanged: (email) => null,
                        decoration: InputDecoration(
                          hintText: 'Выберите',
                          hintStyle:
                          TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 20.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Text('Услуга'),
                        Spacer(),
                        Container(
                          child: Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove_circle_outline),
                                onPressed: () {
                                  setState(() {
                                    if (serviceCount > 0) {
                                      serviceCount--;
                                    }
                                  });
                                },
                              ),
                              Text(serviceCount.toString()),
                              IconButton(
                                icon: Icon(Icons.add_circle_outline),
                                onPressed: () {
                                  setState(() {
                                    serviceCount++;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text('Название продукта'),
                    SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          isExpanded: true,
                          value: selectedItem,
                          hint: Text("Выбрать"),
                          iconEnabledColor: buttonColor,
                          items: ['Рубашка', 'Джинсы', 'Футболка', 'Носки'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              selectedItem = newValue;
                            });
                            BlocProvider.of<ServicesBloc>(parentContext).add(SelectAdditionalService(newValue!));
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Center(
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: buttonColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 12, horizontal: 24),
                          ),
                          child: Text('Готово'),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}