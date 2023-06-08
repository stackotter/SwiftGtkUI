import CGtk

/// Describes limits of a [class@EventController] for handling events
/// targeting other widgets.
public enum PropagationLimit: GValueRepresentableEnum {
    public typealias GtkEnum = GtkPropagationLimit

    /// Events are handled regardless of what their
    /// target is.
    case none
    /// Events are only handled if their target
    /// is in the same [iface@Native] as the event controllers widget. Note
    /// that some event types have two targets (origin and destination).
    case sameNative

    /// Converts a Gtk value to its corresponding swift representation.
    public init(from gtkEnum: GtkPropagationLimit) {
        switch gtkEnum {
            case GTK_LIMIT_NONE:
                self = .none
            case GTK_LIMIT_SAME_NATIVE:
                self = .sameNative
            default:
                fatalError("Unsupported GtkPropagationLimit enum value: \(gtkEnum.rawValue)")
        }
    }

    /// Converts the value to its corresponding Gtk representation.
    public func toGtk() -> GtkPropagationLimit {
        switch self {
            case .none:
                return GTK_LIMIT_NONE
            case .sameNative:
                return GTK_LIMIT_SAME_NATIVE
        }
    }
}
