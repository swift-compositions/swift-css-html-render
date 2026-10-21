import CSS_HTML_Rendering_Test_Support

extension `Snapshot Tests` {
    @Suite
    struct `InlineStyle Tests` {
        @Test
        func `HTML element renders with string-based inline style`() throws {
            snapshot(
                as: .html
            ) {
                HTML.Document {
                    div.css
                        .inlineStyle("grid-template-columns", "1fr 1fr 1fr")
                }
            }
        }

        @Test
        func `HTML element renders with nil string-based inline style producing no output`() throws {
            snapshot(
                as: .html
            ) {
                HTML.Document {
                    div.css
                        .inlineStyle("custom-property", nil)
                }
            }
        }

        @Test
        func `HTML element renders with mixed typed and string properties`() throws {
            snapshot(
                as: .html
            ) {
                HTML.Document {
                    div.css
                        .display(.flex)
                        .inlineStyle("gap", "16px")
                }
            }
        }
    }
}
