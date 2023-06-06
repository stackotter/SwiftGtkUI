import CGtk

/// See also gtk_print_job_set_page_set().
public enum PageSet: GValueRepresentableEnum {
    public typealias GtkEnum = GtkPageSet

    /// All pages.
    case all
    /// Even pages.
    case even
    /// Odd pages.
    case odd

    /// Converts a Gtk value to its corresponding swift representation.
    public init(from gtkEnum: GtkPageSet) {
        switch gtkEnum {
            case GTK_PAGE_SET_ALL:
                self = .all
            case GTK_PAGE_SET_EVEN:
                self = .even
            case GTK_PAGE_SET_ODD:
                self = .odd
            default:
                fatalError("Unsupported GtkPageSet enum value: \(gtkEnum.rawValue)")
        }
    }

    /// Converts the value to its corresponding Gtk representation.
    public func toGtk() -> GtkPageSet {
        switch self {
            case .all:
                return GTK_PAGE_SET_ALL
            case .even:
                return GTK_PAGE_SET_EVEN
            case .odd:
                return GTK_PAGE_SET_ODD
        }
    }
}
