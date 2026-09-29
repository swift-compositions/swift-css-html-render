public import CSS_Standard
public import HTML_Rendering_Core

extension HTML {
    public struct CSS<Base: HTML.View>: HTML.View {
        public let base: Base

        @inlinable
        public init(base: Base) {
            self.base = base
        }

        @inlinable
        public var body: Base {
            base
        }
    }
}

public enum CSS {

    @resultBuilder
    public enum Builder {

        @inlinable
        public static func buildExpression<T>(_ expression: T) -> T {
            expression
        }

        @inlinable
        public static func buildBlock<Content>(_ content: Content) -> Content {
            content
        }

        @inlinable
        public static func buildBlock<each Content>(
            _ content: repeat each Content
        ) -> Renderer.Document._Tuple<repeat each Content> {
            Renderer.Document._Tuple(repeat each content)
        }

        @inlinable
        public static func buildEither<First, Second>(
            first component: First
        ) -> Renderer.Document.Conditional<First, Second> {
            .first(component)
        }

        @inlinable
        public static func buildEither<First, Second>(
            second component: Second
        ) -> Renderer.Document.Conditional<First, Second> {
            .second(component)
        }

        @inlinable
        public static func buildOptional<T>(_ component: T?) -> T? {
            component
        }

        @inlinable
        public static func buildArray<Element>(_ components: [Element]) -> [Element] {
            components
        }

        @inlinable
        public static func buildFinalResult<Content: HTML.View>(
            _ component: Content
        ) -> HTML.CSS<Content> {
            HTML.CSS<Content>(base: component)
        }
    }
}

extension HTML.CSS: Sendable where Base: Sendable {}

@inlinable
public func cssBuilder<Content: HTML.View>(
    @HTML.Builder _ content: () -> Content
) -> HTML.CSS<Content> {
    HTML.CSS<Content>(base: content())
}

extension HTML.CSS {

    @inlinable
    package func styled<P: W3C_CSS_Shared.Property>(
        _ property: P?
    ) -> HTML.CSS<HTML.Styled<Base, P>> {
        HTML.CSS<HTML.Styled<Base, P>>(base: base.inlineStyle(property))
    }

    @inlinable
    @discardableResult
    @CSS.Builder
    public func inlineStyle(
        _ property: String,
        _ value: String?
    ) -> HTML.CSS<some HTML.View> {
        if let value {
            HTML.CSS<HTML.Styled<Base, StringProperty>>(
                base: base.inlineStyle(StringProperty(property, value))
            )
        } else {
            base
        }

    }
}

extension HTML.View {

    @inlinable
    public var css: HTML.CSS<Self> {
        HTML.CSS(base: self)
    }
}
