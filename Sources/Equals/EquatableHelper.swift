/// Internal helper to support equatable implementations.
struct EquatableHelper<T>: EqualsType {
    
    typealias EqualsBlock = (T, T) -> Bool
    fileprivate var blocks = [EqualsBlock]()
    
    mutating func append(_ equals: @escaping EqualsBlock) {
        blocks.append(equals)
    }
    func equals(_ lhs: T, _ rhs: T) -> Bool {
        return !blocks.contains { !$0(lhs, rhs) }
    }
}

// MARK: Any
extension EquatableHelper {
    mutating func append<E>(_ property: @escaping (T) -> E, equals: @escaping (E, E) -> Bool) {
        append { equals(property($0), property($1)) }
    }
}
// MARK: Equatable
extension EquatableHelper {
    mutating func append<E: Equatable>(_ property: @escaping (T) -> E) {
        append(property, equals: ==)
    }
}
// MARK: Optional<Equatable>
extension EquatableHelper {
    mutating func append<E: Equatable>(_ property: @escaping (T) -> E?) {
        append(property, equals: ==)
    }
}

// MARK: CollectionType<Equatable>
extension EquatableHelper {
    mutating func append<E: Equatable, S: Collection>(_ property: @escaping (T) -> S) where S.Iterator.Element == E {
        append(property, equals: ==)
    }
}

private func ==<E: Equatable, S: Collection>(lhs: S, rhs: S) -> Bool where S.Iterator.Element == E {
    if lhs.count != rhs.count {
        return false
    }
    return !zip(lhs, rhs).contains { $0.0 != $0.1 }
}
