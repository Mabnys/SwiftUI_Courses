import UIKit

// Introduction

var greeting = "Hello, playground"

let goodByeMessage = "See you soon!"

// The code below prints out a goodbye message

/* This is a comment
 spread out over a few lines
 also, a haiku!*/

 print(goodByeMessage)

// Booleans & Comparison Operators
/*
 Booleans in Swift are used to represent true or false values,
 making them suitable for conditions and logic.
 */

//let yes: Bool = true
let yes = true

//let no: Bool = false
let no = false

// You can also declare a boolean using "Expression" (it's a unit of code that resolves to a value)

/* for example:
 if difference == 0 {
 ...
 }
 The part that says "difference == 0" is the expression, .
 In this case the expression resolve to:
 true or false.
 Now the result of this expression is a temporary boolean value. */

let passingGrade = 50

//let studentGrade = 74
let studentGrade = 50

//let studentPassed = studentGrade > passingGrade
let studentPassed = studentGrade >= passingGrade

let studentFailed = studentGrade < passingGrade

let chrisGrade = 49
let samGrade = 99

// = is used to assigned values
// == is the equality operator

samGrade == chrisGrade
samGrade != chrisGrade

let catName = "Ozma"
let dogName = "Mango"
catName == dogName
catName > dogName /* It is "true" because catName comes first then dogName.
                   Ask this question: Does this string comnes before or after another string 
                   Ozma comes after Mango alphabetically speaking,
                   so this statement is true 
                   Note that with strings, "<" really means comes ealier in the dictionary. */

// Comparison operators are used troughtout a programer career, thus, it is great idea to understand them really well.

// Challenge - Booleans & Comparison Operators

/* Challenge 1- Create a constant named myAge and set its value to your age.
 Then, create a constant named isVotingAge that uses Boolean logic to determine if the value stored in myAge denotes someone of voting age.
 In my part of the world, the voting age is 18, so I'll use that here. */

print("Solution 1")
// Solution 1:
let myAge = 29
let isVotingAge = myAge >= 18

/* Challenge 2- Create a constant named student and set its value to your name as a string.
 Next, create a constant named author and set its value to "Matt Galloway", the original author of these exercices.
 Then, create a third constant named authorIsStudent that uses string equality to determine if the values of student and author are equal. */

print("Solution 2")
// Solution 2:
let student = "Mamadou Balde"
let author = "Matt Galloway"
let authorIsStudent = student == author


/* Challenge 3- Create a constant named studentBeforeAuthor which uses string comparison to determine if the string value in the constant student comes, alphabeltically speaking, before the string value in the constant author.
 The constants student and an author were declared above in Challenge 2, so you don't need to redeclare them here. */

// Solution 3:
let studentBeforeAuthor = student < author // This is the solution
// let studentBeforeAuthor = student > author // We could also use ">"


// Logical Operators: !, ??, ||
/*
 Logical operators let you check if at least one boolean value in the whole set is true,
 if all boolean values in a set are true,
 or even the check if a boolean value is not true.
 Logical operators only work for booleans. */

let passingGrades = 50
let studentGrades = 50
let chrisGrades = 49
let samGrades = 99

let studentsPassed = studentGrades >= passingGrades
let chrisPassed = chrisGrades >= passingGrades
let samPassed = samGrades >= passingGrades

// Not operator "!"
!samPassed
!chrisPassed // is the same as writing this expression "chrisPassed == false"

let catNames = "Ozma"
// !catNames // Error here "Cannot convert value of type 'String' to expected argument type 'Bool'" because Logical operators only work for booleans.

// AND operator: "&&"
/*
 The "&&" operator represents the logical AND operator in Swift,
 requiring both conditions to be true for the result to be true.
 */

let bothPassed = chrisPassed && samPassed

// OR operator: "||"
let eitherPassed = chrisPassed || samPassed
let anyonePassed = chrisPassed || samPassed || studentsPassed
let everyonePassed = chrisPassed && samPassed && studentsPassed

let meritAwardGrade = 90
let samHasPerfectAttendance = true
let samIsMeritStudent = samHasPerfectAttendance && samGrades > meritAwardGrade

let chrisHasPerfectAttendance = true
let chrisIsMeritStudent = chrisHasPerfectAttendance && chrisGrades > meritAwardGrade

if chrisIsMeritStudent {
  print("Congratulations!")
}
else {
  print("Keep studying.")
}

var betterStudent: String
if samGrades > chrisGrades {
  betterStudent = "Sam"
}
else {
  betterStudent = "Chris"
}

// Ternary conditional operator: expression ? true-value : false-value

betterStudent = samGrades > chrisGrades ? "Sam" : "Chris"

// Challenge: Logical Operators

/* Challenge 1- You've been provided with a constant named myAge below that's already been assigned a value.
 Feel free to change the value of this constant to match your actual age.
 Use that constant to create an if-else statement to print out "Teenager" if the value of myAge is greater or than 13 but less than or equal to 19, and to print out "Not a teenager" if the value is outside that range. */

print("Solution 1")
// Solution 1:
let myAges = 29
if myAges >= 13 && myAges <= 19 {
  print("Teenager")
} else {
  print("Not a teenager")
}

/* Challenge 2- Create a constant named teenagerName, and use a ternary conditional operator to set the value of teenagerName to your own name as a string if the value of myAge, declared above, is greater than or equal to 13, but less than or equal to 19, and to set the value of teenagerName to "Not me!" if the value is outside that range.
 Then print out the value of teenagerName. */

print("Solution 2")
// Solution 2:
let teenagerNames = myAges >= 13 && myAges <= 19 ? "Chris" : "Not me!"
print(teenagerNames)

// Optionals: "?"
/*
 Optionals in Swift let us represent either a value,
 or the absence of a value, which is called "nil".
 Optionals all have a type.
 Other words, In swift, an optional represents a value that may or may not be present,
 allowing for the handling of potentially absent values.
 */

var petName: String?
petName = "Mango"
print(petName)
petName = nil

//Unwrapping Optionals: we want to get to the actual real value inside the variable and see if we can work with it.
var result: Int? = 30 // Note that we can NOT use type inference to shorten up our code when we create optionals.
print(result)
//print(result + 1) // Error: "Value of optional type 'Int?' must be unwrapped to a value of type 'Int'. Solution: use "force unwrapping""

// force unwrapping "!"
/*
 Force unwrapping is the easiest to unwrap an optional and the most dangerous
 if we don't pass in a value, let's say petName = nil, we will get a fatal error that would crash our app.
 Therefore, we should only use force unwrapping when we absolutely know an optional has a value.
 */
petName = "Mango"
var petAge: Int? = 2
var unwrappedPetName = petName!
print("The pet's name is \(unwrappedPetName)")

// There are other ways to safely unwrap optionals. The first one we will share is "optional binding".
//1- Optional Binding:
/*
 Optional binding looks very similar to "if else" statement.
 When we use optional binding, it's very common to name the constant as the same as the optional we're unwrapping.
 With optional binding, we can unwrap multiple things at the same time, one right after the other, let's say petName and petAge.
 */

// The constant petName only exists within this (if else) block of code. It won't conflict with a variable called "petName".
if let petName = petName, /* This line equals to this: if petName != nil { let unwrappedPetName = petName }
                           if this optional is not nil, which means it has a value, store the value in this new constant. We're binding the value to the constant. And this technique is called "shadowing". */
    let petAge = petAge {
    print("The pet is \(petName) and they are \(petAge)")
} else {
  print("No pet name or age")
}

//2- Nil Coaleasing:"??"
/*
 
 */
var optionalInt: Int? = nil //10
var requiredResult = optionalInt ?? 0

// Challenge: Optionals

/* Challenge 1-
 You've been provided with a constant below, hasAllergies, which has been set to true.
 Below that, declare an Optional String variable named dogNames.
 On the next line, use a ternary conditional operator to set the value of dogName to nil if hasAllergies is true, and to "Mango" otherwise.
 */

print("Solution 1")
// Solution 1:
let hasAllergies = true
let dogNames: String?
dogNames = hasAllergies ? nil : "Mango"

/* Challenge 2-
 Create a constant called parsedInt and set it to Int("10"). Swift will attempt to parse the string 10 and convert it to an Int.
 Place your mouse over the constant name and use Option-Click to check the of parsedInt.
 Why is parsedInt an optional here?
 */

print("Solution 2")
// Solution 2:
let parsedInt = Int("10") /* parseInt is an optional. Swift implicitly creates parseInt as an optional, just in case it can't convert what's
                           inside the string. Here Swift will convert the string "10" to an Int and it set the value to 10.
                           */

/* Challenge 3-
 Create another constant named newParsedInt and set it equal to Int("cat")
 What will the value of 'newParsedInt' be? Why?*/

print("Solution 3")
// Solution 3:
let newParseInt = Int("cat") // newParseInt is implicitly created as optional. Here, Swift can't convert cat to an integer and it sets the value to nil.


// Beginning Collections
// - Tuples
/*
 Tuples in Swift are primarily used to group related data together into a single unit,
 making it convenient to work with multiple values as a whole.
 */
//                 0       1
let studentMark: (String, Int) = ("Chris", 49)
studentMark.0
studentMark.1
let studentData = (name: "Chris", mark: 49, petName: "Mango")
studentData.name
studentData.mark
studentData.petName
let (name, mark, pet) = studentData
name
mark
pet

// - Challenge: Tuples

// Challenge 1-
/*
 Declare a constant tuple named specialDate that contains three Int values followed by a String. Use this to represent a date (month, day, year) followed by a word you might associate with that day.
 */

print("Solution 1")
// Solution 1:
let specialDate = (6, 3, 2019, "WWDC")

// Challenge 2-
/*
 Create another tuple, but this time name the constituent components.
 Give them names related to the data that they contain: month, day, year and description.
 */

print("Solution 2")
// Solution 2:
let namedSpecialDate = (month: 6, day: 3, year: 2019, name: "WWDC") // Note that this tuple has exactly the same data as challenge 1's data, but in this format, it's much easier to reference.

// Challenge 3-
/*
 In on line, read the day and description values into two constants.
 You'll need to use the underscore to ignore the month and year.
 */

print("Solution 3")
// Solution 3:
let (_, keynoteDay, _, keynoteDescription) = namedSpecialDate

// Challenge 4-
/*
 Up until now, you've only seen constant tuples. But you can create variable tuples, too.
 Create one more tuple, like in the exercices above, but this time use var instead of let.
 Now change the day to a new value.
 */

print("Solution 4")
// Solution 4:
var iPhoneDay = (month: 9, day: 10, year: 2019, name: "iPhone Day")
iPhoneDay.name = "Time to buy a new iPhone"

// - Arrays
/*
 An array in Swift in an ordered list of values of the same type,
 where each values has an index.
 The popLast() method is used to remove the last element from an array in Swift.
 Indexes must be Ints and also must be sequential!
 */
//let pastries: [String] = ["cookie", "cupcake", "donut", "pie"]
var pastries: [String] = []
pastries.append("cookie")
pastries.append("danish")
pastries += ["cupcake", "donut", "pie", "brownie"]

var pastrie: [String] = ["cookie", "cupcake", "donut", "pie"]
// Subcripting is used her to get an element from a specific location
pastrie[0]
// pastrie[10] // fatal error: Index out of range

let firstThree = pastrie[1...3] // this creates an "ArraySlice", which is slightly different than an array. It's a stored reference to a part of an array.
// firstThree[0] // fatal error: Index out of range

let firstThrees = Array(pastrie[1...3])
firstThrees[0]
pastrie.append("eclair")
//pastrie.removeAll()
pastrie.isEmpty
pastrie.count
pastrie.first
if let first = pastrie.first {
  print(first)
}

pastrie.contains("donut")
pastrie.contains("lasagna")
pastrie.insert("tart", at: 0)
let removedTwo = pastrie.remove(at: 2)
let removedLast = pastrie.removeLast()
removedTwo
removedLast
pastrie[0...1] = ["brownie", "fritter", "tart"]
pastrie

pastrie.swapAt(1, 2)
print(pastrie)

// - Challenge: Arrays

// Challenge 1-
/*
 Using the players array below, and the array methods and properties you learned about in this video, determine the following things about the array:
 (a) The count of elements in the array (b) Wheter or not the array contains the String value "Charles" (c) The first element in the array (d) The last element in the array
 */

print("Solution 1")
// Solution 1:
var players = ["Alice", "Bob", "Dan", "Eli", "Frank"]
players.count // (a)
players.contains("Charles") //(b)
players.first // (c)
players.last // (d)

// Challenge 2-
/*
 Some new players have joined the game: Charles, Gloria and Hermione. You'd like to add them to the array; Gloria and Hermione at the end, and Charles somewhere in the middle.
 (a) Insert Charles at index 2 in the array. (b) Add Gloria and Hermione at the end of the array in a single line of code.
 */

print("Solution 2")
// Solution 2:
players.insert("Charles", at: 2)
players += ["Gloria","Hermione"]
print(players)

// Challenge 3-
/*
 Create another new constant array named teamOne that consists of the last four members of the players array;
 that would be the range of elements from 4...7
 */

print("Solution 3")
// Solution 3:
let teamOne = Array(players[4...7])
print(teamOne)

// Control Flow

// - While Loops

var i = 1
while i < 10  { // is the same as i <= 9
  print(i)
  i += 1
}

print("Counting up again")
i = 1
repeat {
  print(i)
  i += 1
} while i < 10
          
i = 10
while i < 10  { // This code never executes!
  print(i)
  i += 1
}

print("Counting up again")
i = 10
repeat {
  print(i) // up to this code is executed once only!
  i += 1
} while i < 10

// - Challenge: While Loops

// Challenge 1-
/*
 Your first challenge is to create a loop that counts up from zero to nine.
 Create a variable named count and set it equal to 0.
 Next, create a While loop with the condition count < 10.
 Inside the loop, print out "Counting up: X" (where X is replaced with the count value) and then increment count by 1.
 Explain why the final value of count and the value in the last line printed out are different.
 */

print("Solution 1")
// Solution 1:
var count = 0
while count < 10 {
  print("Counting up: \(count)")
  count += 1
}
count

// Challenge 2-
/*
 Now that you've counted up, it's time to count down.
 Build a repeat-while loop that will count down the current value of count from Challenge 1, to one.
 First, print "Counting down: X", where X is the value of count inside the loop; then, decrement count.
 What are the 3 different loop conditions you could use with this loop, and get the same result?
 */

print("Solution 2")
// Solution 2:
repeat {
  print("Counting down: \(count)")
  count -= 1
} while count > 0 // is the same as count >= 1 or count != 0 (this one though is dangerous because it will end up with infinite loop when we reach negative numbers

// Challenge 3-
/*
 You're going to build a dice simulator, that will continue to roll until you get a six.
 Create a variable named rollCount and set it equal to 0.
 Create another named roll and set it equal to zero.
 Create a repeat-while loop.
 Inside the loop, to simulate the roll of a single die, set roll equal to the function Int.random(in: 1...6), which says "pick a random number between 1 and 6".
 Then increment rollCount by 1.
 Finally, print "Roll X gives you a Y" (where X is the value of rollCount and Y is the value of roll).
 Set the loop condition so that the repeat while loop finishes when the first 6 is rolled.
 */

print("Solution 3")
// Solution 3:
var rollCount = 0
var roll = 0
repeat {
  roll = Int.random(in: 1...6)
  rollCount += 1
  print("Roll \(rollCount) gives you a \(roll)")
} while roll != 6 // Theoretically this might give an infinite loop, but it unlikely that random number generator here will never deliver one of the values in this range within a reasonable number of tries.


// For Loops

let closedRange = 0...5 // This is a range from zero to five inclusive, that means it includes 5.
let halfOpenRange = 0..<5 // Note that we can't make a range that counts down, only up. Therefore the first number (0) must be equal or less than the second number (5)

var usefulValue = 5
let closeRange = 0...usefulValue
let halfedOpenRange = 0..<usefulValue

var sum = 0
let counts = 10
for i in 1...counts {
  sum += i
}
print(sum)

for _ in 1...counts {
  print("roar")
}

for _ in 1...counts where counts > 100 { // THIS code won't execute because i is less 100, which is 10
  print("roar")
}

for i in 1...counts {
  print("\(i) is an odd number.")
}
5 % 2
for i in 1...counts where i % 2 == 1 {
  print("\(i) is an odd number.")
}

// - Challenge: For Loops

// Challenge 1-
/*
 Create a for loop that counts by fives, up to and including 100.
 Use i as your loop value.
 Your for loop range should be 1 to 100 inclusive.
 Your for loop should use the where operator to limit the loop to values where i % 5 is equal to zero (that is, the value of i is evenly divisible by 5).
 Print out the value of i inside the loop.
 */

print("Solution 1")
// Solution 1:
for i in 1...100 where i % 5 == 0 {
  print(i)
}

// Challenge 2-
/*
Create a for loop that prints out a range of three numbers, the starting point of which you can control with a constant.
 Declare a constant named rangeStart and set it to 10.
 Use rangeValue as your loop value.
 Your for loop range should be from rangeStart to rangeStart + 3, but it should be a half-open range.
 Print out "Range value is X", where X is the value of rangeStart.
 When you have your loop working, change the rangeStart constant to a different number to create a different range.
 */

print("Solution 2")
// Solution 2:
let rangeStart = 10
for rangeValue in rangeStart..<rangeStart + 3 {
  print("Range value is \(rangeValue)")
}

// Challenge 3-
/*
Create a for loop to print your name a random number of timnes between one and five.
 Declare a variable named randomCount and set it to the value of Int.random(in: 1...5), which says "pick a random number between 1 and 5".
 You can ignore the loop value, since you won't need it inside the loop.
 Your loop range should be from one to randomCount, inclusive.
 Print out your name inside the loop.
 Execute your playground a few times to see your name printed out a random number of times.
 */

print("Solution 3")
// Solution 3:
var randomCount = Int.random(in: 1...5)
for _ in 1...randomCount {
  print("Mamadou")
}

// Iterating Collections
/*
 A "for-in" loop in Swift is used to iterate over a sequence, such as an array or a range, and execute a block of code
 for each element.
 The primary role of a "for-in" loop in Swift, when iterating through a collection, is to simplify access to array
 elements and maintain their order.
 The main purpose of using a "for-in" loop to iterate over a collection in Swift is to process each element in the
 collection, such as performing operations or transformations.
 In Swift, the "break" statement within a nested loop allows you to terminate the inner loop and continue to the outer
 loop iteration.
 */

let daysOfTheWeek: [String] = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
let poolTemperatures: [Int] = [78, 81, 74, 80, 79, 83, 84]

for i in 0..<daysOfTheWeek.count { // Note that if we use the 0...daysOfTheWeek.count will get a fatal error: array out of bound.
  print("\(daysOfTheWeek[i]): \(poolTemperatures[i])")
}

for i in 0..<daysOfTheWeek.count where poolTemperatures[i] >= 80 {
  print("\(daysOfTheWeek[i]): \(poolTemperatures[i])")
}

var sums = 0
for temperature in poolTemperatures {
  sums += temperature
}
sums / poolTemperatures.count

// - Challenge: Iterating Collections

// Challenge 1-
/*
I've provided an array of pastries below.
 Create a loop that iterates over each element of the array, and uses an if statement inside the loop to print out the pastries that start with the letter "c".
 There's no need to use i or another index variable to loop through the array; use the more compact way to
 iterate over every element of an array.
 To check if first letter of a string matches a certain character, you can use code of the following form:
 if pastry[pastry.startIndex] == "c"
 */

print("Solution 1")
// Solution 1:
var pastriess: [String] = ["cookie", "danish", "cupcake", "donut", "pie", "brownie", "fritter", "cruller"]

for pastry in pastriess {
  if pastry[pastry.startIndex] == "c" {
    print(pastry)
  }
}

// Challenge 2-
/*
 You can write an even more compact form of the loop above, using a where clause as part of your for loop condition.
 Remove the if block inside your loop; the only statement inside your loop should be print(pastry).
 Add a where clause to your for loop with the same if condition you used in the loop above.
 Your output should be the same as in Challenge 1.
 */

// Solution 2: // Note that writing tidy and compact code is the mark of a good developer. So let's try and tighten up the code from challenge 1.
for pastry in pastriess where pastry[pastry.startIndex] == "c" {
  print(pastry)
}

// Nested Loops & Early Exit

let daysOfTheWeeks: [String] = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
let poolsTemperatures: [Int] = [78, 81, 74, 80, 79, 83, 84]

for i in 0..<daysOfTheWeeks.count {
  if daysOfTheWeeks[i] == "Thursday" {
    break // break stops the loop entirely
  }
  print("\(daysOfTheWeeks[i]): \(poolsTemperatures[i])")
}
print("----")
for i in 0..<daysOfTheWeeks.count {
  if daysOfTheWeeks[i] == "Friday" {
    print("I'm in love")
    continue // continue only stops the current iteration and then goes back to looping
  }
  print("\(daysOfTheWeeks[i]): \(poolsTemperatures[i])")
}
print("----")

for floor in 11...15 {
  print(floor)
}
print("----")
for floor in 11...15 {
  for room in 1...4 {
    print("\(floor)-\(room)")
  }
}
print("----")
for floor in 11...15 {
  for room in 1...4 {
    if room == 1 {
      continue // this continue statement only breaks the inner loop; it does not affect the outer loop
    }
    print("\(floor)-\(room)")
  }
}
print("----")
for floor in 11...15 {
  if floor == 13 {
    continue
  }
  for room in 1...4 {
    if room == 1 {
      continue
    }
    print("\(floor)-\(room)")
  }
}
print("----")
floor_loop: for floor in 11...15 { // floor_loop is a label
  if floor == 13 {
    continue
  }
room_loop: for room in 1...4 { // room_loop is also a label
    if room == 1 {
      continue
    }
    if floor == 12 && room == 3 {
      continue floor_loop
    }
    print("\(floor)-\(room)")
  }
}
print("----")

// - Challenge: Nested Loops and Early Exit

// Challenge 1-
/*
Write two loops, one nested inside another, that will print a nice 10x5 rectangle of asterisks, like this:
 **********
 **********
 **********
 **********
 **********
 Your first (outer) loop should go from one to 5 inclusive.
 Your second (inner) loop should go from one to 10 inclusive.
 The print statement inside the inner loop should be print("*"m terminator="") which will print a string without
 the \n newline character at the end. This will let you string together your asterisks.
 You will also need a print statement after the inner loop finishes, to print a newline so that the next row of asterisks
 prints on a new line. You can do this simply print().
 */

print("Solution 1")
// Solution 1:
for _ in 1...5 {
  for _ in 1...10 {
    print("*", terminator: "")
  }
  print()
}
print("---")
// Challenge 2-
/*
 The array of pastries is back again! I've provided it down below.
 You're having a sale in your pastry shop - but only on the pastries that are five characters in length or
 less. Create a loop that will print out the pastries that are on sale.
 You can use the short form of a for loop to iterate over all pastries in the list.
 Use an if statement inside the loop to check if a pastry's name is greater than 5 characters in length. As an example, if
 your string is named pastry, you can use pastry.count to get the length of that string.
 Whenever you encounter a pastry that has more than 5 letters in its name, use the continue statement to skip this pasty.
 Otherwise, simply print out the name of the pastry.
 */

// Solution 2:
var pastris: [String] = ["cookie", "danish", "cupcake", "donut", "pie", "brownie", "fritter", "cruller"]

for pastry in pastris {
  if pastry.count > 5 {
    continue
  }
  print(pastry)
}
print("---")

// Challenge 3-
/*
 I've provided an array of the days of the week below. Create a loop to print out just the days of the week from
 Monday to Friday, inclusive.
 Use continue to skip Sunday, and use break to exit the loop early once you encounter Friday - but make sure you still
 print "Friday"!
 */

// Solution 3:
let dayOfTheWeek: [String] = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]

for day in dayOfTheWeek {
  if day == "Sunday" {
    continue
  }
  print(day)
  if day == "Friday" {
    break
  }
}

print("----")

// More Collections

// Creating & Populating Dictionaries
/*
 A dictionary is an unordered collection of pairs, where each pair is composed of a key and value.
 Dictionaries are really useful when we want to look up values by means of their identifier. And their keys are unique
 but different keys can point to the same value. All of the keys must be of the same type.
 Keys can be any type! Keys have no order!
 Dictionaries have many of the same qualities as arrays. We can use their built-in methods to check to see if they're
 empty, to see how many key value pairs they contain, or even to see if a dictionary contains a particular value,
 or after.
 But unlike arrays, dictionaries are a bit more flexible, when you ask a dictionary for something it does not contain.
 Dictionaries in Swift are used to store a collection of key-value pairs.
 The removeValue(forKey:) method is used to remove a key-value pair from a Swift dictionary by specifying the key.
 */

var emptyDictionary: [String: Int] = [:]
var namesAndPets = ["Ron": "🐀 Rat",
                    "Rincewind": "🧳 Luggage",
                    "Thor": "🔨 Hammer",
                    "Goku": "🪽 Flying Nimbus"]
print(namesAndPets)
namesAndPets.updateValue("🥭 Mango", forKey: "Chris")
namesAndPets["Calvin"] = "🐅 Tiger"
namesAndPets.updateValue("Owl", forKey: "Ron")
namesAndPets["Ron"] = "🦉 Owl"
print(namesAndPets)

print("---")

// Accessing & Working with Dictionaries
namesAndPets["Rincewind"]
namesAndPets["Captain Ahab"] // Captain Ahab is not a key in our dictionary, thus we will get a nil.
let captainAhabPet = namesAndPets["Captain Ahab"] ?? "No white whale for Captain Ahab"
namesAndPets.isEmpty
namesAndPets.count
namesAndPets.removeValue(forKey: "Goku")
namesAndPets["Hiccup"] = nil
print(namesAndPets)
for (character, pet) in namesAndPets {
  print("\(character) has a \(pet)")
}
for (name,_) in namesAndPets {
  print(name)
}
print("---")
for name in namesAndPets.keys {
  print(name)
}
for pet in namesAndPets.values {
  print(pet)
}

print("-----")

// - Challenge: Dictionaries

// Challenge 1-
/*
Create a dictionary as a variable, and initialize it with the following keys:
 - name
 - profession
 - country
 - city
 As part of the initialization, assign each of those keys a value that corresponds to
 your own personal information.
 */

print("Solution 1")
// Solution 1:
var mamadou = [
  "name": "Mamadou",
  "profession": "Native Mobile Developer",
  "country": "Canada",
  "city": "Albany"
]
print(mamadou)
print("-----")

// Challenge 2-
/*
 Let's say you decide to move to Cleveland, Ohio, USA. (If you already live in Cleveland, pick somewhere else
 you'd like to move to!) Update the dictionary as follows:
 - Modify contry to USA
 - Modify city to Cleveland
 - Add a state key to the dictionary and assign it the value Ohio
 */

// Solution 2:
mamadou["country"] = "USA"
mamadou["city"] = "Cleveland"
mamadou["state"] = "Ohio"
print(mamadou)
print("-----")

// Challenge 3-
/*
 You've decided that Cleveland (or wherever you've moved to) isn't right for you, so instead you plan to be
 a digital nomad, with no fixed city or state, but stay inside the USA.
 - Remove the city key-value pair with whatever strategy you like.
 - Remove the state key-value pair with a different strategy.
 */

// Solution 3:
mamadou.removeValue(forKey: "city") //Remove the city key-value pair with whatever strategy you like.
mamadou["state"] = nil //Remove the state key-value pair with a different strategy.
print(mamadou)
print("-----")

// Challenge 4-
/*
 Iterate over the remaining keys and values in the dictionary and print them out.
 */

// Solution 4:
for (key, value) in mamadou {
  print("\(key): \(value)") /*
                             Note that the order in which the key-value pairs are printed out is not always
                             the same order that you define them. And that's because by definition,
                             dictionaries are unordered collections.
                              */
}
print("-----")

// Working with Sets
/*
 A set is an unordered collection of unique values, of the same type.
 Sets in Swift store only unique values, which means each value appears at most once in a set.
 */

// Creating and Populating Sets
var someSet: Set<Int> = [1, 2, 3, 1]
// let someArray: Array<Int>
// let someDictionary: Dictionary<String, Int>
someSet.contains(1)
someSet.contains(99)
someSet.insert(5)
someSet.remove(3)
let removedElement = someSet.remove(3)
let nilElement = someSet.remove(42)
print(someSet)

let anotherSet: Set<Int> = [5, 7, 13]
let intersection = someSet.intersection(anotherSet)
let difference = someSet.symmetricDifference(anotherSet)
let union = someSet.union(anotherSet)
someSet.formUnion(anotherSet)
print(intersection)
print(difference)
print(union)
print(someSet)

print("---")

// - Challenge: Sets

/*
 Note about different ways to create sets:
 The first way puts the members of the set right in the initializer; the second initializes an empty set and then calls
 .insert() to insert individual members into the set.
*/
var mythicalPets: Set<String> = [
  "🦉 Owl",
  "🧳 Luggage",
  "🔨 Hammer",
  "🦷 Toothless",
  "🪽 Flying Nimbus"
]
print(mythicalPets)

var animalPets = Set<String>()
animalPets.insert("🥭 Mango")
animalPets.insert("🐅 Tiger")
animalPets.insert("🦷 Toothless")
animalPets.insert("🦉 Owl")
print(animalPets)

print("-----")

// Challenge 1-
/*
Use the .union() method to show the combined set of pets between mythicalPets and
 animalPets. Print the resulting set to the console.
 */

print("Solution 1")
// Solution 1:
print(mythicalPets.union(animalPets))
print("-----")

// Challenge 2-
/*
 Use the .intersection() method to find out which pets exist in both mythicalPets and animalPets.
 Print the resulting set to the console.
 */

// Solution 2:
print(animalPets.intersection(mythicalPets))

print("----")

// Challenge 3-
/*
 The only pet in these two sets that actually exists in real life is "Mango". Remove her from the appropriate set with the
 .remove() method and capture the removed element in a constant named removedPet.
 */

// Solution 3:
let removedPet = animalPets.remove("🥭 Mango")
print("-----")

// Challenge 4-
/*
 Since you've removed Mango, all of the pets in both sets are technically mythical pets. Use .formUnion
 to mutute the mythicalPets set to contain the combination of both sets of pets.
 Print the new mythicalPets set to the console to check your work.
 */

// Solution 4:
mythicalPets.formUnion(animalPets)
print(mythicalPets)

print("----")

// Functions & Named Typed
/*
 Named Tpes: have names when they're difined!
 - Structures
 - Classes
 - Enumerations
 - Protocols
 
 Compound Types: unnamed! Defined by the types they contain.
 Tuple              Type Signature
 (3, 17, 8)         (Int, Int, Int)
 ("Hello!", true)   (String, Bool)
 (3.14, (32,9))     (Double, (Int, Int))
 
 func amountOff() -> Int {
  abs(target - sliderValueRounded())
 }
 
 Value Types      VS.     Reference Types
 - Structures             - Classes
 - Tuples                 - Functions
 
 Classes
 Structures        VS.     Classes
 - value type               - reference type
 - values                   - objects
 - copy                     - share
 - immutable                - mutable
 */

// Introduction to Functions
func printHello() {
  print("Hello!")
}
printHello()

print("----------------------------")
// Progamming in Swift: Functions & Types

// Functions

// Introduction:
/*
                  Closures:
 Closures                         Functions
  NO                Names?          YES
  NO                Argument        YES
                    Labels?
  NO             Default Parameter  YES
                    Values?
  YES              Write Inline?    NO
 
{ (a: Int, b: Int)   Different      func multiply(a: Int, b: Int) -> Int
 -> Int in            Syntax!         a * b
  a * b                             }
 }
 */



//: ## Episode 04: Overlaoads & Parameters
// ---------------------------------------
let passingsGrades = 50
let jessyGrade = 49
let ozmaGrade = 87
let ozmaAllGrades = [60, 96, 87, 42]
// ---------------------------------------
//: ### Function overloads
//: Overlaoading let you define similar functions that share a name

//func getPassStatus(for grade: Int) -> Bool {
//  grade >= passingsGrades
//}

//: Overload using Different Number of Parameters

//func getPassStatus(for grade: Int, lowestPass: Int) -> Bool {
//  grade >= lowestPass
//}


//: Use default values for parameters, instead of overloads, when you can

func getPassStatus(for grade: Int, lowestPass: Int = passingsGrades) -> Bool {
  grade >= passingsGrades
}

getPassStatus(for: ozmaGrade, lowestPass: 80)
getPassStatus(for: jessyGrade)


//: Overload using Different Parameter Types

func getPassStatus(for grades: [Int]) -> Bool {
  var totalGrade = 0
  for grade in grades {
    totalGrade += grade
  }
  let averageGrade = totalGrade / grades.count
  return averageGrade >= passingsGrades
}

getPassStatus(for: ozmaAllGrades)
//: Overload using Different Argument Labels, like Swift's stride functions



// fancy separator for console readability
print("\n ---// ------//--- \n")
//: Overload using Different Return Types


//: ### Variadic Parameters

//: ### Inout Parameters
// ---------------------------------------

// ---------------------------------------



