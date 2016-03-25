import XCTest
import Equals

private struct Person {
    let firstName: String?
    let lastName: String
    let age: Int
}

extension Person: EqualsCustomStringConvertible {
    static let describes: Describes<Person> = Describes()
        .append("firstName") {$0.firstName}
        .append("lastName") {$0.lastName}
        .append("age") {$0.age}
}

extension Person: EqualsDebugStringConvertible {}

struct Animal {
    let name: String
    let age: Int
}
extension Animal: EqualsDebugStringConvertible {
    static let debugDescribes: Describes<Animal> = Describes()
        .append("name") {$0.name}
        .append("age") {$0.age}
}

class DescribesTests: XCTestCase, XCTestCaseProvider {
    
    var allTests: [(String, () throws -> Void)] {
        return [
            ("testSimplest", testSimplest),
            ("testSimpleWithNilValue", testSimpleWithNilValue),
            ("testSimpleMultiline", testSimpleMultiline),
            ("testSimpleWithFieldNames", testSimpleWithFieldNames),
            ("testSimpleWithFieldNamesMultiline", testSimpleWithFieldNamesMultiline),
            ("testWithTypeNameInferred", testWithTypeNameInferred),
            ("testWithTypeNameProvided", testWithTypeNameProvided),
            ("testWithTypeAndFieldNames", testWithTypeAndFieldNames),
            ("testWithTypeAndFieldNamesMultiline", testWithTypeAndFieldNamesMultiline),
            ("testDefaultInitializerValues", testDefaultInitializerValues),
            ("testExtension", testExtension),
            ("testDebugExtensionByDefaultUsesDescribes", testDebugExtensionByDefaultUsesDescribes),
            ("testDebugExtension", testDebugExtension),
        ]
    }
    
    func testSimplest() {
        let describes: Describes<Person> = Describes(includeType: false, includeFieldNames: false, multiline: false)
            .append("firstName") {$0.firstName}
            .append("lastName") {$0.lastName}
            .append("age") {$0.age}
        let person = Person(firstName: "Tom", lastName: "Quist", age: 30)
        XCTAssertEqual(describes.describe(person), "Tom,Quist,30")
    }

    func testSimpleWithNilValue() {
        let describes: Describes<Person> = Describes(includeType: false, includeFieldNames: false, multiline: false)
            .append("firstName") {$0.firstName}
            .append("lastName") {$0.lastName}
            .append("age") {$0.age}
        let person = Person(firstName: nil, lastName: "Quist", age: 30)
        XCTAssertEqual(describes.describe(person), "nil,Quist,30")
    }
    
    func testSimpleMultiline() {
        let describes: Describes<Person> = Describes(includeType: false, includeFieldNames: false, multiline: true)
            .append("firstName") {$0.firstName}
            .append("lastName") {$0.lastName}
            .append("age") {$0.age}
        let person = Person(firstName: "Tom", lastName: "Quist", age: 30)
        XCTAssertEqual(describes.describe(person), "Tom\nQuist\n30")
    }
    
    func testSimpleWithFieldNames() {
        let describes: Describes<Person> = Describes(includeType: false, includeFieldNames: true, multiline: false)
            .append("firstName") {$0.firstName}
            .append("lastName") {$0.lastName}
            .append("age") {$0.age}
        let person = Person(firstName: "Tom", lastName: "Quist", age: 30)
        XCTAssertEqual(describes.describe(person), "firstName=Tom,lastName=Quist,age=30")
    }
    
    func testSimpleWithFieldNamesMultiline() {
        let describes: Describes<Person> = Describes(includeType: false, includeFieldNames: true, multiline: true)
            .append("firstName") {$0.firstName}
            .append("lastName") {$0.lastName}
            .append("age") {$0.age}
        let person = Person(firstName: "Tom", lastName: "Quist", age: 30)
        XCTAssertEqual(describes.describe(person), "firstName=Tom\nlastName=Quist\nage=30")
    }
    
    func testWithTypeNameInferred() {
        let describes: Describes<Person> = Describes(includeType: true, includeFieldNames: false, multiline: false)
            .append("firstName") {$0.firstName}
            .append("lastName") {$0.lastName}
            .append("age") {$0.age}
        let person = Person(firstName: "Tom", lastName: "Quist", age: 30)
        XCTAssertEqual(describes.describe(person), "\(String(Person))[Tom,Quist,30]")
    }
    
    func testWithTypeNameProvided() {
        let describes: Describes<Person> = Describes(includeType: true, typeName: "PersonStruct", includeFieldNames: false, multiline: false)
            .append("firstName") {$0.firstName}
            .append("lastName") {$0.lastName}
            .append("age") {$0.age}
        let person = Person(firstName: "Tom", lastName: "Quist", age: 30)
        XCTAssertEqual(describes.describe(person), "PersonStruct[Tom,Quist,30]")
    }
    
    func testWithTypeAndFieldNames() {
        let describes: Describes<Person> = Describes(includeType: true, typeName: "Person", includeFieldNames: true, multiline: false)
            .append("firstName") {$0.firstName}
            .append("lastName") {$0.lastName}
            .append("age") {$0.age}
        let person = Person(firstName: "Tom", lastName: "Quist", age: 30)
        XCTAssertEqual(describes.describe(person), "Person[firstName=Tom,lastName=Quist,age=30]")
    }
    
    func testWithTypeAndFieldNamesMultiline() {
        let describes: Describes<Person> = Describes(includeType: true, typeName: "Person", includeFieldNames: true, multiline: true)
            .append("firstName") {$0.firstName}
            .append("lastName") {$0.lastName}
            .append("age") {$0.age}
        let person = Person(firstName: "Tom", lastName: "Quist", age: 30)
        XCTAssertEqual(describes.describe(person), "Person[\n  firstName=Tom\n  lastName=Quist\n  age=30\n]")
    }
    
    func testDefaultInitializerValues() {
        let describes: Describes<Person> = Describes()
            .append("firstName") {$0.firstName}
            .append("lastName") {$0.lastName}
            .append("age") {$0.age}
        let person = Person(firstName: "Tom", lastName: "Quist", age: 30)
        XCTAssertEqual(describes.describe(person), "\(String(Person))[firstName=Tom,lastName=Quist,age=30]")
    }
    
    func testExtension() {
        let person = Person(firstName: "Tom", lastName: "Quist", age: 30)
        XCTAssertEqual(person.description, "\(String(Person))[firstName=Tom,lastName=Quist,age=30]")
    }
    
    func testDebugExtensionByDefaultUsesDescribes() {
        let person = Person(firstName: "Tom", lastName: "Quist", age: 30)
        XCTAssertEqual(person.debugDescription, person.description)
    }
    
    func testDebugExtension() {
        let animal = Animal(name: "Swift", age: 2)
        XCTAssertEqual(animal.debugDescription, "\(String(Animal))[name=Swift,age=2]")
    }

}
