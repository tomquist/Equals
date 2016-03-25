
public protocol DescribesType {
    typealias Value
    func describe(value: Value) -> String
}
public protocol EqualsStringDescribeable {
    typealias Describes: DescribesType
    static var describes: Describes { get }
}

public protocol EqualsDebugStringDescribeable {
    typealias Describes: DescribesType
    static var debugDescribes: Describes { get }
}

public protocol EqualsCustomStringConvertible: EqualsStringDescribeable, CustomStringConvertible {}
public protocol EqualsDebugStringConvertible: EqualsDebugStringDescribeable, CustomDebugStringConvertible {}

public extension EqualsDebugStringDescribeable where Self: EqualsStringDescribeable {
    public static var debugDescribes: Describes {
        return self.describes
    }
}

public extension EqualsCustomStringConvertible where Describes.Value == Self {
    var description: String {
        return Self.describes.describe(self)
    }
}

public extension EqualsDebugStringConvertible where Describes.Value == Self {
    var debugDescription: String {
        return Self.debugDescribes.describe(self)
    }
}

public struct Describes<T> {
    public typealias Value = T
    
    private var blocks: [(String, T -> String)] = []
    private let includeType: Bool
    private let includeFieldNames: Bool
    private let multiline: Bool
    private let typeName: String
    
    public init(includeType: Bool = true, typeName: String = String(T), includeFieldNames: Bool = true, multiline: Bool = false) {
        self.includeType = includeType
        self.includeFieldNames = includeFieldNames
        self.multiline = multiline
        self.typeName = typeName
    }
    
    public func append(name: String, optionalBlock: T -> String?) -> Describes<T> {
        var ret = self
        ret.blocks.append((name, {
            guard let value = optionalBlock($0) else {
                return "nil"
            }
            return value
        }))
        return ret
    }
    
    public func append<S: CustomStringConvertible>(name: String, stringConvertible: T -> S?) -> Describes<T> {
        return append(name, optionalBlock: { stringConvertible($0)?.description })
    }
    
}

extension Describes: DescribesType {
    public func describe(value: T) -> String {
        let separator = multiline ? (includeType ? "\n  " : "\n") : ","
        let fields = blocks.lazy.map { (name, block) -> String in
            let fieldValue = block(value)
            return self.includeFieldNames ? "\(name)=\(fieldValue)" : fieldValue
        }.joinWithSeparator(separator)
        let prefix = multiline ? "[\n  " : "["
        let suffix = multiline ? "\n]" : "]"
        return includeType ? "\(typeName)\(prefix)\(fields)\(suffix)" : fields
    }
}
