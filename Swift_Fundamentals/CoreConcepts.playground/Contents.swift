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

// Solution 1:
let myAge = 29
let isVotingAge = myAge >= 18

/* Challenge 2- Create a constant named student and set its value to your name as a string.
 Next, create a constant named author and set its value to "Matt Galloway", the original author of these exercices.
 Then, create a third constant named authorIsStudent that uses string equality to determine if the values of student and author are equal. */

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

// Solution 1:
let myAges = 29
if myAges >= 13 && myAges <= 19 {
  print("Teenager")
} else {
  print("Not a teenager")
}

/* Challenge 2- Create a constant named teenagerName, and use a ternary conditional operator to set the value of teenagerName to your own name as a string if the value of myAge, declared above, is greater than or equal to 13, but less than or equal to 19, and to set the value of teenagerName to "Not me!" if the value is outside that range.
 Then print out the value of teenagerName. */

// Solution 2:
let teenagerNames = myAges >= 13 && myAges <= 19 ? "Chris" : "Not me!"
print(teenagerNames)

// Optionals: "?"
/*
 Optionals in Swift let us represent either a value,
 or the absence of a value, which is called "nil".
 Optionals all have a type.
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

