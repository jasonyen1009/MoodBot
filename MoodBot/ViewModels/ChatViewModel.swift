//
//  ChatViewModel.swift
//  MoodBot
//
//  Created by Yen Hung Cheng on 2023/6/30.
//

import SwiftUI
import OpenAISwift
import AVFoundation
import NaturalLanguage

final class ViewModel: ObservableObject {
    init() {}
    
    private var client: OpenAISwift?
    
    func setup() {
        client = OpenAISwift(authToken: "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")
        
    }
    
    func send(text: String, maxTokens: Int,
              completion: @escaping (String) -> Void) {
        client?.sendCompletion(with: text,
                               maxTokens: maxTokens,
                               completionHandler: { result in
            switch result {
            case .success(let model):
                let output = model.choices?.first?.text ?? ""
                completion(output)
            case .failure:
                break
            }
        })
    }
}


struct ChatViewModel: View {
    
    @ObservedObject var viewModel = ViewModel()
    @State var text = ""
    @State var models = [String]()
    
    // 回覆的語言，預設為 英文
    @State private var replyLanguage = "English"
    @State var selectedSegment1: Segment = .English
    @State var token = 200
    @State private var showBool = false

    @StateObject private var speechManager = SpeechManager()
    
    // AR
    @State private var analysis = "analysis"
    @State private var isDetecting = false
    @State var showAR: Bool = false
    @State var mood: String = ""

    

    
    
    @State var openAI = [
        "CNN stands for Convolutional Neural Network. It is a type of deep learning algorithm that is widely used for image classification, object detection, and computer vision tasks. CNNs are particularly effective in analyzing visual data due to their ability to automatically learn and extract relevant features from images.The key components of a CNN are convolutional layers, pooling layers, and fully connected layers. Convolutional layers apply convolution operations to input images, applying filters to detect different features. Pooling layers downsample the feature maps, reducing their spatial dimensions. Fully connected layers connect the extracted features to the output layer for classification or regression.",
        "The Transformer architecture is based on the concept of self-attention mechanism, also known as scaled dot-product attention. It enables the model to focus on different parts of the input sequence while processing it. Unlike recurrent neural networks (RNNs) or convolutional neural networks (CNNs), the Transformer does not rely on sequential or convolutional operations, making it highly parallelizable and more efficient for processing long-range dependencies.",
        "こんにちは！何かお手伝いできることはありますか？"
        
    ]
    
    @State var moodArray = [String]()
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(alignment: .leading, spacing: 20) {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            ForEach(models.indices, id: \.self) { index in
                                if (index % 2) != 0 {
                                    TextRowView(text: models[index], image: Image("openAI"), bool: true, doneBool: $showAR)
                                }else {
                                    TextRowView(text: models[index], image: Image(""), bool: false, doneBool: $showAR)
                                }
                            }
                            Spacer()
                        }
                    }
                    
                    // 判斷是否有在使用 AVSpeechSynthesizer 說話
                    if speechManager.isSpeaking {
                        HStack(spacing: 50) {
                            Spacer()
                            Text("Speaking...")
                            Spacer()
                            Button {
                                speechManager.synthesizer.stopSpeaking(at: .immediate)
                            } label: {
                                Image(systemName: "stop.circle")
                                    .foregroundColor(.red)
                            }
                        }
                    }else {
                        HStack {
                            TextField("Message", text: $text, onCommit: {
                                send()
                            })
                            .textFieldStyle(.roundedBorder)
                            
                            if text == "" {
                                Image(systemName: "arrow.up.circle.fill")
                                    .foregroundColor(.gray)
                            }else {
                                Button {
                                    send()
                                    print(models)
                                } label: {
                                    Image(systemName: "arrow.up.circle.fill")
                                        .foregroundColor(Color(red: 102/255, green: 66/255, blue: 1))
                                }
                            }
                        }
                    }
                    
                    
                    
                }
                .onAppear {
                    viewModel.setup()
                }
                .toolbar {
                    Button {
                        showBool.toggle()
                    } label: {
                        Image(systemName: "gearshape")
                    }
                    .sheet(isPresented: $showBool) {
                        LanguageViewModel(selectedSegment1: $selectedSegment1, language: $replyLanguage, closeBool: $showBool, token: $token)
                            .presentationDetents([.height(250), .medium])
                    }
                }
                .padding()
                // 第二層
                if showAR {
                    VStack {
                        Text(analysis)
                            .font(.title2)
                            .padding()
                            .background(.black)
                            .foregroundColor(.green)
                            .cornerRadius(25)
                        Spacer()
                        ARViewContainer(analysis: $analysis, isDetecting: $showAR)
                            .frame(width: 1, height: 1) // 設置 ARView 的高度
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                    showAR = false
//                                    switch analysis {
//                                    case "不是很滿意🙂":
//                                        mood = "🙂"
//                                    case "非常不滿意😡":
//                                        mood = "😡"
//                                    default:
//                                        mood = "😄"
//                                    }
                                    
                                }
                                
                            }
                    }
                }
                
                
            }
        }
        
        
    }
    
    func send() {
        guard !text.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }

        models.append("\(text)")

        viewModel.send(text: text, maxTokens: token) { response in
            DispatchQueue.main.async {
//                self.models.append(response.trimmingCharacters(in: .whitespacesAndNewlines))
                let message = openAI[0]
                models.append(openAI.remove(at: 0))
//                print(response.trimmingCharacters(in: .whitespacesAndNewlines))
                speechManager.speak(text: message)
                // 重置文本
                self.text = ""
                print(openAI)
            }
        }
    }
    
//    func send() {
//        guard !text.trimmingCharacters(in: .whitespaces).isEmpty else {
//            return
//        }
//
//        models.append("\(text)")
//
////        let chatMessage = "?           Hello! How can I assist you today?"
////        let chatMessage = "你好！有什么我可以帮助你的吗？"
//        let chatMessage = "こんにちは！何かお手伝いできることはありますか？"
//
//
//
//        viewModel.send(text: chatMessage, maxTokens: token) { response in
//            DispatchQueue.main.async {
//
//                // newresponse 保存最初的 response
////                var newresponse = response
//                var newresponse = chatMessage
//
//                // 有時候最前面會產生 ? 必須移除
//                // response 定義是 let 不能移除
//                if newresponse.hasPrefix("?") || newresponse.hasPrefix("!") {
//                    newresponse.removeFirst()
//                }
////                self.models.append(newresponse.trimmingCharacters(in: .whitespacesAndNewlines))
//                // 將空白部分移除
//                models.append(newresponse.trimmingCharacters(in: .whitespacesAndNewlines))
//
//                print(newresponse.trimmingCharacters(in: .whitespacesAndNewlines))
//                speechManager.speak(text: newresponse.trimmingCharacters(in: .whitespacesAndNewlines))
//
//                // 重置文本
//                self.text = ""
//            }
//        }
//    }

    
    
    
}

struct ChatViewModel_Previews: PreviewProvider {
    static var previews: some View {
        ChatViewModel()
    }
}


class SpeechManager: NSObject, ObservableObject {
    
    @Published var isSpeaking = false
    let synthesizer = AVSpeechSynthesizer()
    func speak(text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: returnLanguage(text))
        synthesizer.speak(utterance)
    }

    override init() {
        super.init()
        synthesizer.delegate = self
    }
    
    // 回傳要合成聲音的語言
    func returnLanguage(_ input_text: String) -> String {
        let languageRecognizer = NLLanguageRecognizer()
        languageRecognizer.processString(input_text)
        var Language = ""
        if let dominantLanguage = languageRecognizer.dominantLanguage {
            // 判斷為哪一種語言
            switch String(dominantLanguage.rawValue) {
            case "en":
                Language = "en-US"
            case "ja":
                Language = "ja-JP"
            case "zh-Hant":
                Language = "zh-TW"
            // 有時候會得到 簡體中文
            case "zh-Hans":
                Language = "zh-TW"
            default:
                Language = "en-US"
            }
        }
        return Language
    }
    
    
    
}

extension SpeechManager: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        DispatchQueue.main.async {
            self.isSpeaking = true
        }
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        DispatchQueue.main.async {
            self.isSpeaking = false
        }
    }
}
