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
