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
                   so this statement is true */

// Comparison operators are used troughtout a programer career, thus, it is great idea to understand them really well.


