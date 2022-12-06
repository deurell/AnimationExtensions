import SwiftUI
import RealityKit

struct ContentView: View {
    
    var body: some View {
        ARContainer().ignoresSafeArea()
    }
}

struct ARContainer: UIViewRepresentable {
    func makeUIView(context: Context) -> some AnimationARView {
        let arView = AnimationARView(frame: .zero)
        arView.setup()
        return arView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
}

struct AnimationComponent: Component {}
