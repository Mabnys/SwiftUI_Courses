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

