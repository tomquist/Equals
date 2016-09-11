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

// MARK: Equatable
extension EquatableHelper {
    mutating func append<E: Equatable>(_ property: @escaping (T) -> E) {
        append { property($0) == property($1) }
    }
}
// MARK: Optional<Equatable>
extension EquatableHelper {
    mutating func append<E: Equatable>(_ property: @escaping (T) -> E?) {
        append { property($0) == property($1) }
    }
}
// MARK: SequenceType<Equatable>
extension EquatableHelper {
    mutating func append<E: Equatable, S: Sequence>(_ property: @escaping (T) -> S) where S.Iterator.Element == E {
        append { property($0) == property($1) }
    }
}
private func ==<E: Equatable, S: Sequence>(lhs: S, rhs: S) -> Bool where S.Iterator.Element == E {
    var gen1 = lhs.makeIterator()
    var gen2 = rhs.makeIterator()
    var a: E?
    var b: E?
    repeat {
        a = gen1.next()
        b = gen2.next()
        if a != b {
            return false
        }
    } while a != nil || b != nil
    return (a == nil && b == nil)
}

// MARK: CollectionType<Equatable>
extension EquatableHelper {
    mutating func append<E: Equatable, S: Collection>(_ property: @escaping (T) -> S) where S.Iterator.Element == E {
        append { property($0) == property($1) }
    }
}

private func ==<E: Equatable, S: Collection>(lhs: S, rhs: S) -> Bool where S.Iterator.Element == E {
    if lhs.count != rhs.count {
        return false
    }
    return !zip(lhs, rhs).contains { $0.0 != $0.1 }
}
