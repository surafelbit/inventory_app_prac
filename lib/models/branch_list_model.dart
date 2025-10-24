// import 'branch_model.dart';

// class BranchListModel {
//   final List<BranchModel> branches;

//   BranchListModel({required this.branches});

//   factory BranchListModel.fromJson(Map<String, dynamic> json) {
//     var list = json['branch'] as List<dynamic>? ?? [];
//     List<BranchModel> branches =
//         list.map((e) => BranchModel.fromJson(e)).toList();

//     return BranchListModel(branches: branches);
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'branches': branches.map((b) => b.toJson()).toList(),
//     };
//   }
// }
