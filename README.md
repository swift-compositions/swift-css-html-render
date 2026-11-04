# swift-css-html-render

Use this package when you style HTML views from Swift and want each CSS property to take only the values its W3C module allows. Call `.css` on any `HTML.View` to get an `HTML.CSS<Base>`, then chain property methods on it. For stacks, spacers and grids use swift-css-html-layout-render. For themes and light and dark color pairs use swift-css. For the whole HTML stack in one import use swift-html.

## Laws

- `.css` on its own changes nothing. An `HTML.CSS<Base>` renders exactly as its base view.
- Each property method adds one declaration, written as `name:value` with no space. Passing nil adds nothing and leaves the other declarations in the chain as they were.
- Rendered in an `HTML.Document`, the declarations end up in the document's `<style>` element.
- `HTML.CSS.inlineStyle(_:_:)` writes its name and value as given, without checking them. A nil value adds nothing.
- `HTML.View.inlineStyle(_:_:)` with a property type and a global keyword, such as `inherit`, writes that keyword as the property's value.
- The media modifiers, such as `HTML.CSS.dark(_:)` and `HTML.CSS.print(_:)`, the pseudo-class modifiers, such as `HTML.CSS.hover(_:)`, and `HTML.CSS.selector(_:_:)` apply to the declarations made inside their closure. A modifier inside another adds to the enclosing context instead of replacing it.
- The forms of `dark`, `light`, `hover`, `focus` and `active` that take a property value repeat the property set just before them, with that value, under the new condition. So setting a background color and then calling `dark` with another one gives the first color normally and the second in dark mode.
