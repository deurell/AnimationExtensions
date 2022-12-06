import Foundation
import RealityKit
import SwiftUI
import Combine

class AnimationARView: ARView {
    
    var arView: ARView { return self }
    var anchor: AnchorEntity?
    var camera: Entity?
    var plane: Entity?
    var entity: Entity?
    var fish: Entity?
    
    required init(frame frameRect: CGRect) {
        super.init(frame: frameRect)
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("not implemented")
    }
    
    func setup() {
        arView.cameraMode = .nonAR
        arView.automaticallyConfigureSession = false
        setupScene()
        setupGestureRecognizers()
    }
    
    private func setupGestureRecognizers() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    private func setupScene() {
        let anchor = AnchorEntity(world: .zero)
        let camera = PerspectiveCamera()
        camera.position = Constants.cameraPosition
        camera.look(at: [0, 8, -8],
                    from: camera.position,
                    upVector: [0, 1, 0],
                    relativeTo: nil)
        anchor.addChild(camera)
        
        let directionalLight = DirectionalLight()
        directionalLight.light.color = .white
        directionalLight.light.intensity = 4000
        directionalLight.light.isRealWorldProxy = true
        directionalLight.shadow = DirectionalLightComponent.Shadow(maximumDistance: 50,
                                                                   depthBias: 5.0)
        directionalLight.position = [1, 8, 5]
        directionalLight.look(at: [-2, -2, -4],
                              from: directionalLight.position,
                              relativeTo: nil)
        anchor.addChild(directionalLight)
        
        let planeMesh: MeshResource = .generateBox(size: [100, 100, 1])
        let planeMaterial = SimpleMaterial(color: .gray,
                                           roughness: 0.5,
                                           isMetallic: false)
        let planeEntity = ModelEntity(mesh: planeMesh, materials: [planeMaterial])
        planeEntity.position = [0, 0, 0]
        planeEntity.transform.rotation = simd_quatf(angle: Float.pi/2,
                                                    axis: [1, 0, 0])
        planeEntity.collision = CollisionComponent(shapes: [.generateBox(size: [2000, 1000, 10])])
        planeEntity.physicsBody = PhysicsBodyComponent(massProperties: .default,
                                                       material: .default,
                                                       mode: .static)
        self.plane = planeEntity
        anchor.addChild(planeEntity)
        
        guard let fish = try? Entity.load(named: "fish_sardine") else {fatalError()}
        fish.position = Constants.fishStartPosition
        fish.scale = [1, 1, 1]
        self.fish = fish
        anchor.addChild(fish)
        
        scene.anchors.append(anchor)
        
    }
        
    @IBAction func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        guard gestureRecognizer.view != nil else { return }
        if gestureRecognizer.state == .ended {
            if let fish = self.fish {
                guard let animationFromUsdz = fish.availableAnimations.first,
                      let bezierAnimationResource = AnimationResource.quadracticBezierAnimation(start: Constants.fishStartPosition,
                                                                                                control: [12, 16, 12],
                                                                                                end: Constants.fishEndPosition,
                                                                                                speed: 5.9,
                                                                                                timingFunction: AnimationResource.quadraticEaseInOut),
                      let animationGroup = try? AnimationResource.group(with: [animationFromUsdz, bezierAnimationResource])
                else {fatalError()}
                fish.playAnimation(animationGroup)
            }
        }
    }
}

enum Constants {
    static let fishStartPosition: simd_float3 = [0, 2, -10]
    static let fishEndPosition: simd_float3 = [-4, 2, -2]
    static let cameraPosition: simd_float3 = [0, 20, 20]
}
