public import W3C_CSS_Shared

public struct GlobalProperty<PropertyType: W3C_CSS_Shared::Property>: W3C_CSS_Shared::Property {
    public let global: Global

    public init(_ global: Global) {
        self.global = global
    }
}

extension GlobalProperty {

    public static var property: String {
        PropertyType.property
    }

    public var description: String {
        global.description
    }

    public static func global(_ global: Global) -> Self {
        Self(global)
    }
}
