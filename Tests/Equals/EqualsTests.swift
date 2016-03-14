import XCTest
@testable import Equals

private struct Person {
    let firstName: String?
    let lastName: String
    let children: [Person]
    let sequence: Sequence<Int>
}

extension Person: EqualsEquatable {
    static let equals: Equals<Person> = Equals()
        .append {$0.firstName}
        .append {$0.lastName}
        .append(collection: {$0.children})
        .append {$0.sequence}
}

class EqualsTests: XCTestCase, XCTestCaseProvider {
    
    var allTests: [(String, () throws -> Void)] {
        return [
            ("testEqualPersons", testEqualPersons),
            ("testEqualPersonsWithDifferentFirstName", testEqualPersonsWithDifferentFirstName),
            ("testEqualPersonsWithDifferentLastName", testEqualPersonsWithDifferentLastName),
            ("testEqualPersonsWithDifferentChildren", testEqualPersonsWithDifferentChildren),
            ("testEqualPersonsWithDifferentSequences", testEqualPersonsWithDifferentSequences),
        ]
    }
    
    func testEqualPersons() {
        let person1 = Person(firstName: "Tom", lastName: "Quist", children: [], sequence: [])
        let person2 = Person(firstName: "Tom", lastName: "Quist", children: [], sequence: [])
        XCTAssertEqual(person1, person2)
    }

    func testEqualPersonsWithDifferentFirstName() {
        let person1 = Person(firstName: "Tom", lastName: "Quist", children: [], sequence: [])
        let person2 = Person(firstName: nil, lastName: "Quist", children: [], sequence: [])
        XCTAssertNotEqual(person1, person2)
    }
    
    func testEqualPersonsWithDifferentLastName() {
        let person1 = Person(firstName: "Tom", lastName: "Quist", children: [], sequence: [])
        let person2 = Person(firstName: "Tom", lastName: "Tom", children: [], sequence: [])
        XCTAssertNotEqual(person1, person2)
    }

    func testEqualPersonsWithDifferentChildren() {
        let person1 = Person(firstName: "Tom", lastName: "Quist", children: [], sequence: [])
        let person2 = Person(firstName: "Tom", lastName: "Quist", children: [person1], sequence: [])
        XCTAssertNotEqual(person1, person2)
    }
    
    func testEqualPersonsWithDifferentSequences() {
        let person1 = Person(firstName: "Tom", lastName: "Quist", children: [], sequence: [1,2])
        let person2 = Person(firstName: "Tom", lastName: "Quist", children: [], sequence: [1,3])
        XCTAssertNotEqual(person1, person2)
    }


}
