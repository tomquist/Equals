struct TestSequence<T>: Sequence {
    fileprivate let items: [T]
    init(_ items: [T]) {
        self.items = items
    }
    func makeIterator() -> IndexingIterator<[T]> {
        return items.makeIterator()
    }
}

extension TestSequence: ExpressibleByArrayLiteral {
    init(arrayLiteral elements: T...) {
        self.init(elements)
    }

}

#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)
    public protocol XCTestCaseProvider {
        var allTests: [(String, () throws -> Void)] { get }
    }
#endif
