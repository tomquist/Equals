[![Build Status](https://travis-ci.org/tomquist/Equals.svg)](https://travis-ci.org/tomquist/Equals)
[![codecov.io](https://codecov.io/github/tomquist/Equals/coverage.svg)](https://codecov.io/github/tomquist/Equals)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/Equals.svg?style=flat)](https://cocoapods.org/pods/Equals)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Swift Package Manager Compatible](https://img.shields.io/badge/SPM-compatible-4BC51D.svg?style=flat)](https://github.com/tomquist/Equals)
[![Platform support](https://img.shields.io/badge/platform-ios%20%7C%20osx%20%7C%20tvos%20%7C%20watchos%20%7C%20linux-brightgreen.svg?style=flat)](https://github.com/tomquist/Equals)
[![License MIT](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)](https://github.com/tomquist/Equals/blob/master/LICENSE.md)

# Equals
Equals is a Swift µframework to reduce boilerplate code when conforming to Equatable and Hashable protocols.


## Requirements
 
* Swift 3.0
* Any Swift 3.0 compatible platform (iOS 8.0+ / Mac OS X 10.10+ / tvOS 9.0+ / watchOS 2.0+ / Linux)

## Installation

### CocoaPods

Add Equals to your pod file and run ``pod install``:
```ruby
pod 'Equals', '~> 2.0.0'
```

### Carthage

Add Equals to your Cartfile (package dependency) or Cartfile.private (development dependency):
```
github "tomquist/Equals" ~> 2.0.0
```

### Swift Package Manager
Add to your Package.swift dependencies:
```swift
import PackageDescription

let package = Package(
    // ... your project details
    dependencies: [
        // As a required dependency
        .Package(url: "ssh://git@github.com/tomquist/Equals.git", majorVersion: 2)
    ],
    testDependencies: [
        // As a test dependency
        .Package(url: "ssh://git@github.com/tomquist/Equals.git", majorVersion: 2)
    ]
)
```

## Motivation

Lets start with a simple struct:

```swift
struct Person {
    let firstName: String?
    let lastName: String
    let children: [Person]
}
```

To conform this type to ``Equatable`` we first have to declare conformance, e.g. by providing an empty extension and provide an operator overload for ``==``:
```swift
extension Person: Equatable {}

func ==(lhs: Person, rhs: Person) -> Bool {
	return lhs.firstName == rhs.firstName
		&& lhs.lastName == rhs.lastName
		&& lhs.children == rhs.children
}
```

As you can see, this is a lot of code for such a simple type and each property is listed twice.

Even worse, when conforming to ``Hashable`` you additionally have to provide a complex ``hashValue`` property:
```swift
extension Person: Hashable {
	var hashValue: Int {
        var result = 17
        result = 31 &* result &+ (firstName?.hashValue ?? 0)
        result = 31 &* result &+ lastName.hashValue
        for child in children {
            result = 31 &* result &+ child.hashValue
        }
        return result
    }
}
```

## Demo

Using Equals, this is a lot easier. To conform to ``Hashable``, all you have to do is to conform to the ``EqualsHashable`` protocol:
```swift
extension Person: EqualsHashable {
    static let hashes: Hashes<Person> = Hashes()
        .append {$0.firstName}
        .append {$0.lastName}
        .append {$0.children}
}
```

If you don't need hashing capabilities, just conform to the ``EqualsEquatable`` protocol:
```swift
extension Person: EqualsEquatable {
    static let equals: Equals<Person> = Equals()
        .append {$0.firstName}
        .append {$0.lastName}
        .append {$0.children}
}
```

That's it! Now you can compare your type, using the ``==`` operator, put it into ``Set``s or use it as a ``Dictionary`` key.


## Advanced usage
Equals currently provides ``append`` functions for four types of properties:
* ``Equatable``/``Hashable`` properties
* ``Optional`` properties of type ``Equatable``/``Hashable``
* ``CollectionType`` properties where the elements are ``Equatable``/``Hashable``
* Any other property, but you have to provide equals and hashValue functions.

Sometimes, you explicitly have to specify which append method to use. E.g. lets change the property ``children`` of our ``Person`` example above into type ``Set<Person>``. Because ``Set`` already conforms to ``Hashable``, we now get a compiler error:
```
Ambiguous use of 'append(hashable:)'
```
This is because there are potentially several ``append`` methods that could be used in this situation. To avoid this error, we can change our implementation of ``EqualsHashable`` into this:
```swift
extension Person: EqualsHashable {
    static let hashes: Hashes<Person> = Hashes()
        .append {$0.firstName}
        .append {$0.lastName}
        .append(hashable: {$0.children})
}
```
