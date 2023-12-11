/// A view that arranges its subviews vertically.
public struct VStack<Content: View>: View {
    public var body: Content

    /// The amount of spacing to apply between children.
    private var spacing: Int

    /// Creates a horizontal stack with the given spacing.
    public init(spacing: Int = 8, @ViewBuilder _ content: () -> Content) {
        body = content()
        self.spacing = spacing
    }

    public func asWidget<Backend: AppBackend>(
        _ children: any ViewGraphNodeChildren,
        backend: Backend
    ) -> Backend.Widget {
        let vStack = backend.createVStack()
        backend.addChildren(children.widgets(for: backend), toVStack: vStack)
        return vStack
    }

    public func update<Backend: AppBackend>(
        _ widget: Backend.Widget, children: any ViewGraphNodeChildren, backend: Backend
    ) {
        backend.setSpacing(ofVStack: widget, to: spacing)
    }
}
