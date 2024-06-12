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





