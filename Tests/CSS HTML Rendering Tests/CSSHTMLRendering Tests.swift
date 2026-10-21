import CSS_HTML_Rendering_Test_Support
import Testing

@testable import CSS_HTML_Rendering

@Suite
struct `Unit Tests` {

    @Suite
    struct `CSS Accessor` {
        @Test
        func `css accessor wraps base view in HTML.CSS`() {
            let element = tag("div")
            let wrapped = element.css
            #expect(type(of: wrapped) == HTML.CSS<HTML.Tag.Element<HTML.Empty>>.self)
        }

        @Test
        func `css accessor preserves base view identity`() throws {
            let element = tag("div")
            let wrapped = element.css
            let baseHTML = try String(wrapped.base)
            let originalHTML = try String(element)
            #expect(baseHTML == originalHTML)
        }
    }

    @Suite
    struct `Property Application` {
        @Test
        func `backgroundColor renders background-color declaration`() throws {
            let html = try String(
                HTML.Document { tag("div").css.backgroundColor(.color(.named(.red))) }
            )
            #expect(html.contains("background-color"))
            #expect(html.contains("red"))
        }

        @Test
        func `color renders color declaration`() throws {
            let html = try String(
                HTML.Document { tag("div").css.color(.named(.blue)) }
            )
            #expect(html.contains("color"))
            #expect(html.contains("blue"))
        }

        @Test
        func `display renders display declaration`() throws {
            let html = try String(
                HTML.Document { tag("div").css.display(.flex) }
            )
            #expect(html.contains("display"))
            #expect(html.contains("flex"))
        }

        @Test
        func `position renders position declaration`() throws {
            let html = try String(
                HTML.Document { tag("div").css.position(.relative) }
            )
            #expect(html.contains("position"))
            #expect(html.contains("relative"))
        }

        @Test
        func `width renders width declaration`() throws {
            let html = try String(
                HTML.Document { tag("div").css.width(.px(100)) }
            )
            #expect(html.contains("width"))
            #expect(html.contains("100px"))
        }

        @Test
        func `padding renders padding declaration`() throws {
            let html = try String(
                HTML.Document { tag("div").css.padding(.px(16)) }
            )
            #expect(html.contains("padding"))
            #expect(html.contains("16px"))
        }

        @Test
        func `margin renders margin declaration`() throws {
            let html = try String(
                HTML.Document { tag("div").css.margin(.px(8)) }
            )
            #expect(html.contains("margin"))
            #expect(html.contains("8px"))
        }
    }

    @Suite
    struct `Property Chaining` {
        @Test
        func `chaining two properties preserves both`() throws {
            let html = try String(
                HTML.Document {
                    tag("div").css
                        .backgroundColor(.color(.named(.red)))
                        .color(.named(.white))
                }
            )
            #expect(html.contains("background-color"))
            #expect(html.contains("color"))
        }

        @Test
        func `chaining five properties renders all`() throws {
            let html = try String(
                HTML.Document {
                    tag("div").css
                        .display(.flex)
                        .flexDirection(.column)
                        .padding(.px(16))
                        .margin(.px(8))
                        .width(.percent(100))
                }
            )
            #expect(html.contains("display"))
            #expect(html.contains("flex-direction"))
            #expect(html.contains("padding"))
            #expect(html.contains("margin"))
            #expect(html.contains("width"))
        }

        @Test
        func `chained result conforms to HTML.View`() throws {
            let styled = tag("div").css
                .backgroundColor(.color(.named(.red)))
                .color(.named(.white))

            let html = try String(HTML.Document { styled })
            #expect(!html.isEmpty)
        }
    }

    @Suite
    struct `Nil Handling` {
        @Test
        func `nil property value produces no CSS declaration`() throws {
            let styled = tag("div").css.backgroundColor(nil)
            let html = try String(HTML.Document { styled })
            #expect(!html.contains("background-color"))
        }

        @Test
        func `nil in chain does not affect other properties`() throws {
            let styled = tag("div").css
                .backgroundColor(.color(.named(.red)))
                .color(nil)

            let html = try String(HTML.Document { styled })
            #expect(html.contains("background-color"))
        }
    }

    @Suite
    struct `String Based Inline Style` {
        @Test
        func `inlineStyle with string property and value renders correctly`() throws {
            let html = try String(
                HTML.Document {
                    tag("div").css
                        .inlineStyle("custom-property", "custom-value")
                }
            )
            #expect(html.contains("custom-property"))
            #expect(html.contains("custom-value"))
        }

        @Test
        func `inlineStyle with nil value produces no declaration`() throws {
            let html = try String(
                HTML.Document {
                    tag("div").css
                        .inlineStyle("custom-property", nil)
                }
            )
            #expect(!html.contains("custom-property"))
        }
    }

    @Suite
    struct `View Conformance` {
        @Test
        func `HTML.CSS body returns base`() {
            let element = tag("div")
            let css = HTML.CSS(base: element)
            #expect(type(of: css.body) == type(of: element))
        }

        @Test
        func `HTML.CSS is Sendable when base is Sendable`() {
            let element = tag("div")
            let css = element.css

            let _: any Sendable = css
        }
    }
}

@Suite
struct `Edge Case Tests` {

    @Test
    func `deeply chained properties compile and render`() throws {
        let html = try String(
            HTML.Document {
                tag("div").css
                    .display(.flex)
                    .flexDirection(.row)
                    .justifyContent(.center)
                    .alignItems(.center)
                    .backgroundColor(.color(.named(.white)))
                    .color(.named(.black))
                    .padding(.px(16))
                    .margin(.px(0))
            }
        )
        #expect(html.contains("<div"))
        #expect(html.contains("display"))
        #expect(html.contains("flex-direction"))
        #expect(html.contains("justify-content"))
        #expect(html.contains("align-items"))
    }

    @Test
    func `css on content-bearing element preserves content`() throws {
        let html = try String(
            HTML.Document {
                tag("div") { tag("span") }.css
                    .backgroundColor(.color(.named(.red)))
            }
        )
        #expect(html.contains("<span"))
        #expect(html.contains("<div"))
    }

    @Test
    func `StringProperty description returns value`() {
        let prop = StringProperty("font-size", "16px")
        #expect(prop.description == "16px")
    }

    @Test
    func `StringProperty declaration includes name and value`() {
        let prop = StringProperty("font-size", "16px")
        #expect(prop.declaration.description == "font-size:16px")
    }

    @Test
    func `global StringProperty creates correct value`() {
        let prop = StringProperty.global(.inherit)
        #expect(prop.description == "inherit")
    }
}

@Suite
struct `Integration Tests` {

    @Test
    func `styled element renders as complete HTML document`() throws {
        let html = try String(
            HTML.Document {
                tag("div").css
                    .backgroundColor(.color(.named(.red)))
            }
        )
        #expect(html.contains("<!doctype html>"))
        #expect(html.contains("<html>"))
        #expect(html.contains("<head>"))
        #expect(html.contains("<style>"))
        #expect(html.contains("background-color"))
        #expect(html.contains("<div"))
    }

    @Test
    func `multiple styled elements in same document`() throws {
        let html = try String(
            HTML.Document {
                tag("div").css.backgroundColor(.color(.named(.red)))
                tag("span").css.color(.named(.blue))
            }
        )
        #expect(html.contains("background-color"))
        #expect(html.contains("color"))
        #expect(html.contains("<div"))
        #expect(html.contains("<span"))
    }

    @Test
    func `flexbox layout pattern renders correctly`() throws {
        let html = try String(
            HTML.Document {
                tag("div").css
                    .display(.flex)
                    .flexDirection(.column)
                    .alignItems(.center)
                    .justifyContent(.spaceBetween)
            }
        )
        #expect(html.contains("display:flex"))
        #expect(html.contains("flex-direction:column"))
        #expect(html.contains("align-items:center"))
        #expect(html.contains("justify-content:space-between"))
    }

    @Test
    func `box model properties render correctly`() throws {
        let html = try String(
            HTML.Document {
                tag("div").css
                    .width(.px(200))
                    .height(.px(100))
                    .padding(.px(16))
                    .margin(.px(8))
            }
        )
        #expect(html.contains("width:200px"))
        #expect(html.contains("height:100px"))
        #expect(html.contains("padding:16px"))
        #expect(html.contains("margin:8px"))
    }

    @Test
    func `typography properties render correctly`() throws {
        let html = try String(
            HTML.Document {
                tag("p").css
                    .fontSize(.rem(1.5))
                    .fontWeight(.bold)
                    .textAlign(.center)
            }
        )
        #expect(html.contains("font-size:1.5rem"))
        #expect(html.contains("font-weight:bold"))
        #expect(html.contains("text-align:center"))
    }

    @Test
    func `context modifier dark mode renders media query`() throws {
        let html = try String(
            HTML.Document {
                tag("div").css.dark { $0.backgroundColor(.color(.named(.black))) }
            }
        )
        #expect(html.contains("prefers-color-scheme"))
        #expect(html.contains("dark"))
        #expect(html.contains("background-color"))
    }

    @Test
    func `context modifier hover renders pseudo-class`() throws {
        let html = try String(
            HTML.Document {
                tag("div").css.hover { $0.color(.named(.red)) }
            }
        )
        #expect(html.contains(":hover"))
        #expect(html.contains("color"))
    }

    @Test
    func `context modifier print renders media query`() throws {
        let html = try String(
            HTML.Document {
                tag("div").css.print { $0.backgroundColor(.color(.named(.white))) }
            }
        )
        #expect(html.contains("@media print"))
        #expect(html.contains("background-color"))
    }

    @Test
    func `context modifier selector renders custom selector`() throws {
        let html = try String(
            HTML.Document {
                tag("div").css.selector("my-component") { $0.color(.named(.red)) }
            }
        )
        #expect(html.contains("my-component"))
        #expect(html.contains("color"))
    }
}

@Suite
struct `Performance Tests` {

    @Test
    func `single property rendering completes in reasonable time`() throws {
        for _ in 0..<100 {
            _ = try String(
                HTML.Document {
                    tag("div").css.backgroundColor(.color(.named(.red)))
                }
            )
        }
    }

    @Test
    func `chained property rendering completes in reasonable time`() throws {
        for _ in 0..<100 {
            _ = try String(
                HTML.Document {
                    tag("div").css
                        .display(.flex)
                        .backgroundColor(.color(.named(.white)))
                        .color(.named(.black))
                        .padding(.px(16))
                        .margin(.px(8))
                }
            )
        }
    }
}
