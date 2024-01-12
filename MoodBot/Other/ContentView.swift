//
//  ContentView.swift
//  MoodBot
//
//  Created by Yen Hung Cheng on 2023/6/26.
//

import SwiftUI
import ARKit

struct ContentView: View {
    @State private var analysis = ""
    @State private var isDetecting = false

    var body: some View {
        VStack {
            
            if isDetecting {
                Text(analysis)
                    .font(.title2)
                    .padding()
                    .background(.black)
                    .foregroundColor(.green)
                    .cornerRadius(25)
                
                ARViewContainer(analysis: $analysis, isDetecting: $isDetecting)
                    .frame(height: 200) // 設置 ARView 的高度
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            isDetecting = false
                        }
                    }
            }
            
            Button(action: {
                self.isDetecting.toggle()
            }) {
                Text(isDetecting ? "停止偵測" : "開始偵測")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
    }
}

//struct ARViewContainer: UIViewRepresentable {
//    @Binding var analysis: String
//    @Binding var isDetecting: Bool
//
//    func makeUIView(context: Context) -> ARSCNView {
//        let arView = ARSCNView()
//        arView.delegate = context.coordinator
//        let configuration = ARFaceTrackingConfiguration()
//        arView.session.run(configuration)
//
//        // 背景顏色
////        arView.scene.background.contents = UIColor.white
//
//        return arView
//    }
//
//    func updateUIView(_ uiView: ARSCNView, context: Context) {
//        // Update analysis label
//    }
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(analysis: $analysis, isDetecting: $isDetecting)
//    }
//
////    class Coordinator: NSObject, ARSCNViewDelegate {
////        @Binding var analysis: String
////        @Binding var isDetecting: Bool
////
////        init(analysis: Binding<String>, isDetecting: Binding<Bool>) {
////            _analysis = analysis
////            _isDetecting = isDetecting
////        }
////
////        func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
////            guard isDetecting else { return }
////
////            if let faceAnchor = anchor as? ARFaceAnchor {
////                expression(anchor: faceAnchor)
////
////                DispatchQueue.main.async {
////                    self.analysis = self.analysis
////                }
////            }
////        }
////
////        func expression(anchor: ARFaceAnchor) {
////            // 情緒偵測邏輯
////            let smileLift = anchor.blendShapes[.mouthSmileLeft]
////            let smileRight = anchor.blendShapes[.mouthSmileRight]
////
////            let frownLeft = anchor.blendShapes[.browDownLeft]
////            let frownRight = anchor.blendShapes[.browDownRight]
////
////            let eyeBlinkLeft = anchor.blendShapes[.eyeBlinkLeft]
////            let eyeBlinkRight = anchor.blendShapes[.eyeBlinkRight]
////
////
////
////            if ((frownLeft?.decimalValue ?? 0.0) + (frownRight?.decimalValue ?? 0.0)) > 0.9 {
////                self.analysis = "正在憤怒😡"
////                print(analysis)
////            }
////
////            if ((smileLift?.decimalValue ?? 0.0) + (smileRight?.decimalValue ?? 0.0)) > 0.9 {
////                self.analysis = "正在微笑😄"
////                print(analysis)
////
////            }
////
////            if ((eyeBlinkLeft?.decimalValue ?? 0.0) + (eyeBlinkRight?.decimalValue ?? 0.0)) > 0.9 {
////                self.analysis = "正在眨眼🤩"
////                print(analysis)
////
////            }
////
////            if ((smileLift?.decimalValue ?? 0.0) + (smileRight?.decimalValue ?? 0.0)) < 0.1 {
////                self.analysis = "正在無奈🙂"
////                print(analysis)
////            }
////
////        }
////    }
//}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
