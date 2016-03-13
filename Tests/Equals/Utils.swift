struct Sequence<T>: SequenceType {
    private let items: [T]
    init(_ items: [T]) {
        self.items = items
    }
    func generate() -> IndexingGenerator<[T]> {
        return items.generate()
    }
}

extension Sequence: ArrayLiteralConvertible {
    init(arrayLiteral elements: T...) {
        self.init(elements)
    }

}

#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)
    public protocol XCTestCaseProvider {
        var allTests: [(String, () throws -> Void)] { get }
    }
#endif
