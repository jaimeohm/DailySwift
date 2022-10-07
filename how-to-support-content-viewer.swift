// On .accessibilityShowsLargeContentViewer:
// Enable large content viewer for custom button
LocationButton()
    .accessibilityShowsLargeContentViewer {
        Label("Recenter", systemImage: "location")
    }
    
// On .dynamicTypeSize
// Set a maximum size for this element
LocationButton()
    .dynamicTypeSize(...DynamicTypeSize.xxxLarge)

// On .accessibilityLargeContentViewerEnabled
// On .onlongPressGesture 
// Display content viewer first (2s) then do gesture action
// 
@Environment(\.accessibilityLargeContentViewerEnabled)
var largeContentViewerEnabled
var body: some View {
    LocationButton()
        .onLongPressGesture(
            minimumDuration: largeContentViewerEnabled ? 2 : 0.5
        ) {
            showOverlay = true
        }
}

// Source: 
// - https://nilcoalescing.com/blog/ResizingSFSymbolsInSwiftUI/
