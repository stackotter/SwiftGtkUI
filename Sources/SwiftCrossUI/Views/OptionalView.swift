/// A view used by ``ViewBuilder`` to support non-exhaustive if statements.
public struct OptionalView<V: View>: TypeSafeView, View {
    typealias Children = OptionalViewChildren<V>

    public var body = EmptyView()

    var view: V?

    /// Wraps an optional view.
    init(_ view: V?) {
        self.view = view
    }

    func children<Backend: AppBackend>(backend: Backend) -> OptionalViewChildren<V> {
        return OptionalViewChildren(from: view, backend: backend)
    }

    func updateChildren<Backend: AppBackend>(
        _ children: OptionalViewChildren<V>, backend: Backend
    ) {
        children.update(with: view, backend: backend)
    }

    func asWidget<Backend: AppBackend>(
        _ children: OptionalViewChildren<V>, backend: Backend
    ) -> Backend.Widget {
        let container = backend.createSingleChildContainer()
        backend.setChild(ofSingleChildContainer: container, to: children.widget(for: backend))
        return container
    }

    func update<Backend: AppBackend>(
        _ widget: Backend.Widget, children: OptionalViewChildren<V>, backend: Backend
    ) {
        if children.hasToggled {
            backend.setChild(ofSingleChildContainer: widget, to: children.widget(for: backend))
        }
    }
}

/// Stores a view graph node for the view's child if present. Tracks whether
/// the child has toggled since last time the parent was updated or not.
class OptionalViewChildren<V: View>: ViewGraphNodeChildren {
    /// The view graph node for the view's child if present.
    var node: AnyViewGraphNode<V>?
    /// Whether the view's child has toggled between visible/not-visible (or vice versa)
    /// since the last time the parent widget was updated.
    var hasToggled = true

    var widgets: [AnyWidget] {
        return [node?.widget].compactMap { $0 }
    }

    /// Creates storage for an optional view's child if present (which can change at
    /// any time).
    init<Backend: AppBackend>(from view: V?, backend: Backend) {
        if let view = view {
            node = AnyViewGraphNode(for: view, backend: backend)
        }
    }

    func widget<Backend: AppBackend>(for backend: Backend) -> Backend.Widget? {
        return node?.widget.into()
    }

    func update<Backend: AppBackend>(with view: V?, backend: Backend) {
        if let view = view {
            if let node = node {
                node.update(with: view)
                hasToggled = false
            } else {
                node = AnyViewGraphNode(for: view, backend: backend)
                hasToggled = true
            }
        } else {
            hasToggled = node != nil
            node = nil
        }
    }
}
