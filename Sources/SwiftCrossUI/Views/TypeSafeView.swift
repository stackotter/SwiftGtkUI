/// A complimentary protocol for ``View`` to make implementing views more
/// type-safe without leaking the `Children` associated type to users
/// (otherwise they would need to provide a `Children` associated type for
/// every view they made).
protocol TypeSafeView: View {
    associatedtype Children: ViewGraphNodeChildren

    func children<Backend: AppBackend>(backend: Backend) -> Children

    func updateChildren<Backend: AppBackend>(
        _ children: Children, backend: Backend
    )

    func asWidget<Backend: AppBackend>(
        _ children: Children,
        backend: Backend
    ) -> Backend.Widget

    func update<Backend: AppBackend>(
        _ widget: Backend.Widget,
        children: Children,
        backend: Backend
    )
}

extension TypeSafeView {
    public func children<Backend: AppBackend>(backend: Backend) -> any ViewGraphNodeChildren {
        let children: Children = children(backend: backend)
        return children
    }

    public func updateChildren<Backend: AppBackend>(
        _ children: any ViewGraphNodeChildren, backend: Backend
    ) {
        updateChildren(children as! Children, backend: backend)
    }

    public func asWidget<Backend: AppBackend>(
        _ children: any ViewGraphNodeChildren,
        backend: Backend
    ) -> Backend.Widget {
        return asWidget(children as! Children, backend: backend)
    }

    public func update<Backend: AppBackend>(
        _ widget: Backend.Widget,
        children: any ViewGraphNodeChildren,
        backend: Backend
    ) {
        update(widget, children: children as! Children, backend: backend)
    }
}

extension TypeSafeView where Content: TypeSafeView, Children == Content.Children {
    func children<Backend: AppBackend>(backend: Backend) -> Children {
        return body.children(backend: backend)
    }

    func updateChildren<Backend: AppBackend>(_ children: Children, backend: Backend) {
        body.updateChildren(children, backend: backend)
    }
}
