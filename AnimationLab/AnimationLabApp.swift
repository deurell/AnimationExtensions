import SwiftUI

@main
struct AnimationLabApp: App {
    
    init() {
        AnimationLabSystem.registerSystem()
        AnimationComponent.registerComponent()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
