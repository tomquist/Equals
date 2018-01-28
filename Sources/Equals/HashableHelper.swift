/// Helper which contains the property
private struct PropertyHasher<T, E> {
    
    private let property: (T) -> E
    private let hasher: (E) -> Int
    
    fileprivate init(_ property: @escaping (T) -> E, _ hasher: @escaping (E) -> Int) {
        self.property = property
        self.hasher = hasher
    }
    
    fileprivate func hashValue(_ value: T) -> Int {
        return hasher(property(value))
    }
}

private struct AnyPropertyHasher<T> {

    fileprivate let hasher: (T) -> Int
    fileprivate init<E>(_ property: @escaping (T) -> E, _ hasher: @escaping (E) -> Int) {
        self.hasher = PropertyHasher(property, hasher).hashValue
    }
}

/// Internal helper to support hashable implementations.
struct HashableHelper<T>: HashesType {
    
    private var hashers = [AnyPropertyHasher<T>]()
    
    let constant: Int
    let initial: Int
    init(constant: Int, initial: Int) {
        self.constant = constant
        self.initial = initial
    }
    
    mutating func append<E>(_ property: @escaping (T) -> E, hasher: @escaping (E) -> Int) {
        hashers.append(AnyPropertyHasher(property, hasher))
    }
    
    func hashValue(_ value: T) -> Int {
        return hashers.reduce(initial) {
            return $0 &* constant &+ $1.hasher(value)
        }
    }
}

fileprivate extension Hashable {
    fileprivate static func getHashValue(value: Self) -> Int {
        return value.hashValue
    }
}

fileprivate extension Optional where Wrapped: Hashable {
    fileprivate static func getHashValue(value: Optional<Wrapped>) -> Int {
        if let value = value {
            return value.hashValue
        }
        return 0
    }
}

fileprivate extension Collection where Iterator.Element: Hashable {
    fileprivate static func getHashValue(initial: Int, constant: Int) -> (Self) -> Int {
        return {
            return $0.reduce(initial) {
                return $0 &* constant &+ $1.hashValue
            }
        }
    }
}

// MARK: Hashable
extension HashableHelper {
    mutating func append<E: Hashable>(_ property: @escaping (T) -> E) {
        append(property, hasher: E.getHashValue)
    }

}

// MARK: Optional<Hashable>
extension HashableHelper {
    mutating func append<E: Hashable>(_ property: @escaping (T) -> E?) {
        append(property, hasher: Optional<E>.getHashValue)
    }
}

// MARK: Collection<Hashable>
extension HashableHelper {
    mutating func append<E: Collection>(_ property: @escaping (T) -> E) where E.Iterator.Element: Hashable {
        append(property, hasher: E.getHashValue(initial: initial, constant: constant))
    }
}

