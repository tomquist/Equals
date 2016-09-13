import XCTest
@testable import EqualsTest

XCTMain([
    testCase(EqualsTests.allTests),
    testCase(HashesTests.allTests),
])
