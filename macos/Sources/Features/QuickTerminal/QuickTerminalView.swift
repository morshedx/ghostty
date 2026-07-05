import SwiftUI
import UniformTypeIdentifiers

struct QuickTerminalView: View {
    @ObservedObject var ghostty: Ghostty.App

    var controller: QuickTerminalController
    @ObservedObject var tabManager: QuickTerminalTabManager

    var body: some View {
        let tabBarPosition = ghostty.config.quickTerminalTabBarPosition
        VStack(spacing: 0) {
            if tabBarPosition == .top {
                tabBar
            }
            TerminalView(
                ghostty: ghostty,
                viewModel: controller,
                delegate: controller,
            )
            .onDrop(of: [.quickTerminalTab], isTargeted: nil) { _ in
                // Tab dropped on terminal surface - move to new window
                if let tab = tabManager.draggedTab {
                    tabManager.moveTabToNewWindow(tab)
                    return true
                }
                return false
            }
            if tabBarPosition == .bottom {
                tabBar
            }
        }
    }

    @ViewBuilder private var tabBar: some View {
        if tabManager.tabs.count > 1 {
            QuickTerminalTabBarView(ghostty: ghostty, tabManager: tabManager)
        }
    }
}
