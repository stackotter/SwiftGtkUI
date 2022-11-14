/// A button view.
public struct TextField: View {
    /// The label to show when the field is empty.
    public var placeholder: String
    /// Storage for the field's content.
    public var value: Binding<String>?

    public var body = EmptyViewContent()

    /// Creates a new button.
    public init(_ placeholder: String = "", _ value: Binding<String>? = nil) {
        self.placeholder = placeholder
        self.value = value
    }

    public func asWidget(_ children: EmptyViewContent.Children) -> GtkEntry {
        let widget = GtkEntry()
        widget.placeholder = placeholder
        widget.changed = { widget in
            self.value?.wrappedValue = widget.text
        }
        return widget
    }

    public func update(_ widget: GtkEntry, children: EmptyViewContent.Children) {
        // TODO: Fix code duplication between asWidget and update for all views
        widget.placeholder = placeholder
        widget.text = value?.wrappedValue ?? widget.text
        widget.changed = { widget in
            self.value?.wrappedValue = widget.text
        }
    }
}
