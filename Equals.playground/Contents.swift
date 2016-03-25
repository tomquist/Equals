/*:
# Equals
*/
import Equals

/*:
## Introduction
First let's create a simple struct for a Person.
*/
struct Person {
    let firstName: String?
    let lastName: String
    let middleNames: [String]
    let age: Int
}

/*: Lets create two instances of this struct: `tom` and `steve` */
let tom = Person(firstName: "Tom", lastName: "Quist", middleNames: ["André"], age: 30)
let steve = Person(firstName: "Steve", lastName: "Jobs", middleNames: ["Paul"], age: 56)

/*:
## Equatable
To make the struct `Equatable`, we simply conform to the `EqualsEquatable` protocol:
*/
extension Person: EqualsEquatable {
    static let equals: Equals<Person> = Equals()
        .append {$0.firstName}
        .append {$0.lastName}
        .append {$0.age}
        .append(collection: {$0.middleNames})
}

/*: Let's do some comparison for equal objects */
tom == Person(firstName: "Tom", lastName: "Quist", middleNames: ["André"], age: 30) // => false
steve == steve // => true

/*: These comparisons should fail */
tom == steve // => false
tom == Person(firstName: "Tom", lastName: "Quist", middleNames: ["André"], age: 29) // => false

/*:
## Hashable
Conforming to the `Hashable` protocol is just as simple:
*/
extension Person: EqualsHashable {
    static let hashes: Hashes<Person> = Hashes()
        .append {$0.firstName}
        .append {$0.lastName}
        .append {$0.age}
        .append(collection: {$0.middleNames})
}

tom.hashValue == Person(firstName: "Tom", lastName: "Quist", middleNames: ["André"], age: 30).hashValue // => true
steve.hashValue == steve.hashValue // => true
tom.hashValue == steve.hashValue // => false

/*:
In fact, `EqualsHashable` is a descendant of `EqualsEquatable`. So if you conform to `EqualsHashable`,
you don't have to provide an `equals` property.
*/

/*:
## CustomStringConvertible
Now we need a string representation of our Person struct. This is as simple as
making the type equatable. Simply let's conform to EqualsCustomStringConvertible
*/
extension Person: EqualsCustomStringConvertible {
    static let describes: Describes<Person> = Describes()
        .append("firstName") { $0.firstName }
        .append("lastName") { $0.lastName }
        .append("age") {$0.age}
}

print(tom.description)
print(steve.description)

/*:
## DebugStringConvertible
To get a debug string representation, simply conform to `EqualsDebugStringConvertible`.
By default, when the type also conforms to `EqualsCustomStringConvertible`, the same
`Describes`-Helper is used, but you can also provide a different one:
*/
extension Person: EqualsDebugStringConvertible {
    static let debugDescribes: Describes<Person> = Describes()
        .append("firstName") { $0.firstName }
        .append("middleNames") { $0.middleNames }
        .append("lastName") { $0.lastName }
        .append("age") {$0.age}
}
print(steve.debugDescription)

