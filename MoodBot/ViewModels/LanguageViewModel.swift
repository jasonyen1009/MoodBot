//
//  LanguageViewModel.swift
//  MoodBot
//
//  Created by Yen Hung Cheng on 2023/7/1.
//

import SwiftUI

struct LanguageViewModel: View {
    
    @Binding var selectedSegment1: Segment

    @State var animation: Animation = .spring(response: 0.6, dampingFraction: 0.6, blendDuration: 0.6)
    @State var themeColor: Color = Color(red: 102/255, green: 66/255, blue: 1)
    @State var cornerRadius: CGFloat = 20
    @State var selectedAnimationIndex: Int = 0
    // 目前選定的語言
    @Binding var language: String
    
    @Binding var closeBool: Bool
    
    @Binding var token: Int
    
    
    var body: some View {
        
        NavigationStack {
            GeometryReader { bounds in
                VStack(spacing: 10) {
                    Text("Select chat reply language")
                        .font(.title)
                    VStack(spacing: 20) {
                        SegmentControlView(segments: Segment.allCases,
                                           selected: $selectedSegment1,
                                           titleNormalColor: themeColor,
                                           titleSelectedColor: .white,
                                           bgColor: themeColor,
                                           animation: animation) { segment in
                            Text(segment.title)
                                .font(.system(size: 20, weight: .semibold, design: .rounded))
                                .padding(.horizontal)
                                .padding(.vertical, 8)
                            
                        } background: {
                            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        }
                        .frame(height: 37)
                        
                        Text("maxToken : \(token)")
                        
                        Slider(value: Binding<Double>(
                                        get: { Double(token) },
                                        set: { token = Int($0) }
                                    ), in: 200...1000)
                        .accentColor(Color(red: 102/255, green: 66/255, blue: 1))

                        
                    }
                    .padding()
                    .background(Color.white.cornerRadius(20))
                    .onChange(of: selectedSegment1) { newValue in
    //                    print("is \(newValue)")
                        language = "\(newValue)"
                        switch language {
                        case "English":
                            token = 200
                        case "TraditionalChinese":
                            token = 700
                        case "Japanese":
                            token = 700
                        default:
                            token = 200
                        }
                    }

                }
                .padding(.top, 0)
                .padding(.horizontal)
                .toolbar {
                    Button {
                        closeBool = false
                    } label: {
                        Image(systemName: "x.circle.fill")
                            .resizable()
                            .font(.title3)
                            .foregroundColor(Color(red: 128/255, green: 128/255, blue: 132/255))
                    }
                }
            }
        }
    }
    
}

struct LanguageViewModel_Previews: PreviewProvider {
    static var previews: some View {
        LanguageViewModel(selectedSegment1: .constant(Segment.English), language: .constant("English"), closeBool: .constant(true), token: .constant(200))
    }
}
