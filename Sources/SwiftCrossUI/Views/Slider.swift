/// A value convertible to and from a ``Double``.`
public protocol DoubleConvertible {
    /// Creates a value from a ``Double``.`
    init(_ value: Double)

    /// Converts the value to a ``Double``.`
    var doubleRepresentation: Double { get }
}

/// A value represented by a ``BinaryFloatingPoint``.
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

/// A value represented by a ``BinaryInteger``.
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

/// A control for selecting a value from a bounded range of numerical values.
public struct Slider: ElementaryView, View {
    /// A binding to the current value.
    private var value: Binding<Double>?
    /// The slider's minimum value.
    private var minimum: Double
    /// The slider's maximum value.
    private var maximum: Double
    /// The number of decimal places used when displaying the value.
    private var decimalPlaces: Int

    /// Creates a slider to select a value between a minimum and maximum value.
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

    /// Creates a slider to select a value between a minimum and maximum value.
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

    public func asWidget<Backend: AppBackend>(
        backend: Backend
    ) -> Backend.Widget {
        return backend.createSlider()
    }

    public func update<Backend: AppBackend>(
        _ widget: Backend.Widget,
        backend: Backend
    ) {
        backend.updateSlider(
            widget, minimum: minimum, maximum: maximum, decimalPlaces: decimalPlaces
        ) { [weak value] newValue in
            guard let value = value else {
                return
            }
            value.wrappedValue = newValue
        }

        if let value = value?.wrappedValue {
            backend.setValue(ofSlider: widget, to: value)
        }
    }
}
