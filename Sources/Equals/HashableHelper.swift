/// Internal helper to support hashable implementations.
struct HashableHelper<T>: HashesType {
    
    typealias Hasher = T -> Int
    private var hashers = [Hasher]()
    
    let constant: Int
    let initial: Int
    init(constant: Int, initial: Int) {
        self.constant = constant
        self.initial = initial
    }
    
    mutating func append(hasher: Hasher) {
        self.hashers.append(hasher)
    }
    
    func hashValue(value: T) -> Int {
        return hashers.reduce(initial) {
            return $0.0 &* constant &+ $0.1(value)
        }
    }
}

// MARK: Hashable
extension HashableHelper {
    mutating func append<E: Hashable>(property: T -> E) {
        append { property($0).hashValue }
    }

}

// MARK: Optional<Hashable>
extension HashableHelper {
    mutating func append<E: Hashable>(property: T -> E?) {
        append {
            if let v = property($0) {
                return self.initial &* self.constant &+ v.hashValue
            }
            return 0
        }
    }
}
// MARK: SequenceType<Hashable>
extension HashableHelper {
    mutating func append<E: SequenceType where E.Generator.Element: Hashable>(property: T -> E) {
        append {
            return property($0).reduce(self.initial) {
                return $0.0 &* self.constant &+ $0.1.hashValue
            }
        }
    }
}
