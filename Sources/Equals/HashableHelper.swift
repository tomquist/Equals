/// Internal helper to support hashable implementations.
struct HashableHelper<T>: HashesType {
    
    typealias Hasher = (T) -> Int
    private var hashers = [Hasher]()
    
    let constant: Int
    let initial: Int
    init(constant: Int, initial: Int) {
        self.constant = constant
        self.initial = initial
    }
    
    mutating func append(_ hasher: @escaping Hasher) {
        self.hashers.append(hasher)
    }
    
    func hashValue(_ value: T) -> Int {
        return hashers.reduce(initial) {
            return $0.0 &* constant &+ $0.1(value)
        }
    }
}

// MARK: Hashable
extension HashableHelper {
    mutating func append<E: Hashable>(_ property: @escaping (T) -> E) {
        append { property($0).hashValue }
    }

}

// MARK: Optional<Hashable>
extension HashableHelper {
    mutating func append<E: Hashable>(_ property: @escaping (T) -> E?) {
        let copy = self
        append {
            if let v = property($0) {
                return copy.initial &* copy.constant &+ v.hashValue
            }
            return 0
        }
    }
}
// MARK: SequenceType<Hashable>
extension HashableHelper {
    mutating func append<E: Sequence>(_ property: @escaping (T) -> E) where E.Iterator.Element: Hashable {
        let copy = self
        append {
            return property($0).reduce(copy.initial) {
                return $0.0 &* copy.constant &+ $0.1.hashValue
            }
        }
    }
}
