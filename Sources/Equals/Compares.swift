
public enum ComparisonResult: Int {
    case Equal = 0
    case Less = -1
    case Greater = 1
}
public protocol ComparesType {
    typealias Value
    func compare(lhs: Value, _ rhs: Value) -> ComparisonResult
}

public protocol EqualsComparable: Comparable {
    typealias Compares: ComparesType
    static var compares: Compares { get }
}
public func <<T: EqualsComparable where T.Compares.Value == T>(lhs: T, rhs: T) -> Bool {
    switch T.compares.compare(lhs, rhs) {
    case .Less: return true
    default: return false
    }
}
public func ><T: EqualsComparable where T.Compares.Value == T>(lhs: T, rhs: T) -> Bool {
    switch T.compares.compare(lhs, rhs) {
    case .Greater: return true
    default: return false
    }
}
public func <=<T: EqualsComparable where T.Compares.Value == T>(lhs: T, rhs: T) -> Bool {
    switch T.compares.compare(lhs, rhs) {
    case .Less, .Equal: return true
    default: return false
    }
}
public func >=<T: EqualsComparable where T.Compares.Value == T>(lhs: T, rhs: T) -> Bool {
    switch T.compares.compare(lhs, rhs) {
    case .Greater, .Equal: return true
    default: return false
    }
}

public struct Compares<T> {
    private var blocks: [(T, T) -> ComparisonResult] = []
    
    public init() {}
    
    public func append(block: (T, T) -> ComparisonResult) -> Compares<T> {
        var ret = self
        ret.blocks.append(block)
        return ret
    }
    
    public func append<C: Comparable>(comparable: T -> C) -> Compares<T> {
        return append {
            let lhs = comparable($0)
            let rhs = comparable($1)
            if lhs < rhs {
                return .Less
            } else if lhs > rhs {
                return .Greater
            } else {
                return .Equal
            }
        }
    }
}

extension Compares: ComparesType {
    public func compare(lhs: T, _ rhs: T) -> ComparisonResult {
        for block in blocks {
            let result = block(lhs, rhs)
            if result != .Equal {
                return result
            }
        }
        return .Equal
    }
}
