/// Protocol for equatable helpers
public protocol EqualsType {
    typealias Value
    
    // Returns true, if lhs is equal to rhs
    func equals(lhs: Value, _ rhs: Value) -> Bool
}
/// Protocol for hashable helpers
public protocol HashesType {
    typealias Value
    
    /// Calculated the hash value for the given value.
    func hashValue(value: Value) -> Int
}

/// Conform to this protocol to get an implementation of == for free.
public protocol EqualsEquatable: Equatable {
    typealias Equals: EqualsType
    
    /// Equals helper
    static var equals: Equals { get }
}
/// Conform to this protocol to gen an implementation of Hashable for free
public protocol EqualsHashable: EqualsEquatable, Hashable {
    typealias Hashes: HashesType
    
    /// Hashes helper
    static var hashes: Hashes { get }
}

/// This extension defined the default equals variable for types conforming to EqualsHashable.
public extension EqualsHashable where Hashes == Equals {
    static var equals: Equals {
        return hashes
    }
}

/// Generic equals function for types conforming to EqualsEquatable
public func ==<T: EqualsEquatable where T.Equals.Value == T>(lhs: T, rhs: T) -> Bool {
    return T.equals.equals(lhs, rhs)
}

/// Generic hashValue property implementation for types conforming to EqualsHashable
public extension EqualsHashable where Hashes.Value == Self {
    public var hashValue: Int {
        return Self.hashes.hashValue(self)
    }
}

/// Helper type to easily conform to the Equatable protocol.
public struct Equals<T> {
    public typealias Value = T
    private var helper = EquatableHelper<T>()
    
    public init() {}
    
    /// Returns a new equatability-helper containing the given equatable property.
    public func append<E: Equatable>(equatable equatable: T -> E) -> Equals<T> {
        var ret = self; ret.helper.append(equatable); return ret
    }

    /// Returns a new equatability-helper containing the given optional equatable property.
    public func append<E: Equatable>(optional optional: T -> E?) -> Equals<T> {
        var ret = self; ret.helper.append(optional); return ret
    }

    /// Returns a new equatability-helper containing the given sequence of equatable property.
    public func append<E: Equatable, S: SequenceType where S.Generator.Element == E>(sequence sequence: T -> S) -> Equals<T> {
        var ret = self; ret.helper.append(sequence); return ret
    }

    /// Returns a new equatability-helper containing the given collection of equatable property.
    public func append<E: Equatable, S: CollectionType where S.Generator.Element == E>(collection collection: T -> S) -> Equals<T> {
        var ret = self; ret.helper.append(collection); return ret
    }

}

extension Equals: EqualsType {
    /// Returns true, if lhs is equal to rhs
    public func equals(lhs: Value, _ rhs: Value) -> Bool {
        return helper.equals(lhs, rhs)
    }
}

/// Helper type to easily conform to the Hashable protocol.
public struct Hashes<T> {
    public typealias Value = T
    private var equatableHelper = EquatableHelper<T>()
    private var hashableHelper: HashableHelper<T>

    public init(constant: Int = 37, initial: Int = 17) {
        hashableHelper = HashableHelper(constant: 37, initial: 17)
    }

    /// Returns a new hashing-helper containing the given hashable property.
    public func append<E: Hashable>(hashable hashable: T -> E) -> Hashes<T> {
        var ret = self
        ret.equatableHelper.append(hashable)
        ret.hashableHelper.append(hashable)
        return ret
    }

    /// Returns a new hashing-helper containing the given optional hashable property.
    public func append<E: Hashable>(optional optional: T -> E?) -> Hashes<T> {
        var ret = self
        ret.equatableHelper.append(optional)
        ret.hashableHelper.append(optional)
        return ret
    }

    /// Returns a new hashing-helper containing the given optional sequence of hashable property.
    public func append<E: Hashable, S: SequenceType where S.Generator.Element == E>(sequence sequence: T -> S) -> Hashes<T> {
        var ret = self
        ret.equatableHelper.append(sequence)
        ret.hashableHelper.append(sequence)
        return ret
    }

    /// Returns a new hashing-helper containing the given optional collection of hashable property.
    public func append<E: Hashable, S: CollectionType where S.Generator.Element == E>(collection collection: T -> S) -> Hashes<T> {
        var ret = self
        ret.equatableHelper.append(collection)
        ret.hashableHelper.append(collection)
        return ret
    }
}

extension Hashes: EqualsType {
    public func equals(lhs: Value, _ rhs: Value) -> Bool {
        return equatableHelper.equals(lhs, rhs)
    }
}
extension Hashes: HashesType {
    public func hashValue(value: Value) -> Int {
        return hashableHelper.hashValue(value)
    }
}
