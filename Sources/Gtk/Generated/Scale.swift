import CGtk

/// A `GtkScale` is a slider control used to select a numeric value.
///
/// ![An example GtkScale](scales.png)
///
/// To use it, you’ll probably want to investigate the methods on its base
/// class, [class@Gtk.Range], in addition to the methods for `GtkScale` itself.
/// To set the value of a scale, you would normally use [method@Gtk.Range.set_value].
/// To detect changes to the value, you would normally use the
/// [signal@Gtk.Range::value-changed] signal.
///
/// Note that using the same upper and lower bounds for the `GtkScale` (through
/// the `GtkRange` methods) will hide the slider itself. This is useful for
/// applications that want to show an undeterminate value on the scale, without
/// changing the layout of the application (such as movie or music players).
///
/// # GtkScale as GtkBuildable
///
/// `GtkScale` supports a custom `<marks>` element, which can contain multiple
/// `<mark\>` elements. The “value” and “position” attributes have the same
/// meaning as [method@Gtk.Scale.add_mark] parameters of the same name. If
/// the element is not empty, its content is taken as the markup to show at
/// the mark. It can be translated with the usual ”translatable” and
/// “context” attributes.
///
/// # CSS nodes
///
/// ```
/// scale[.fine-tune][.marks-before][.marks-after]
/// ├── [value][.top][.right][.bottom][.left]
/// ├── marks.top
/// │   ├── mark
/// │   ┊    ├── [label]
/// │   ┊    ╰── indicator
/// ┊   ┊
/// │   ╰── mark
/// ├── marks.bottom
/// │   ├── mark
/// │   ┊    ├── indicator
/// │   ┊    ╰── [label]
/// ┊   ┊
/// │   ╰── mark
/// ╰── trough
/// ├── [fill]
/// ├── [highlight]
/// ╰── slider
/// ```
///
/// `GtkScale` has a main CSS node with name scale and a subnode for its contents,
/// with subnodes named trough and slider.
///
/// The main node gets the style class .fine-tune added when the scale is in
/// 'fine-tuning' mode.
///
/// If the scale has an origin (see [method@Gtk.Scale.set_has_origin]), there is
/// a subnode with name highlight below the trough node that is used for rendering
/// the highlighted part of the trough.
///
/// If the scale is showing a fill level (see [method@Gtk.Range.set_show_fill_level]),
/// there is a subnode with name fill below the trough node that is used for
/// rendering the filled in part of the trough.
///
/// If marks are present, there is a marks subnode before or after the trough
/// node, below which each mark gets a node with name mark. The marks nodes get
/// either the .top or .bottom style class.
///
/// The mark node has a subnode named indicator. If the mark has text, it also
/// has a subnode named label. When the mark is either above or left of the
/// scale, the label subnode is the first when present. Otherwise, the indicator
/// subnode is the first.
///
/// The main CSS node gets the 'marks-before' and/or 'marks-after' style classes
/// added depending on what marks are present.
///
/// If the scale is displaying the value (see [property@Gtk.Scale:draw-value]),
/// there is subnode with name value. This node will get the .top or .bottom style
/// classes similar to the marks node.
///
/// # Accessibility
///
/// `GtkScale` uses the %GTK_ACCESSIBLE_ROLE_SLIDER role.
public class Scale: Range {
    /// Creates a new `GtkScale`.
    public init(orientation: GtkOrientation, adjustment: UnsafeMutablePointer<GtkAdjustment>!) {
        super.init()
        widgetPointer = gtk_scale_new(orientation, adjustment)
    }

    /// Creates a new scale widget with a range from @min to @max.
    ///
    /// The returns scale will have the given orientation and will let the
    /// user input a number between @min and @max (including @min and @max)
    /// with the increment @step. @step must be nonzero; it’s the distance
    /// the slider moves when using the arrow keys to adjust the scale
    /// value.
    ///
    /// Note that the way in which the precision is derived works best if
    /// @step is a power of ten. If the resulting precision is not suitable
    /// for your needs, use [method@Gtk.Scale.set_digits] to correct it.
    public init(range orientation: GtkOrientation, min: Double, max: Double, step: Double) {
        super.init()
        widgetPointer = gtk_scale_new_with_range(orientation, min, max, step)
    }

    /// The number of decimal places that are displayed in the value.
    @GObjectProperty(named: "digits") public var digits: Int

    /// Whether the current value is displayed as a string next to the slider.
    @GObjectProperty(named: "draw-value") public var drawValue: Bool

    /// Whether the scale has an origin.
    @GObjectProperty(named: "has-origin") public var hasOrigin: Bool

    /// The position in which the current value is displayed.
    @GObjectProperty(named: "value-pos") public var valuePos: PositionType
}
