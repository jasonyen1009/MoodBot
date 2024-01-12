//
//  ARViewModel.swift
//  MoodBot
//
//  Created by Yen Hung Cheng on 2023/6/29.
//

import Foundation
import RealityKit
import ARKit
import SwiftUI


struct ARViewContainer: UIViewRepresentable {
    @Binding var analysis: String
    @Binding var isDetecting: Bool

    func makeUIView(context: Context) -> ARSCNView {
        let arView = ARSCNView()
        arView.delegate = context.coordinator
        let configuration = ARFaceTrackingConfiguration()
        arView.session.run(configuration)

        // 背景顏色
        arView.scene.background.contents = UIColor.white

        return arView
    }

    func updateUIView(_ uiView: ARSCNView, context: Context) {
        // Update analysis label
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(analysis: $analysis, isDetecting: $isDetecting)
    }

}

