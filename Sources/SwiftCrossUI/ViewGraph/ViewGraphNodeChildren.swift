/// The children of a view graph node. This is implemented by a few different
/// types for various purposes. E.g. variable length with same-typed elements
/// (``ForEach``), and fixed length with distinctly-typed elements (``VariadicView1``,
/// ``VariadicView2``, etc).
public protocol ViewGraphNodeChildren {
    /// The widget's of the children. Type-erased to avoid the type of the currently
    /// selected backend leaking into the ``View`` protocol, requiring users to
    /// engage with annoying complexity and reducing ease of backend switching.
    var widgets: [AnyWidget] { get }
}

extension ViewGraphNodeChildren {
    /// Bundles the node's children into a single layout-transparent container (will take
    /// on the orientation of its parent).
    public func asSingleWidget<Backend: AppBackend>(backend: Backend) -> Backend.Widget {
        let widgets: [Backend.Widget] = widgets.map { $0.into() }
        let stack = backend.createPassthroughVStack(spacing: 0)
        for widget in widgets {
            backend.addChild(widget, toPassthroughVStack: stack)
        }
        return stack
    }

    /// Gets the node's type-erased widgets for a specific backend (crashing if the
    /// widgets were created by a different backend).
    public func widgets<Backend: AppBackend>(for backend: Backend) -> [Backend.Widget] {
        return widgets.map { $0.into() }
    }
}

/// The children of a node with no children.
public struct EmptyViewGraphNodeChildren: ViewGraphNodeChildren {
    public let widgets: [AnyWidget] = []

    /// Creates an empty collection of children for a node with no children.
    public init() {}
}

/// A fixed-length strongly-typed collection of 1 child nodes. A counterpart to
/// ``VariadicView1``.
public struct ViewGraphNodeChildren1<Child0: View>: ViewGraphNodeChildren {
    public var widgets: [AnyWidget] {
        return [
            child0.widget
        ]
    }

    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child0: AnyViewGraphNode<Child0>

    /// Creates the nodes for 1 child views.
    public init<Backend: AppBackend>(
        _ child0: Child0,
        backend: Backend
    ) {
        self.child0 = AnyViewGraphNode(for: child0, backend: backend)
    }
}

/// A fixed-length strongly-typed collection of 2 child nodes. A counterpart to
/// ``VariadicView2``.
public struct ViewGraphNodeChildren2<Child0: View, Child1: View>: ViewGraphNodeChildren {
    public var widgets: [AnyWidget] {
        return [
            child0.widget,
            child1.widget,
        ]
    }

    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child0: AnyViewGraphNode<Child0>
    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child1: AnyViewGraphNode<Child1>

    /// Creates the nodes for 2 child views.
    public init<Backend: AppBackend>(
        _ child0: Child0,
        _ child1: Child1,
        backend: Backend
    ) {
        self.child0 = AnyViewGraphNode(for: child0, backend: backend)
        self.child1 = AnyViewGraphNode(for: child1, backend: backend)
    }
}

/// A fixed-length strongly-typed collection of 3 child nodes. A counterpart to
/// ``VariadicView3``.
public struct ViewGraphNodeChildren3<Child0: View, Child1: View, Child2: View>:
    ViewGraphNodeChildren
{
    public var widgets: [AnyWidget] {
        return [
            child0.widget,
            child1.widget,
            child2.widget,
        ]
    }

    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child0: AnyViewGraphNode<Child0>
    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child1: AnyViewGraphNode<Child1>
    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child2: AnyViewGraphNode<Child2>

    /// Creates the nodes for 3 child views.
    public init<Backend: AppBackend>(
        _ child0: Child0,
        _ child1: Child1,
        _ child2: Child2,
        backend: Backend
    ) {
        self.child0 = AnyViewGraphNode(for: child0, backend: backend)
        self.child1 = AnyViewGraphNode(for: child1, backend: backend)
        self.child2 = AnyViewGraphNode(for: child2, backend: backend)
    }
}

/// A fixed-length strongly-typed collection of 4 child nodes. A counterpart to
/// ``VariadicView4``.
public struct ViewGraphNodeChildren4<Child0: View, Child1: View, Child2: View, Child3: View>:
    ViewGraphNodeChildren
{
    public var widgets: [AnyWidget] {
        return [
            child0.widget,
            child1.widget,
            child2.widget,
            child3.widget,
        ]
    }

    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child0: AnyViewGraphNode<Child0>
    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child1: AnyViewGraphNode<Child1>
    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child2: AnyViewGraphNode<Child2>
    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child3: AnyViewGraphNode<Child3>

    /// Creates the nodes for 4 child views.
    public init<Backend: AppBackend>(
        _ child0: Child0,
        _ child1: Child1,
        _ child2: Child2,
        _ child3: Child3,
        backend: Backend
    ) {
        self.child0 = AnyViewGraphNode(for: child0, backend: backend)
        self.child1 = AnyViewGraphNode(for: child1, backend: backend)
        self.child2 = AnyViewGraphNode(for: child2, backend: backend)
        self.child3 = AnyViewGraphNode(for: child3, backend: backend)
    }
}

/// A fixed-length strongly-typed collection of 5 child nodes. A counterpart to
/// ``VariadicView5``.
public struct ViewGraphNodeChildren5<
    Child0: View, Child1: View, Child2: View, Child3: View, Child4: View
>: ViewGraphNodeChildren {
    public var widgets: [AnyWidget] {
        return [
            child0.widget,
            child1.widget,
            child2.widget,
            child3.widget,
            child4.widget,
        ]
    }

    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child0: AnyViewGraphNode<Child0>
    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child1: AnyViewGraphNode<Child1>
    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child2: AnyViewGraphNode<Child2>
    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child3: AnyViewGraphNode<Child3>
    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child4: AnyViewGraphNode<Child4>

    /// Creates the nodes for 5 child views.
    public init<Backend: AppBackend>(
        _ child0: Child0,
        _ child1: Child1,
        _ child2: Child2,
        _ child3: Child3,
        _ child4: Child4,
        backend: Backend
    ) {
        self.child0 = AnyViewGraphNode(for: child0, backend: backend)
        self.child1 = AnyViewGraphNode(for: child1, backend: backend)
        self.child2 = AnyViewGraphNode(for: child2, backend: backend)
        self.child3 = AnyViewGraphNode(for: child3, backend: backend)
        self.child4 = AnyViewGraphNode(for: child4, backend: backend)
    }
}

/// A fixed-length strongly-typed collection of 6 child nodes. A counterpart to
/// ``VariadicView6``.
public struct ViewGraphNodeChildren6<
    Child0: View, Child1: View, Child2: View, Child3: View, Child4: View, Child5: View
>: ViewGraphNodeChildren {
    public var widgets: [AnyWidget] {
        return [
            child0.widget,
            child1.widget,
            child2.widget,
            child3.widget,
            child4.widget,
            child5.widget,
        ]
    }

    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child0: AnyViewGraphNode<Child0>
    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child1: AnyViewGraphNode<Child1>
    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child2: AnyViewGraphNode<Child2>
    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child3: AnyViewGraphNode<Child3>
    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child4: AnyViewGraphNode<Child4>
    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child5: AnyViewGraphNode<Child5>

    /// Creates the nodes for 6 child views.
    public init<Backend: AppBackend>(
        _ child0: Child0,
        _ child1: Child1,
        _ child2: Child2,
        _ child3: Child3,
        _ child4: Child4,
        _ child5: Child5,
        backend: Backend
    ) {
        self.child0 = AnyViewGraphNode(for: child0, backend: backend)
        self.child1 = AnyViewGraphNode(for: child1, backend: backend)
        self.child2 = AnyViewGraphNode(for: child2, backend: backend)
        self.child3 = AnyViewGraphNode(for: child3, backend: backend)
        self.child4 = AnyViewGraphNode(for: child4, backend: backend)
        self.child5 = AnyViewGraphNode(for: child5, backend: backend)
    }
}

/// A fixed-length strongly-typed collection of 7 child nodes. A counterpart to
/// ``VariadicView7``.
public struct ViewGraphNodeChildren7<
    Child0: View, Child1: View, Child2: View, Child3: View, Child4: View, Child5: View, Child6: View
>: ViewGraphNodeChildren {
    public var widgets: [AnyWidget] {
        return [
            child0.widget,
            child1.widget,
            child2.widget,
            child3.widget,
            child4.widget,
            child5.widget,
            child6.widget,
        ]
    }

    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child0: AnyViewGraphNode<Child0>
    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child1: AnyViewGraphNode<Child1>
    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child2: AnyViewGraphNode<Child2>
    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child3: AnyViewGraphNode<Child3>
    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child4: AnyViewGraphNode<Child4>
    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child5: AnyViewGraphNode<Child5>
    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child6: AnyViewGraphNode<Child6>

    /// Creates the nodes for 7 child views.
    public init<Backend: AppBackend>(
        _ child0: Child0,
        _ child1: Child1,
        _ child2: Child2,
        _ child3: Child3,
        _ child4: Child4,
        _ child5: Child5,
        _ child6: Child6,
        backend: Backend
    ) {
        self.child0 = AnyViewGraphNode(for: child0, backend: backend)
        self.child1 = AnyViewGraphNode(for: child1, backend: backend)
        self.child2 = AnyViewGraphNode(for: child2, backend: backend)
        self.child3 = AnyViewGraphNode(for: child3, backend: backend)
        self.child4 = AnyViewGraphNode(for: child4, backend: backend)
        self.child5 = AnyViewGraphNode(for: child5, backend: backend)
        self.child6 = AnyViewGraphNode(for: child6, backend: backend)
    }
}

/// A fixed-length strongly-typed collection of 8 child nodes. A counterpart to
/// ``VariadicView8``.
public struct ViewGraphNodeChildren8<
    Child0: View, Child1: View, Child2: View, Child3: View, Child4: View, Child5: View,
    Child6: View, Child7: View
>: ViewGraphNodeChildren {
    public var widgets: [AnyWidget] {
        return [
            child0.widget,
            child1.widget,
            child2.widget,
            child3.widget,
            child4.widget,
            child5.widget,
            child6.widget,
            child7.widget,
        ]
    }

    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child0: AnyViewGraphNode<Child0>
    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child1: AnyViewGraphNode<Child1>
    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child2: AnyViewGraphNode<Child2>
    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child3: AnyViewGraphNode<Child3>
    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child4: AnyViewGraphNode<Child4>
    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child5: AnyViewGraphNode<Child5>
    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child6: AnyViewGraphNode<Child6>
    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child7: AnyViewGraphNode<Child7>

    /// Creates the nodes for 8 child views.
    public init<Backend: AppBackend>(
        _ child0: Child0,
        _ child1: Child1,
        _ child2: Child2,
        _ child3: Child3,
        _ child4: Child4,
        _ child5: Child5,
        _ child6: Child6,
        _ child7: Child7,
        backend: Backend
    ) {
        self.child0 = AnyViewGraphNode(for: child0, backend: backend)
        self.child1 = AnyViewGraphNode(for: child1, backend: backend)
        self.child2 = AnyViewGraphNode(for: child2, backend: backend)
        self.child3 = AnyViewGraphNode(for: child3, backend: backend)
        self.child4 = AnyViewGraphNode(for: child4, backend: backend)
        self.child5 = AnyViewGraphNode(for: child5, backend: backend)
        self.child6 = AnyViewGraphNode(for: child6, backend: backend)
        self.child7 = AnyViewGraphNode(for: child7, backend: backend)
    }
}

/// A fixed-length strongly-typed collection of 9 child nodes. A counterpart to
/// ``VariadicView9``.
public struct ViewGraphNodeChildren9<
    Child0: View, Child1: View, Child2: View, Child3: View, Child4: View, Child5: View,
    Child6: View, Child7: View, Child8: View
>: ViewGraphNodeChildren {
    public var widgets: [AnyWidget] {
        return [
            child0.widget,
            child1.widget,
            child2.widget,
            child3.widget,
            child4.widget,
            child5.widget,
            child6.widget,
            child7.widget,
            child8.widget,
        ]
    }

    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child0: AnyViewGraphNode<Child0>
    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child1: AnyViewGraphNode<Child1>
    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child2: AnyViewGraphNode<Child2>
    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child3: AnyViewGraphNode<Child3>
    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child4: AnyViewGraphNode<Child4>
    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child5: AnyViewGraphNode<Child5>
    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child6: AnyViewGraphNode<Child6>
    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child7: AnyViewGraphNode<Child7>
    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child8: AnyViewGraphNode<Child8>

    /// Creates the nodes for 9 child views.
    public init<Backend: AppBackend>(
        _ child0: Child0,
        _ child1: Child1,
        _ child2: Child2,
        _ child3: Child3,
        _ child4: Child4,
        _ child5: Child5,
        _ child6: Child6,
        _ child7: Child7,
        _ child8: Child8,
        backend: Backend
    ) {
        self.child0 = AnyViewGraphNode(for: child0, backend: backend)
        self.child1 = AnyViewGraphNode(for: child1, backend: backend)
        self.child2 = AnyViewGraphNode(for: child2, backend: backend)
        self.child3 = AnyViewGraphNode(for: child3, backend: backend)
        self.child4 = AnyViewGraphNode(for: child4, backend: backend)
        self.child5 = AnyViewGraphNode(for: child5, backend: backend)
        self.child6 = AnyViewGraphNode(for: child6, backend: backend)
        self.child7 = AnyViewGraphNode(for: child7, backend: backend)
        self.child8 = AnyViewGraphNode(for: child8, backend: backend)
    }
}

/// A fixed-length strongly-typed collection of 10 child nodes. A counterpart to
/// ``VariadicView10``.
public struct ViewGraphNodeChildren10<
    Child0: View, Child1: View, Child2: View, Child3: View, Child4: View, Child5: View,
    Child6: View, Child7: View, Child8: View, Child9: View
>: ViewGraphNodeChildren {
    public var widgets: [AnyWidget] {
        return [
            child0.widget,
            child1.widget,
            child2.widget,
            child3.widget,
            child4.widget,
            child5.widget,
            child6.widget,
            child7.widget,
            child8.widget,
            child9.widget,
        ]
    }

    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child0: AnyViewGraphNode<Child0>
    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child1: AnyViewGraphNode<Child1>
    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child2: AnyViewGraphNode<Child2>
    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child3: AnyViewGraphNode<Child3>
    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child4: AnyViewGraphNode<Child4>
    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child5: AnyViewGraphNode<Child5>
    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child6: AnyViewGraphNode<Child6>
    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child7: AnyViewGraphNode<Child7>
    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child8: AnyViewGraphNode<Child8>
    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child9: AnyViewGraphNode<Child9>

    /// Creates the nodes for 10 child views.
    public init<Backend: AppBackend>(
        _ child0: Child0,
        _ child1: Child1,
        _ child2: Child2,
        _ child3: Child3,
        _ child4: Child4,
        _ child5: Child5,
        _ child6: Child6,
        _ child7: Child7,
        _ child8: Child8,
        _ child9: Child9,
        backend: Backend
    ) {
        self.child0 = AnyViewGraphNode(for: child0, backend: backend)
        self.child1 = AnyViewGraphNode(for: child1, backend: backend)
        self.child2 = AnyViewGraphNode(for: child2, backend: backend)
        self.child3 = AnyViewGraphNode(for: child3, backend: backend)
        self.child4 = AnyViewGraphNode(for: child4, backend: backend)
        self.child5 = AnyViewGraphNode(for: child5, backend: backend)
        self.child6 = AnyViewGraphNode(for: child6, backend: backend)
        self.child7 = AnyViewGraphNode(for: child7, backend: backend)
        self.child8 = AnyViewGraphNode(for: child8, backend: backend)
        self.child9 = AnyViewGraphNode(for: child9, backend: backend)
    }
}
