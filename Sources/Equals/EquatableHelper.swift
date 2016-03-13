/// Internal helper to support equatable implementations.
struct EquatableHelper<T>: EqualsType {
    
    typealias EqualsBlock = (T, T) -> Bool
    private var blocks = [EqualsBlock]()
    
    mutating func append(equals: EqualsBlock) {
        blocks.append(equals)
    }
    func equals(lhs: T, _ rhs: T) -> Bool {
        return !blocks.contains { !$0(lhs, rhs) }
    }
}

// MARK: Equatable
extension EquatableHelper {
    mutating func append<E: Equatable>(property: T -> E) {
        append { property($0) == property($1) }
    }
}
// MARK: Optional<Equatable>
extension EquatableHelper {
    mutating func append<E: Equatable>(property: T -> E?) {
        append { property($0) == property($1) }
    }
}
// MARK: SequenceType<Equatable>
extension EquatableHelper {
    mutating func append<E: Equatable, S: SequenceType where S.Generator.Element == E>(property: T -> S) {
        append { property($0) == property($1) }
    }
}
private func ==<E: Equatable, S: SequenceType where S.Generator.Element == E>(lhs: S, rhs: S) -> Bool {
    var gen1 = lhs.generate()
    var gen2 = rhs.generate()
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
    mutating func append<E: Equatable, S: CollectionType where S.Generator.Element == E>(property: T -> S) {
        append { property($0) == property($1) }
    }
}

private func ==<E: Equatable, S: CollectionType where S.Generator.Element == E>(lhs: S, rhs: S) -> Bool {
    if lhs.count != rhs.count {
        return false
    }
    return !zip(lhs, rhs).contains { $0.0 != $0.1 }
}