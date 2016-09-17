import XCTest
import Equals

private struct NonHashable {
    let name: String
}

private struct Person {
    let firstName: String?
    let lastName: String
    let middleNames: [String]
    let children: Set<Person>
    let nonHashable: NonHashable
}
extension Person: EqualsHashable {
    static let hashes: Hashes<Person> = Hashes()
        .append {$0.firstName}
        .append {$0.lastName}
        .append {$0.middleNames}
        .append(hashable: {$0.children})
        .append({$0.nonHashable}, equals: {$0.name == $1.name}, hash: {$0.name.hashValue})
}

class HashesTests: XCTestCase {
    
    static var allTests: [(String, (HashesTests) -> () throws -> Void)] {
        return [
            ("testInitialAndConstantValue", testInitialAndConstantValue),
            ("testEqualPersons", testEqualPersons),
            ("testEqualPersonsWithDifferentFirstName", testEqualPersonsWithDifferentFirstName),
            ("testEqualPersonsWithDifferentLastName", testEqualPersonsWithDifferentLastName),
            ("testEqualPersonsWithDifferentMiddleNames", testEqualPersonsWithDifferentMiddleNames),
            ("testEqualPersonsWithDifferentChildren", testEqualPersonsWithDifferentChildren),
            ("testEqualPersonsWithDifferentNonHashable", testEqualPersonsWithDifferentNonHashable),
        ]
    }
    
    func testInitialAndConstantValue() {
        let hashes = Hashes<Int>(constant: 31, initial: 7)
        XCTAssertEqual(31, hashes.constant)
        XCTAssertEqual(7, hashes.initial)
    }
    
    func testEqualPersons() {
        let personX = Person(firstName: "John", lastName: "Doe", middleNames: [], children: [], nonHashable: NonHashable(name: "name"))
        let personY = Person(firstName: "John", lastName: "Smith", middleNames: [], children: [], nonHashable: NonHashable(name: "name"))
        
        let person1 = Person(firstName: "Tom", lastName: "Quist", middleNames: ["André"], children: [personX, personY], nonHashable: NonHashable(name: "name"))
        let person2 = Person(firstName: "Tom", lastName: "Quist", middleNames: ["André"], children: [personY, personX], nonHashable: NonHashable(name: "name"))
        XCTAssertEqual(person1, person2)
        XCTAssertEqual(person1.hashValue, person2.hashValue)
    }
    
    func testEqualPersonsWithDifferentFirstName() {
        let person1 = Person(firstName: "Tom", lastName: "Quist", middleNames: [], children: [], nonHashable: NonHashable(name: "name"))
        let person2 = Person(firstName: nil, lastName: "Quist", middleNames: [], children: [], nonHashable: NonHashable(name: "name"))
        XCTAssertNotEqual(person1, person2)
        XCTAssertNotEqual(person1.hashValue, person2.hashValue)
    }
    
    func testEqualPersonsWithDifferentLastName() {
        let person1 = Person(firstName: "Tom", lastName: "Quist", middleNames: [], children: [], nonHashable: NonHashable(name: "name"))
        let person2 = Person(firstName: "Tom", lastName: "Tom", middleNames: [], children: [], nonHashable: NonHashable(name: "name"))
        XCTAssertNotEqual(person1, person2)
        XCTAssertNotEqual(person1.hashValue, person2.hashValue)
    }
    
    func testEqualPersonsWithDifferentMiddleNames() {
        let person1 = Person(firstName: "Tom", lastName: "Quist", middleNames: ["Max", "André"], children: [], nonHashable: NonHashable(name: "name"))
        let person2 = Person(firstName: "Tom", lastName: "Quist", middleNames: ["Max", "Peter"], children: [], nonHashable: NonHashable(name: "name"))
        XCTAssertNotEqual(person1, person2)
        XCTAssertNotEqual(person1.hashValue, person2.hashValue)
    }
    
    
    func testEqualPersonsWithDifferentChildren() {
        let person1 = Person(firstName: "Tom", lastName: "Quist", middleNames: [], children: [], nonHashable: NonHashable(name: "name"))
        let person2 = Person(firstName: "Tom", lastName: "Quist", middleNames: [], children: [person1], nonHashable: NonHashable(name: "name"))
        let person3 = Person(firstName: "Tom", lastName: "Quist", middleNames: [], children: [person2], nonHashable: NonHashable(name: "name"))
        XCTAssertNotEqual(person2, person3)
        XCTAssertNotEqual(person2.hashValue, person3.hashValue)
    }
    
    func testEqualPersonsWithDifferentNonHashable() {
        let person1 = Person(firstName: "Tom", lastName: "Quist", middleNames: [], children: [], nonHashable: NonHashable(name: "name1"))
        let person2 = Person(firstName: "Tom", lastName: "Quist", middleNames: [], children: [], nonHashable: NonHashable(name: "name2"))
        XCTAssertNotEqual(person1, person2)
        XCTAssertNotEqual(person1.hashValue, person2.hashValue)
    }

}
