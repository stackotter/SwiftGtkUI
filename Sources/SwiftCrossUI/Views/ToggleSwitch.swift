/// A light switch style control that is either on or off.
struct ToggleSwitch: ElementaryView, View {
    /// Whether the switch is active or not.
    private var active: Binding<Bool>

    /// Creates a switch.
    public init(active: Binding<Bool>) {
        self.active = active
    }

    public func asWidget<Backend: AppBackend>(
        backend: Backend
    ) -> Backend.Widget {
        return backend.createSwitch()
    }

    public func update<Backend: AppBackend>(
        _ widget: Backend.Widget,
        backend: Backend
    ) {
        backend.updateSwitch(widget) { newActiveState in
            active.wrappedValue = newActiveState
        }
        backend.setState(ofSwitch: widget, to: active.wrappedValue)
    }
}
