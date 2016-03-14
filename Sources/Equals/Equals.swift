/// Protocol for equatable helpers
public protocol EqualsType {
    typealias Value
    
    /// Returns `true`, if `lhs` is equal to `rhs`
    func equals(lhs: Value, _ rhs: Value) -> Bool
}
/// Protocol for hashable helpers
public protocol HashesType {
    typealias Value
    
    /// Calculates the hash value for the given value.
    func hashValue(value: Value) -> Int
}

/// Conform to this protocol to get an implementation of `==` for free.
public protocol EqualsEquatable: Equatable {
    typealias Equals: EqualsType
    
    /// Equals helper
    static var equals: Equals { get }
}
/// Conform to this protocol to get `Hashable` capabilities for free
public protocol EqualsHashable: EqualsEquatable, Hashable {
    typealias Hashes: HashesType
    
    /// Hashes helper for instance of types conforming to the `EqualsHashable` protocol
    static var hashes: Hashes { get }
}

/// This extension defined the default `equals` variable for types conforming to `EqualsHashable`.
public extension EqualsHashable where Hashes == Equals {
    /// By default returns the hashes variable
    static var equals: Equals {
        return hashes
    }
}

/// Generic equals function for types conforming to `EqualsEquatable`
public func ==<T: EqualsEquatable where T.Equals.Value == T>(lhs: T, rhs: T) -> Bool {
    return T.equals.equals(lhs, rhs)
}

/// Generic `hashValue` property implementation for types conforming to `EqualsHashable`
public extension EqualsHashable where Hashes.Value == Self {
    /// Calculates the hash value using the static `hashes` variable
    public var hashValue: Int {
        return Self.hashes.hashValue(self)
    }
}

/// Helper type to easily conform to the Equatable protocol.
public struct Equals<T> {
    public typealias Value = T
    private var helper = EquatableHelper<T>()
    
    /// Creates an empty equals helper
    public init() {}
    
    /// Returns a new equatability-helper containing the given `Equatable` property.
    public func append<E: Equatable>(equatable equatable: T -> E) -> Equals<T> {
        var ret = self; ret.helper.append(equatable); return ret
    }

    /// Returns a new equatability-helper containing the given optional `Equatable` property.
    public func append<E: Equatable>(optional optional: T -> E?) -> Equals<T> {
        var ret = self; ret.helper.append(optional); return ret
    }

    /// Returns a new equatability-helper containing the given sequence of `Equatable` property.
    public func append<E: Equatable, S: SequenceType where S.Generator.Element == E>(sequence sequence: T -> S) -> Equals<T> {
        var ret = self; ret.helper.append(sequence); return ret
    }

    /// Returns a new equatability-helper containing the given collection of `Equatable` property.
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
    
    /// Constant to use in building the hashValue.
    public var constant: Int {
        return hashableHelper.constant
    }
    
    /// Initial value to use in building the hashValue.
    public var initial: Int {
        return hashableHelper.initial
    }

    /// Initializes a new hashes helper.
    /// - Parameters:
    ///     - constant: Should be a non-zero, odd number used as the multiplier (e.g. 37)
    ///     - initial: Should be a non-zero, odd number used as the initial value (e.g. 17)
    public init(constant: Int = 37, initial: Int = 17) {
        hashableHelper = HashableHelper(constant: constant, initial: initial)
    }

    /// Returns a new hashing-helper containing the given `Hashable` property.
    public func append<E: Hashable>(hashable hashable: T -> E) -> Hashes<T> {
        var ret = self
        ret.equatableHelper.append(hashable)
        ret.hashableHelper.append(hashable)
        return ret
    }

    /// Returns a new hashing-helper containing the given optional `Hashable` property.
    public func append<E: Hashable>(optional optional: T -> E?) -> Hashes<T> {
        var ret = self
        ret.equatableHelper.append(optional)
        ret.hashableHelper.append(optional)
        return ret
    }

    /// Returns a new hashing-helper containing the given sequence of `Hashable` property.
    public func append<E: Hashable, S: SequenceType where S.Generator.Element == E>(sequence sequence: T -> S) -> Hashes<T> {
        var ret = self
        ret.equatableHelper.append(sequence)
        ret.hashableHelper.append(sequence)
        return ret
    }

    /// Returns a new hashing-helper containing the given collection of `Hashable` property.
    public func append<E: Hashable, S: CollectionType where S.Generator.Element == E>(collection collection: T -> S) -> Hashes<T> {
        var ret = self
        ret.equatableHelper.append(collection)
        ret.hashableHelper.append(collection)
        return ret
    }
}

extension Hashes: EqualsType {
    /// Returns `true`, if `lhs` is equal to `rhs`
    public func equals(lhs: Value, _ rhs: Value) -> Bool {
        return equatableHelper.equals(lhs, rhs)
    }
}
extension Hashes: HashesType {
    /// Calculates the hash value for the given value.
    public func hashValue(value: Value) -> Int {
        return hashableHelper.hashValue(value)
    }
}
