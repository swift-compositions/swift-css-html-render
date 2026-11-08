public import W3C_CSS_Shared

public struct RawProperty<PropertyType: W3C_CSS_Shared::Property>: W3C_CSS_Shared::Property {
    public let value: String

    public init(_ value: String) {
        self.value = value
    }
}

extension RawProperty {

    public static var property: String {
        PropertyType.property
    }

    public var description: String {
        value
    }

    public static func global(_ global: Global) -> Self {
        Self(global.description)
    }
}
