import CGtk

/// Controls how a widget deals with extra space in a single dimension.
///
/// Alignment only matters if the widget receives a “too large” allocation,
/// for example if you packed the widget with the [property@Gtk.Widget:hexpand]
/// property inside a [class@Box], then the widget might get extra space.
/// If you have for example a 16x16 icon inside a 32x32 space, the icon
/// could be scaled and stretched, it could be centered, or it could be
/// positioned to one side of the space.
///
/// Note that in horizontal context %GTK_ALIGN_START and %GTK_ALIGN_END
/// are interpreted relative to text direction.
///
/// %GTK_ALIGN_BASELINE support is optional for containers and widgets, and
/// it is only supported for vertical alignment.  When it's not supported by
/// a child or a container it is treated as %GTK_ALIGN_FILL.
public enum Align {
    /// Stretch to fill all space if possible, center if
    /// no meaningful way to stretch
    case fill
    /// Snap to left or top side, leaving space on right or bottom
    case start
    /// Snap to right or bottom side, leaving space on left or top
    case end
    /// Center natural width of widget inside the allocation
    case center
    /// Align the widget according to the baseline.
    /// See [class@Gtk.Widget].
    case baseline

    /// Converts the value to its corresponding Gtk representation.
    func toGtkAlign() -> GtkAlign {
        switch self {
            case .fill:
                return GTK_ALIGN_FILL
            case .start:
                return GTK_ALIGN_START
            case .end:
                return GTK_ALIGN_END
            case .center:
                return GTK_ALIGN_CENTER
            case .baseline:
                return GTK_ALIGN_BASELINE
        }
    }
}

extension GtkAlign {
    /// Converts a Gtk value to its corresponding swift representation.
    func toAlign() -> Align {
        switch self {
            case GTK_ALIGN_FILL:
                return .fill
            case GTK_ALIGN_START:
                return .start
            case GTK_ALIGN_END:
                return .end
            case GTK_ALIGN_CENTER:
                return .center
            case GTK_ALIGN_BASELINE:
                return .baseline
            default:
                fatalError("Unsupported GtkAlign enum value: \(self.rawValue)")
        }
    }
}
