//
//  TextRowView.swift
//  MoodBot
//
//  Created by Yen Hung Cheng on 2023/6/30.
//

import SwiftUI

struct TextRowView: View {

    var text = "What is CNN in ML??"
    var image: Image

    @State var bool = true
    
    // 逐個字元進行顯示 property
    @State private var displayText = ""
    @State private var currentIndex = 0
    @State private var isDisplayingText = false
    // 判斷 Chat 是否已經產生完字
    @Binding var doneBool: Bool
    // 顯示情緒的圖示
//    let moodText: String
    
    
    
    var body: some View {
        
        HStack(alignment: .top) {
            
            if bool == false {
                Spacer()
            }
            
            image
                .resizable()
                .scaledToFill()
                .frame(width: bool ? 50 : 0, height: bool ? 50 : 0)
                .clipShape(Circle())
            
            
            Text("\(bool ? displayText : text)")
                .padding()
                .background(bool ? Color(red: 102/255, green: 66/255, blue: 1) : Color(red: 239/255, green: 239/255, blue: 239/255))
                .foregroundColor(bool ? Color.white : Color.black)
                .cornerRadius(15)
                .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
            
            // 確保一開始產生的 Image 在最左邊
            if bool {
                Spacer()
            }
        }
        .onAppear {
            startDisplayingText(text: text)
        }
    }
    
    // 逐個字元進行顯示
    func startDisplayingText(text: String) {
        currentIndex = 0
        isDisplayingText = true
        
        // 確保程式只給 chat 執行 
        if bool {
            Timer.scheduledTimer(withTimeInterval: 0.005, repeats: true) { timer in
                if currentIndex < text.count {
                    let index = text.index(text.startIndex, offsetBy: currentIndex)
                    displayText = String(text[...index])
                    currentIndex += 1
                } else {
                    timer.invalidate()
                    isDisplayingText = false
                    doneBool = true
                }
            }
        }
    }
}

struct TextRowView_Previews: PreviewProvider {
    static var previews: some View {
        TextRowView(image: Image("openAI"), doneBool: .constant(false))
        
    }
}

//struct FirstLetterAnimationModifier: ViewModifier {
//    var isAnimating: Bool
//    func body(content: Content) -> some View {
//        content.overlay(
//            RoundedRectangle(cornerRadius: 15)
//                .stroke(lineWidth: isAnimating ? 3 : 0)
//                .foregroundColor(Color.blue)
//                .scaleEffect(isAnimating ? 1.2 : 1)
//                .opacity(isAnimating ? 0.5 : 0)
//                .animation(Animation.easeInOut(duration: 0.5).repeatForever(autoreverses: true))
//        )
//    }
//}

