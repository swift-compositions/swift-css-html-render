public import W3C_CSS_Shared

public struct StringProperty: W3C_CSS_Shared::Property {
    public let name: String
    public let value: String

    @inlinable
    public init(_ name: String, _ value: String) {
        self.name = name
        self.value = value
    }
}

extension StringProperty {
    public static var property: String { "" }

    @inlinable
    public static func global(_ global: Global) -> StringProperty {
        StringProperty("", global.rawValue)
    }

    @inlinable
    public var description: String {
        value
    }

    @inlinable
    public var declaration: Declaration {
        Declaration(description: "\(name):\(value)")
    }
}
