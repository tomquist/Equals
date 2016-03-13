import XCTest
@testable import Equals

private struct Person {
    let firstName: String?
    let lastName: String
    let middleNames: [String]
    let children: Set<Person>
    let sequence: Sequence<Int>
}
extension Person: EqualsHashable {
    static let hashes: Hashes<Person> = Hashes()
        .append {$0.firstName}
        .append {$0.lastName}
        .append(collection: {$0.middleNames})
        .append {$0.sequence}
        .append(hashable: {$0.children})
}

class HashesTests: XCTestCase, XCTestCaseProvider {
    
    var allTests: [(String, () throws -> Void)] {
        return [
            ("testEqualPersons", testEqualPersons),
            ("testEqualPersonsWithDifferentFirstName", testEqualPersonsWithDifferentFirstName),
            ("testEqualPersonsWithDifferentLastName", testEqualPersonsWithDifferentLastName),
            ("testEqualPersonsWithDifferentMiddleNames", testEqualPersonsWithDifferentMiddleNames),
            ("testEqualPersonsWithDifferentChildren", testEqualPersonsWithDifferentChildren),
            ("testEqualPersonsWithDifferentSequences", testEqualPersonsWithDifferentSequences),
        ]
    }
    
    func testEqualPersons() {
        let person1 = Person(firstName: "Tom", lastName: "Quist", middleNames: [], children: [], sequence: [])
        let person2 = Person(firstName: "Tom", lastName: "Quist", middleNames: [], children: [], sequence: [])
        XCTAssertEqual(person1, person2)
        XCTAssertEqual(person1.hashValue, person2.hashValue)
    }
    
    func testEqualPersonsWithDifferentFirstName() {
        let person1 = Person(firstName: "Tom", lastName: "Quist", middleNames: [], children: [], sequence: [])
        let person2 = Person(firstName: nil, lastName: "Quist", middleNames: [], children: [], sequence: [])
        XCTAssertNotEqual(person1, person2)
        XCTAssertNotEqual(person1.hashValue, person2.hashValue)
    }
    
    func testEqualPersonsWithDifferentLastName() {
        let person1 = Person(firstName: "Tom", lastName: "Quist", middleNames: [], children: [], sequence: [])
        let person2 = Person(firstName: "Tom", lastName: "Tom", middleNames: [], children: [], sequence: [])
        XCTAssertNotEqual(person1, person2)
        XCTAssertNotEqual(person1.hashValue, person2.hashValue)
    }
    
    func testEqualPersonsWithDifferentMiddleNames() {
        let person1 = Person(firstName: "Tom", lastName: "Quist", middleNames: ["Max", "André"], children: [], sequence: [])
        let person2 = Person(firstName: "Tom", lastName: "Quist", middleNames: ["Max", "Peter"], children: [], sequence: [])
        XCTAssertNotEqual(person1, person2)
        XCTAssertNotEqual(person1.hashValue, person2.hashValue)
    }
    
    
    func testEqualPersonsWithDifferentChildren() {
        let person1 = Person(firstName: "Tom", lastName: "Quist", middleNames: [], children: [], sequence: [])
        let person2 = Person(firstName: "Tom", lastName: "Quist", middleNames: [], children: [person1], sequence: [])
        let person3 = Person(firstName: "Tom", lastName: "Quist", middleNames: [], children: [person2], sequence: [])
        XCTAssertNotEqual(person2, person3)
        XCTAssertNotEqual(person2.hashValue, person3.hashValue)
    }

    func testEqualPersonsWithDifferentSequences() {
        let person1 = Person(firstName: "Tom", lastName: "Quist", middleNames: [], children: [], sequence: [1,2])
        let person2 = Person(firstName: "Tom", lastName: "Quist", middleNames: [], children: [], sequence: [1,3])
        XCTAssertNotEqual(person1, person2)
        XCTAssertNotEqual(person1.hashValue, person2.hashValue)
    }

}
