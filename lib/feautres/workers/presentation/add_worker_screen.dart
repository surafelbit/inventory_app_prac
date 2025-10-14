import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddWorkerScreen extends ConsumerStatefulWidget {
  const AddWorkerScreen({Key? key}) : super(key: key);
  @override
  _AddWorkerScreenState createState() => _AddWorkerScreenState();
}

class _AddWorkerScreenState extends ConsumerState<AddWorkerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Managment'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // handle button press here
          showBottomSheet(
              context: context,
              backgroundColor: Colors.white,
              // isScrollControlled: true,
              builder: (BuildContext modalContext) {
                return DefaultTabController(
                    length: 3,
                    child: StatefulBuilder(builder:
                        (BuildContext context, StateSetter setModalState) {
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom:
                              MediaQuery.of(modalContext).viewInsets.bottom +
                                  10,
                          left: 20,
                          right: 20,
                          top: 15,
                        ),
                        child: Column(
                          children: [Text('Stronger')],
                        ),
                      );
                    }));
              });
        },
//         onPressed: () {
//   showModalBottomSheet(
//     context: context,
//     backgroundColor: Colors.white,
//     isScrollControlled: true, // makes it slide higher when keyboard opensld
//     shape: const RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//     ),
//     builder: (BuildContext modalContext) {
//       return Padding(
//         padding: EdgeInsets.only(
//           bottom: MediaQuery.of(modalContext).viewInsets.bottom + 10,
//           left: 20,
//           right: 20,
//           top: 15,
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min, // shrink to fit content
//           children: const [
//             Text(
//               'Add Worker Details',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 10),
//             Text('This is your modal content area.'),
//           ],
//         ),
//       );
//     },
//   );
// },

        icon: const Icon(
          Icons.person_add_alt_1, // looks better for “add worker”
          color: Colors.white,
        ),
        label: const Text(
          "Add New Worker",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue, // Blue button background
        elevation: 6, // adds nice shadow
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // softer rounded corners
        ),
      ),
    );
  }
}
