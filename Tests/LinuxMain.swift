import XCTest
@testable import EqualsTests

XCTMain([
    testCase(EqualsTests.allTests),
    testCase(HashesTests.allTests),
])
