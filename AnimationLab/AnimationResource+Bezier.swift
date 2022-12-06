//
//  AnimationResource+Bezier.swift
//  AnimationLab
//
//  Created by Mikael Deurell on 2022-12-06.
//

import Foundation
import RealityKit

extension AnimationResource {
    static func quadracticBezierAnimation(start: simd_float3,
                                                 control: simd_float3,
                                                 end: simd_float3,
                                                 step: Double = 0.02,
                                                 speed: Double = 1,
                                                 timingFunction: (Float) -> Float = {$0}) -> AnimationResource? {
        var transforms: [Transform] = []
        for i in stride(from: 0.0, to: 1.0, by: step) {
            transforms.append(Transform(translation: getQuadraticBezierPoint(start: start,
                                                                             control: control,
                                                                             end: end,
                                                                             t: timingFunction(Float(i))
                                                                            ))
            )
        }
        var animationDefinition = SampledAnimation(frames: transforms, frameInterval: 0.75, bindTarget: .transform)
        animationDefinition.tweenMode = .linear
        animationDefinition.speed = Float(speed)
        let animationResource = try? AnimationResource.generate(with: animationDefinition)
        return animationResource
    }
    
    private static func getQuadraticBezierPoint(start: simd_float3, control: simd_float3, end: simd_float3, t: Float) -> simd_float3 {
        let t2 = t * t
        let a = (2 * t - 2 * t2)
        let b = (t2 - 2 * t + 1)
        let res = t2 * end + a * control + b * start
        return res
    }
    
    static func quadraticEaseIn(_ t: Float) -> Float {
        return t * t
    }
    
    static func quadraticEaseOut(_ t: Float) -> Float {
        return -t * (t - 2)
    }
    
    static func quadraticEaseInOut(_ t: Float) -> Float {
        if t < 0.5 {
            return 2 * t * t
        } else {
            return (-2 * t * t) + (4 * t) - 1
        }
    }
}
