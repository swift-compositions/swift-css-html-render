public import CSS_Standard
public import HTML_Rendering_Core

extension HTML.CSS {
    @discardableResult
    @_disfavoredOverload
    public func accentColor(
        _ accentColor: W3C_CSS_UI.AccentColor?
    ) -> HTML.CSS<HTML.Styled<Base, W3C_CSS_UI.AccentColor>> {
        styled(accentColor)
    }
}
