//
//  ARModel.swift
//  MoodBot
//
//  Created by Yen Hung Cheng on 2023/7/1.
//

import Foundation

import Foundation
import RealityKit
import ARKit
import SwiftUI

class Coordinator: NSObject, ARSCNViewDelegate {
    @Binding var analysis: String
    @Binding var isDetecting: Bool

    init(analysis: Binding<String>, isDetecting: Binding<Bool>) {
        _analysis = analysis
        _isDetecting = isDetecting
    }

    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard isDetecting else { return }

        if let faceAnchor = anchor as? ARFaceAnchor {
            expression(anchor: faceAnchor)

            DispatchQueue.main.async {
                self.analysis = self.analysis
            }
        }
    }

    func expression(anchor: ARFaceAnchor) {
        // 情緒偵測邏輯
        let smileLift = anchor.blendShapes[.mouthSmileLeft]
        let smileRight = anchor.blendShapes[.mouthSmileRight]
                    
        let frownLeft = anchor.blendShapes[.browDownLeft]
        let frownRight = anchor.blendShapes[.browDownRight]

        
        if ((smileLift?.decimalValue ?? 0.0) + (smileRight?.decimalValue ?? 0.0)) < 0.4 {
            // 正在無奈
            self.analysis = "不是很滿意🙂"
        }
        
        if ((frownLeft?.decimalValue ?? 0.0) + (frownRight?.decimalValue ?? 0.0)) > 0.9 {
            // 正在憤怒
            self.analysis = "非常不滿意😡"
        }
                    
        if ((smileLift?.decimalValue ?? 0.0) + (smileRight?.decimalValue ?? 0.0)) > 0.9 {
            // 正在微笑
            self.analysis = "滿意答覆😄"
        }
        
    }
}
