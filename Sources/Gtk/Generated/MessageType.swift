import CGtk

/// The type of message being displayed in a [class@MessageDialog].
public enum MessageType: GValueRepresentableEnum {
    public typealias GtkEnum = GtkMessageType

    /// Informational message
    case info
    /// Non-fatal warning message
    case warning
    /// Question requiring a choice
    case question
    /// Fatal error message
    case error
    /// None of the above
    case other

    /// Converts a Gtk value to its corresponding swift representation.
    public init(from gtkEnum: GtkMessageType) {
        switch gtkEnum {
            case GTK_MESSAGE_INFO:
                self = .info
            case GTK_MESSAGE_WARNING:
                self = .warning
            case GTK_MESSAGE_QUESTION:
                self = .question
            case GTK_MESSAGE_ERROR:
                self = .error
            case GTK_MESSAGE_OTHER:
                self = .other
            default:
                fatalError("Unsupported GtkMessageType enum value: \(gtkEnum.rawValue)")
        }
    }

    /// Converts the value to its corresponding Gtk representation.
    public func toGtk() -> GtkMessageType {
        switch self {
            case .info:
                return GTK_MESSAGE_INFO
            case .warning:
                return GTK_MESSAGE_WARNING
            case .question:
                return GTK_MESSAGE_QUESTION
            case .error:
                return GTK_MESSAGE_ERROR
            case .other:
                return GTK_MESSAGE_OTHER
        }
    }
}
