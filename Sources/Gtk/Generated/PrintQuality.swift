import CGtk

/// See also gtk_print_settings_set_quality().
public enum PrintQuality {
    /// Low quality.
    case low
    /// Normal quality.
    case normal
    /// High quality.
    case high
    /// Draft quality.
    case draft

    /// Converts the value to its corresponding Gtk representation.
    func toGtkPrintQuality() -> GtkPrintQuality {
        switch self {
            case .low:
                return GTK_PRINT_QUALITY_LOW
            case .normal:
                return GTK_PRINT_QUALITY_NORMAL
            case .high:
                return GTK_PRINT_QUALITY_HIGH
            case .draft:
                return GTK_PRINT_QUALITY_DRAFT
        }
    }
}

extension GtkPrintQuality {
    /// Converts a Gtk value to its corresponding swift representation.
    func toPrintQuality() -> PrintQuality {
        switch self {
            case GTK_PRINT_QUALITY_LOW:
                return .low
            case GTK_PRINT_QUALITY_NORMAL:
                return .normal
            case GTK_PRINT_QUALITY_HIGH:
                return .high
            case GTK_PRINT_QUALITY_DRAFT:
                return .draft
            default:
                fatalError("Unsupported GtkPrintQuality enum value: \(self.rawValue)")
        }
    }
}
