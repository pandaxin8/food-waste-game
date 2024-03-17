import 'package:food_waste_game/models/dish.dart';
import 'package:food_waste_game/models/guest.dart';
import 'package:food_waste_game/models/objective.dart';




class ObjectiveCheck {
  bool serveQuoWithZeroWaste(Objective objective, Map<String, dynamic> criteria, Guest guest, bool wasteGenerated) {
  if (guest.name == "Quo" && guest.isSatisfied && !wasteGenerated) {
    objective.complete();
    return true; // Indicates the objective is completed.
  }
  return false; // Objective not completed.
}


  bool serveDanTwoDishes(Objective objective, Map<String, dynamic> criteria, List<Dish> dishesServedToDan, Guest dan) {
  // Ensure you're using `maxCalories` as defined in your Guest class
  int totalCalories = dishesServedToDan.fold(0, (sum, dish) => sum + dish.calculateTotalCalories());

  // Check if Dan has been served exactly two dishes and the total calorie count is within his limit
  if (dishesServedToDan.length == 2 && totalCalories <= dan.maxCalories && dan.name == "Dan") {
    objective.complete();
    return true; // Objective is completed.
  }
  return false; // Objective is not completed.
}



  // Dynamically call the check function based on the objective's checkFunctionName
//   void checkObjective(Objective objective) {
//     var functions = {
//       'serveQuoWithZeroWaste': serveQuoWithZeroWaste,
//       'serveDanTwoDishes': serveDanTwoDishes,
//       // Add more functions as needed
//     };

//     var checkFunction = functions[objective.checkFunctionName];
//     if (checkFunction != null) {
//       checkFunction(objective, objective.criteria);
//       // Update objective completion status based on the check
//     }
//   }
}