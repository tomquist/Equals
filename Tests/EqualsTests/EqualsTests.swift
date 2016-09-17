import XCTest
import Equals

private struct NonEquatable {
    let name: String
}

private struct Person {
    let firstName: String?
    let lastName: String
    let children: [Person]
    let nonEquatable: NonEquatable
}

extension Person: EqualsEquatable {
    static let equals: Equals<Person> = Equals()
        .append {$0.firstName}
        .append {$0.lastName}
        .append {$0.children}
        .append({$0.nonEquatable}) { $0.name == $1.name }
}

class EqualsTests: XCTestCase {
    
    static var allTests: [(String, (EqualsTests) -> () throws -> Void)] {
        return [
            ("testEqualPersons", testEqualPersons),
            ("testEqualPersonsWithDifferentFirstName", testEqualPersonsWithDifferentFirstName),
            ("testEqualPersonsWithDifferentLastName", testEqualPersonsWithDifferentLastName),
            ("testEqualPersonsWithDifferentChildren", testEqualPersonsWithDifferentChildren),
            ("testEqualPersonsWithDifferentNonEquatables", testEqualPersonsWithDifferentNonEquatables),
        ]
    }
    
    func testEqualPersons() {
        let person1 = Person(firstName: "Tom", lastName: "Quist", children: [], nonEquatable: NonEquatable(name: "name"))
        let person2 = Person(firstName: "Tom", lastName: "Quist", children: [], nonEquatable: NonEquatable(name: "name"))
        XCTAssertEqual(person1, person2)
    }

    func testEqualPersonsWithDifferentFirstName() {
        let person1 = Person(firstName: "Tom", lastName: "Quist", children: [], nonEquatable: NonEquatable(name: "name"))
        let person2 = Person(firstName: nil, lastName: "Quist", children: [], nonEquatable: NonEquatable(name: "name"))
        XCTAssertNotEqual(person1, person2)
    }
    
    func testEqualPersonsWithDifferentLastName() {
        let person1 = Person(firstName: "Tom", lastName: "Quist", children: [], nonEquatable: NonEquatable(name: "name"))
        let person2 = Person(firstName: "Tom", lastName: "Tom", children: [], nonEquatable: NonEquatable(name: "name"))
        XCTAssertNotEqual(person1, person2)
    }

    func testEqualPersonsWithDifferentChildren() {
        let person1 = Person(firstName: "Tom", lastName: "Quist", children: [], nonEquatable: NonEquatable(name: "name"))
        let person2 = Person(firstName: "Tom", lastName: "Quist", children: [person1], nonEquatable: NonEquatable(name: "name"))
        XCTAssertNotEqual(person1, person2)
    }
    
    func testEqualPersonsWithDifferentNonEquatables() {
        let person1 = Person(firstName: "Tom", lastName: "Quist", children: [], nonEquatable: NonEquatable(name: "name1"))
        let person2 = Person(firstName: "Tom", lastName: "Quist", children: [], nonEquatable: NonEquatable(name: "name2"))
        XCTAssertNotEqual(person1, person2)
    }
    
}
