public import HTML_Rendering

public struct HTMLForEach<Content: HTML.View>: HTML.View {

    let content: [Content]

    public init<Data: Swift.Sequence>(
        _ data: Data,
        @HTML.Builder content: (Data.Element) -> Content
    ) {
        self.content = HTML.Builder.buildArray(data.map(content))
    }
}

extension HTMLForEach {

    public var body: some HTML.View {
        content
    }
}
