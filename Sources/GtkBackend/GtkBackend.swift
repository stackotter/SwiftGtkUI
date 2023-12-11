import CGtk
import Foundation
import Gtk
import SwiftCrossUI

extension SwiftCrossUI.Color {
    public var gtkColor: Gtk.Color {
        return Gtk.Color(red, green, blue, alpha)
    }
}

public final class GtkBackend: AppBackend {
    public typealias Window = Gtk.Window
    public typealias Widget = Gtk.Widget

    var gtkApp: Application

    /// A window to be returned on the next call to ``GtkBackend/createWindow``.
    /// This is necessary because Gtk creates a root window no matter what, and
    /// this needs to be returned on the first call to `createWindow`.
    var precreatedWindow: Window?

    public init(appIdentifier: String) {
        gtkApp = Application(applicationId: appIdentifier)
    }

    public func runMainLoop(_ callback: @escaping () -> Void) {
        // TODO: Setup the main window such that its child is centered like it would be in SwiftUI
        gtkApp.run { window in
            self.precreatedWindow = window
            callback()
        }
    }

    public func createWindow(withDefaultSize defaultSize: SwiftCrossUI.Size?) -> Window {
        let window: Gtk.Window
        if let precreatedWindow = precreatedWindow {
            self.precreatedWindow = nil
            window = precreatedWindow
        } else {
            window = Gtk.Window()
        }

        if let defaultSize = defaultSize {
            window.defaultSize = Size(
                width: defaultSize.width,
                height: defaultSize.height
            )
        }

        return window
    }

    public func setTitle(ofWindow window: Window, to title: String) {
        window.title = title
    }

    public func setResizability(ofWindow window: Window, to resizable: Bool) {
        window.resizable = resizable
    }

    public func setChild(ofWindow window: Window, to child: Widget) {
        window.setChild(child)
    }

    public func show(window: Window) {
        window.show()
    }

    class ThreadActionContext {
        var action: () -> Void

        init(action: @escaping () -> Void) {
            self.action = action
        }
    }

    public func runInMainThread(action: @escaping () -> Void) {
        let action = ThreadActionContext(action: action)
        g_idle_add_full(
            0,
            { context in
                guard let context = context else {
                    fatalError("Gtk action callback called without context")
                }

                let action = Unmanaged<ThreadActionContext>.fromOpaque(context)
                    .takeUnretainedValue()
                action.action()

                return 0
            },
            Unmanaged<ThreadActionContext>.passRetained(action).toOpaque(),
            { _ in }
        )
    }

    public func show(widget: Widget) {
        widget.show()
    }

    public func createVStack(spacing: Int) -> Widget {
        return Box(orientation: .vertical, spacing: spacing)
    }

    public func addChild(_ child: Widget, toVStack container: Widget) {
        (container as! Box).add(child)
    }

    public func setSpacing(ofVStack container: Widget, to spacing: Int) {
        (container as! Box).spacing = spacing
    }

    public func createHStack(spacing: Int) -> Widget {
        return Box(orientation: .horizontal, spacing: spacing)
    }

    public func addChild(_ child: Widget, toHStack container: Widget) {
        (container as! Box).add(child)
    }

    public func setSpacing(ofHStack container: Widget, to spacing: Int) {
        (container as! Box).spacing = spacing
    }

    public func createPassthroughVStack(spacing: Int) -> Widget {
        return SectionBox(orientation: .vertical, spacing: spacing)
    }

    public func addChild(_ child: Widget, toPassthroughVStack container: Widget) {
        (container as! SectionBox).add(child)
    }

    public func updatePassthroughVStack(_ vStack: Widget) {
        (vStack as! SectionBox).update()
    }

    public func createEitherContainer(initiallyContaining child: Widget?) -> Widget {
        let box = ModifierBox()
        box.setChild(child)
        return box
    }

    public func setChild(ofEitherContainer container: Widget, to widget: Widget?) {
        (container as! ModifierBox).setChild(widget)
    }

    public func createPaddingContainer(for child: Widget) -> Widget {
        let box = ModifierBox()
        box.setChild(child)
        return box
    }

    public func getChild(ofPaddingContainer container: Widget) -> Widget {
        return (container as! ModifierBox).child!
    }

    public func setPadding(
        ofPaddingContainer container: Widget,
        top: Int,
        bottom: Int,
        leading: Int,
        trailing: Int
    ) {
        let container = container as! ModifierBox
        container.marginTop = top
        container.marginBottom = bottom
        container.marginStart = leading
        container.marginEnd = trailing
    }

    public func createScrollContainer(for child: Widget) -> Widget {
        let scrolledWindow = ScrolledWindow()
        scrolledWindow.setChild(child)
        scrolledWindow.propagateNaturalHeight = true
        return scrolledWindow
    }

    public func createButton(label: String, action: @escaping () -> Void) -> Widget {
        let button = Button()
        button.label = label
        button.clicked = { _ in action() }
        return button
    }

    public func setLabel(ofButton button: Widget, to label: String) {
        (button as! Gtk.Button).label = label
    }

    public func setAction(ofButton button: Widget, to action: @escaping () -> Void) {
        (button as! Gtk.Button).clicked = { _ in action() }
    }

    public func createToggle(
        label: String,
        active: Bool,
        onChange: @escaping (Bool) -> Void
    ) -> Widget {
        let toggle = ToggleButton()
        toggle.label = label
        toggle.active = active
        return toggle
    }

    public func setIsActive(ofToggle toggle: Widget, to active: Bool) {
        (toggle as! Gtk.ToggleButton).active = active
    }

    public func setOnChange(ofToggle toggle: Widget, to onChange: @escaping (Bool) -> Void) {
        (toggle as! Gtk.ToggleButton).toggled = { widget in
            onChange(widget.active)
        }
    }

    public func createSwitch(active: Bool, onChange: @escaping (Bool) -> Void) -> Widget {
        let switchWidget = Switch()
        switchWidget.active = active
        switchWidget.notifyActive = { widget in
            onChange(widget.active)
        }
        return switchWidget
    }

    public func setIsActive(ofSwitch switchWidget: Widget, to active: Bool) {
        (switchWidget as! Gtk.Switch).active = active
    }

    public func setOnChange(ofSwitch switchWidget: Widget, to onChange: @escaping (Bool) -> Void) {
        (switchWidget as! Gtk.Switch).notifyActive = { widget in
            onChange(widget.active)
        }
    }

    public func createTextView(content: String, shouldWrap: Bool) -> Widget {
        let label = Label(string: content)
        label.lineWrapMode = .wordCharacter
        label.horizontalAlignment = .start
        label.wrap = shouldWrap
        return label
    }

    public func setContent(ofTextView textView: Widget, to content: String) {
        (textView as! Label).label = content
    }

    public func setWrap(ofTextView textView: Widget, to shouldWrap: Bool) {
        (textView as! Label).wrap = shouldWrap
    }

    public func createImageView(filePath: String) -> Widget {
        let picture = Picture(filename: filePath)
        // Prevent the image from completely disappearing if it isn't given space
        // because that can be very confusing as a developer
        picture.minHeight = 5
        return picture
    }

    public func setFilePath(ofImageView imageView: Widget, to filePath: String) {
        (imageView as! Gtk.Picture).setPath(filePath)
    }

    public func createSpacer(
        expandHorizontally: Bool, expandVertically: Bool
    ) -> Widget {
        let box = ModifierBox()
        box.expandHorizontally = expandHorizontally
        box.expandVertically = expandVertically
        return box
    }

    public func setExpandHorizontally(ofSpacer spacer: Widget, to expandHorizontally: Bool) {
        (spacer as! ModifierBox).expandHorizontally = expandHorizontally
    }

    public func setExpandVertically(ofSpacer spacer: Widget, to expandVertically: Bool) {
        (spacer as! ModifierBox).expandVertically = expandVertically
    }

    public func getInheritedOrientation(of widget: Widget) -> InheritedOrientation? {
        let parent = widget.firstNonModifierParent() as? Box
        switch parent?.orientation {
            case .vertical:
                return .vertical
            case .horizontal:
                return .horizontal
            case nil:
                return nil
        }
    }

    public func createSlider(
        minimum: Double,
        maximum: Double,
        value: Double,
        decimalPlaces: Int,
        onChange: @escaping (Double) -> Void
    ) -> Widget {
        let scale = Scale()
        scale.expandHorizontally = true
        scale.minimum = minimum
        scale.maximum = maximum
        scale.value = value
        scale.digits = decimalPlaces
        scale.valueChanged = { widget in
            onChange(widget.value)
        }
        return scale
    }

    public func setMinimum(ofSlider slider: Widget, to minimum: Double) {
        (slider as! Scale).minimum = minimum
    }

    public func setMaximum(ofSlider slider: Widget, to maximum: Double) {
        (slider as! Scale).maximum = maximum
    }

    public func setValue(ofSlider slider: Widget, to value: Double) {
        (slider as! Scale).value = value
    }

    public func setDecimalPlaces(ofSlider slider: Widget, to decimalPlaces: Int) {
        (slider as! Scale).digits = decimalPlaces
    }

    public func setOnChange(ofSlider slider: Widget, to onChange: @escaping (Double) -> Void) {
        (slider as! Scale).valueChanged = { widget in
            onChange(widget.value)
        }
    }

    public func createTextField(
        content: String, placeholder: String, onChange: @escaping (String) -> Void
    ) -> Widget {
        let textField = Entry()
        textField.text = content
        textField.placeholderText = placeholder
        textField.changed = { widget in
            onChange(widget.text)
        }
        return textField
    }

    public func setContent(ofTextField textField: Widget, to content: String) {
        (textField as! Entry).text = content
    }

    public func setPlaceholder(ofTextField textField: Widget, to placeholder: String) {
        (textField as! Entry).placeholderText = placeholder
    }

    public func setOnChange(
        ofTextField textField: Widget, to onChange: @escaping (String) -> Void
    ) {
        (textField as! Entry).changed = { widget in
            onChange(widget.text)
        }
    }

    public func getContent(ofTextField textField: Widget) -> String {
        return (textField as! Entry).text
    }

    public func createListView() -> Widget {
        return SectionBox(orientation: .vertical, spacing: 0)
    }

    public func addChild(_ child: Widget, toListView listView: Widget) {
        (listView as! SectionBox).add(child)
    }

    public func removeChild(_ child: Widget, fromListView listView: Widget) {
        (listView as! SectionBox).remove(child)
    }

    public func updateListView(_ listView: Widget) {
        (listView as! SectionBox).update()
    }

    public func createOneOfContainer() -> Widget {
        return Stack(transitionDuration: 300, transitionType: .slideLeftRight)
    }

    public func addChild(_ child: Widget, toOneOfContainer container: Widget) {
        (container as! Stack).add(child, named: UUID().uuidString)
    }

    public func removeChild(_ child: Widget, fromOneOfContainer container: Widget) {
        (container as! Stack).remove(child)
    }

    public func setVisibleChild(ofOneOfContainer container: Widget, to child: Widget) {
        (container as! Stack).setVisible(child)
    }

    public func createSplitView(leadingChild: Widget, trailingChild: Widget) -> Widget {
        let widget = Paned(orientation: .horizontal)
        widget.startChild = leadingChild
        widget.endChild = trailingChild
        widget.shrinkStartChild = false
        widget.shrinkEndChild = false
        // Set the position to the farthest left possible.
        // TODO: Allow setting the default offset (SwiftUI api: `navigationSplitViewColumnWidth(min:ideal:max:)`).
        //   This needs frame modifier to be fledged out first
        widget.position = 0
        widget.expandVertically = true
        return widget
    }

    public func createPicker(
        options: [String], selectedOption: Int?, onChange: @escaping (Int?) -> Void
    ) -> Widget {
        let optionStrings = options.map({ "\($0)" })
        let widget = DropDown(strings: optionStrings)

        let options = options
        widget.notifySelected = { widget in
            if widget.selected >= options.count {
                onChange(nil)
            } else {
                onChange(widget.selected)
            }
        }
        return widget
    }

    public func setOptions(ofPicker picker: Widget, to options: [String]) {
        let picker = picker as! DropDown

        // Check whether the options need to be updated or not (avoiding unnecessary updates is
        // required to prevent an infinite loop caused by the onChange handler)
        var hasChanged = false
        for index in 0..<options.count {
            guard
                let item = gtk_string_list_get_string(picker.model, guint(index)),
                String(cString: item) == options[index]
            else {
                hasChanged = true
                break
            }
        }

        // picker.model could be longer than options
        if gtk_string_list_get_string(picker.model, guint(options.count)) != nil {
            hasChanged = true
        }

        guard hasChanged else {
            return
        }

        picker.model = gtk_string_list_new(
            UnsafePointer(
                options
                    .map({ UnsafePointer($0.unsafeUTF8Copy().baseAddress) })
                    .unsafeCopy()
                    .baseAddress
            )
        )
    }

    public func setSelectedOption(ofPicker picker: Widget, to selectedOption: Int?) {
        let picker = picker as! DropDown
        if selectedOption != picker.selected {
            picker.selected = selectedOption ?? Int(GTK_INVALID_LIST_POSITION)
        }
    }

    public func setOnChange(ofPicker picker: Widget, to onChange: @escaping (Int?) -> Void) {
        (picker as! DropDown).notifySelected = { picker in
            if picker.selected == GTK_INVALID_LIST_POSITION {
                onChange(nil)
            } else {
                onChange(picker.selected)
            }
        }
    }

    public func createFrameContainer(for child: Widget, minWidth: Int, minHeight: Int) -> Widget {
        setMinWidth(ofFrameContainer: child, to: minWidth)
        setMinHeight(ofFrameContainer: child, to: minHeight)
        return child
    }

    public func setMinWidth(ofFrameContainer container: Widget, to minWidth: Int) {
        container.css.set(properties: [.minWidth(minWidth)], clear: false)
    }

    public func setMinHeight(ofFrameContainer container: Widget, to minHeight: Int) {
        container.css.set(properties: [.minHeight(minHeight)], clear: false)
    }

    public func createForegroundColorContainer(for child: Widget, color: SwiftCrossUI.Color)
        -> Widget
    {
        let widget = ModifierBox()
        widget.setChild(child)
        setForegroundColor(ofForegroundColorContainer: widget, to: color)
        return widget
    }

    public func setForegroundColor(
        ofForegroundColorContainer container: Widget,
        to color: SwiftCrossUI.Color
    ) {
        (container as! ModifierBox).css.set(properties: [.foregroundColor(color.gtkColor)])
    }

    private class Tables {
        var tableSizes: [ObjectIdentifier: (rows: Int, columns: Int)] = [:]
    }

    private let tables = Tables()

    public func createTable(rows: Int, columns: Int) -> Widget {
        let widget = Grid()

        for i in 0..<rows {
            widget.insertRow(position: i)
        }

        for i in 0..<columns {
            widget.insertRow(position: i)
        }

        tables.tableSizes[ObjectIdentifier(widget)] = (rows: rows, columns: columns)

        widget.columnSpacing = 10
        widget.rowSpacing = 10

        return widget
    }

    public func setRowCount(ofTable table: Widget, to rows: Int) {
        let table = table as! Grid

        let rowDifference = rows - tables.tableSizes[ObjectIdentifier(table)]!.rows
        tables.tableSizes[ObjectIdentifier(table)]!.rows = rows
        if rowDifference < 0 {
            for _ in 0..<(-rowDifference) {
                table.removeRow(position: 0)
            }
        } else if rowDifference > 0 {
            for _ in 0..<rowDifference {
                table.insertRow(position: 0)
            }
        }

    }

    public func setColumnCount(ofTable table: Widget, to columns: Int) {
        let table = table as! Grid

        let columnDifference = columns - tables.tableSizes[ObjectIdentifier(table)]!.columns
        tables.tableSizes[ObjectIdentifier(table)]!.columns = columns
        if columnDifference < 0 {
            for _ in 0..<(-columnDifference) {
                table.removeColumn(position: 0)
            }
        } else if columnDifference > 0 {
            for _ in 0..<columnDifference {
                table.insertColumn(position: 0)
            }
        }

    }

    public func setCell(at position: CellPosition, inTable table: Widget, to widget: Widget) {
        let table = table as! Grid
        table.attach(
            child: widget,
            left: position.column,
            top: position.row,
            width: 1,
            height: 1
        )
    }
}
