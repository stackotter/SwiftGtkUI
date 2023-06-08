public protocol DoubleConvertible {
    init(_ value: Double)
    var doubleRepresentation: Double { get }
}

struct FloatingPointValue<Value: BinaryFloatingPoint>: DoubleConvertible {
    var value: Value

    init(_ value: Value) {
        self.value = value
    }

    init(_ value: Double) {
        self.value = Value(value)
    }

    var doubleRepresentation: Double {
        return Double(value)
    }
}

struct IntegerValue<Value: BinaryInteger>: DoubleConvertible {
    var value: Value

    init(_ value: Value) {
        self.value = value
    }

    init(_ value: Double) {
        self.value = Value(value)
    }

    var doubleRepresentation: Double {
        return Double(value)
    }
}

/// A slider that allows a user to choose a numeric value.
public struct Slider: View {
    public var body = EmptyViewContent()

    /// A binding to the current value.
    private var value: Binding<Double>?
    /// The slider's minimum value.
    private var minimum: Double
    /// The slider's maximum value.
    private var maximum: Double
    /// The number of decimal places used when displaying the value.
    private var decimalPlaces: Int

    public init<T: BinaryInteger>(_ value: Binding<T>? = nil, minimum: T, maximum: T) {
        if let value = value {
            self.value = Binding<Double>(
                get: {
                    return Double(value.wrappedValue)
                },
                set: { newValue in
                    value.wrappedValue = T(newValue.rounded())
                }
            )
        }
        self.minimum = Double(minimum)
        self.maximum = Double(maximum)
        decimalPlaces = 0
    }

    public init<T: BinaryFloatingPoint>(_ value: Binding<T>? = nil, minimum: T, maximum: T) {
        if let value = value {
            self.value = Binding<Double>(
                get: {
                    return Double(value.wrappedValue)
                },
                set: { newValue in
                    value.wrappedValue = T(newValue)
                }
            )
        }
        self.minimum = Double(minimum)
        self.maximum = Double(maximum)
        decimalPlaces = 2
    }

    public func asWidget(_ children: EmptyViewGraphNodeChildren) -> GtkScale {
        let scale = GtkScale()
        scale.expandHorizontally = true
        return scale
    }

    public func update(_ widget: GtkScale, children: EmptyViewGraphNodeChildren) {
        widget.minimum = minimum
        widget.maximum = maximum
        widget.value = value?.wrappedValue ?? widget.value
        widget.digits = decimalPlaces
        widget.valueChanged = { widget in
            self.value?.wrappedValue = widget.value
        }
    }
}
