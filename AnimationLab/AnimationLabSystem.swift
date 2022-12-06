import RealityKit

class AnimationLabSystem: RealityKit.System {
    static let diceComponentQuery = EntityQuery(where: .has(AnimationComponent.self))
    var time: Double = 0
    
    required init(scene: RealityKit.Scene) {
    }
    
    func update(context: SceneUpdateContext) {
        self.time += context.deltaTime
    }
}
