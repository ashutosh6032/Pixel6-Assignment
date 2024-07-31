import 'package:flutter/material.dart';
import 'package:pixel6_application/Models/employee_model.dart';
import 'package:pixel6_application/View/widgets/custom_dropdown.dart';
import 'package:pixel6_application/network/users_api.dart';

class EmployeeListScreen extends StatefulWidget {
  @override
  State createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  String selectedCountry = "";
  String selectedGender = "";
  List<Users> employeelist = [];
  int currentPage = 0;
  final int itemsPerPage = 20;
  bool isLoading = false;
  bool isFetching = false;
  bool isAscending = true;
  bool isSorting = true;
  late ScrollController _scrollController;
  List<String> countryList = <String>['Country', 'Usa'];
  String imgPath = "assets/Images/logo.jpeg";

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    fetchEmployees();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !isFetching) {
      fetchEmployees();
    }
  }

  void sortingOnId(int colIndex, bool asce) {
   // print(colIndex);
    //print(asce);
    setState(() {
      isAscending = asce;
      employeelist.clear();
      currentPage = 0;
      fetchEmployees();
    });
  }

  void fetchEmployees() {
    if (isFetching) return;

    setState(() {
      isFetching = true;
    });

    int skip = isAscending ? currentPage * itemsPerPage : employeelist.length;

    employeeApi(
      limit: itemsPerPage,
      skip: skip,
      country: selectedCountry,
      gender: selectedGender,
    ).then((val) {
      setState(() {
        if (isAscending) {
          employeelist.addAll(val.users!);
        } else {
          employeelist.insertAll(0, val.users!.reversed.toList());
        }
        isFetching = false;
        isLoading = false;
        currentPage++;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const [
          Icon(
            Icons.menu,
            color: Color.fromRGBO(179, 0, 30, 1),
          ),
           SizedBox(width: 15,)
        ],
        leading: Padding(
          padding: const EdgeInsets.only(left: 15,top: 5),
          child: Image.asset(
            imgPath,
            height: 15,
            width: 15,
            fit: BoxFit.cover,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
             const SizedBox(
              height: 50,
            ),
            buildHeader(),
            const SizedBox(
              height: 30,
            ),
            buildUserTable(),
            const SizedBox(height: 20),
            if (isFetching)
              const CircularProgressIndicator(
                color: Colors.black,
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget buildHeader() {
    return Row(
      children: [
        const Text(
          "Employees",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
        const Spacer(),
        const Icon(
          Icons.filter_alt,
          color: Color.fromRGBO(179, 0, 30, 1),
        ),
        const SizedBox(
          width: 5,
        ),
        CustomDropdown(
          selectedValue: selectedCountry,
          items: const [
            DropdownMenuItem(
              value: '',
              child: Text('Country'),
            ),
            DropdownMenuItem(
              value: 'United States',
              child: Text('USA'),
            ),
          ],
          onChanged: (value) {
            setState(() {
              selectedCountry = value!;
              currentPage = 0;
              employeelist.clear();
              fetchEmployees();
            });
          },
        ),
        const SizedBox(
          width: 10,
        ),
        CustomDropdown(
          selectedValue: selectedGender,
          items: const [
            DropdownMenuItem(value: '', child: Text('Gender')),
            DropdownMenuItem(value: 'male', child: Text('Male')),
            DropdownMenuItem(value: 'female', child: Text('Female')),
          ],
          onChanged: (value) {
            setState(() {
              selectedGender = value!;
              currentPage = 0;
              employeelist.clear();
              fetchEmployees();
            });
          },
        )
      ],
    );
  }

  Widget buildUserTable() {
    return Expanded(
      child: SingleChildScrollView(
        controller: _scrollController,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color:
                      const Color.fromRGBO(130, 130, 130, 0.5), // Border color
                  width: 1.0, // Border width
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: DataTable(
                sortColumnIndex: 0,
                sortAscending: isAscending,
                horizontalMargin: 20,
                columnSpacing: (MediaQuery.of(context).size.width / 5.3) * 0.5,
                columns: [
                  DataColumn(
                    label: GestureDetector(
                      onTap: () {
                        sortingOnId(0, isSorting = !isSorting);
                      },
                      child: Row(
                        children: [
                          const Text("ID"),
                          const SizedBox(
                            width: 3,
                          ),
                          Icon(
                            Icons.arrow_upward,
                            size: 15,
                            color: isAscending
                                ? Colors.black
                                : const Color.fromRGBO(179, 0, 30, 1),
                          ),
                          Icon(
                            Icons.arrow_downward,
                            size: 15,
                            color: isAscending
                                ?const Color.fromRGBO(179, 0, 30, 1)
                                : Colors.black,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const DataColumn(label: Text('Image')),
                  const DataColumn(label: Text('Full Name')),
                  const DataColumn(label: Text('Demography')),
                  const DataColumn(label: Text('Designation')),
                  const DataColumn(label: Text('Location')),
                ],
                rows: employeelist.map((user) {
                      return DataRow(
                        cells: [
                          DataCell(Text(user.id.toString())),
                          DataCell(Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      "${user.image}",
                                    ),
                                    fit: BoxFit.cover,
                                  )),
                              child: Image.network(
                                "${user.image}",
                                fit: BoxFit.cover,
                              ))),
                          DataCell(Text("${user.firstName} ${user.lastName}")),
                          DataCell((user.gender=="male")?Text("M/${user.age}"):Text("F/${user.age}")),
                          DataCell(Text(user.company!.title!)),
                          DataCell(Text(
                              "${user.address!.state}, ${user.address!.country}"))
                        ],
                      );
                    }).toList() +
                    (isLoading
                        ? const [
                            DataRow(
                              cells: [
                                DataCell(
                                  Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ]
                        : []),
              )),
        ),
      ),
    );
  }
}

