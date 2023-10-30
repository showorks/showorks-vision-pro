//
//  SearchBarCapsule.swift
//  VisionOSScreens
//
//  Created by Lokesh Sehgal on 28/10/23.
//

import SwiftUI

struct SearchBarCapsule: View {
    
//    @State var typedText: String = ""
    @StateObject var speechRecogniser = SpeechRecognizer()
    @State var isRecording: Bool = false
    
    
    var body: some View {
        ZStack{
            Capsule()
                .fill(.white.opacity(0.3))
                .frame(width: 700, height: 55)
                .glassBackgroundEffect()
            
            HStack(spacing: 25){
                HStack{
                    ZStack{
                        Circle().fill(.white.opacity(0.2)).frame(width: 38)
                        Image(systemName: "chevron.left")
                            .font(.system(size: 12))
                    }
                    Text("2/5")
                        .font(.system(size: 15))
                    ZStack{
                        Circle().fill(.white.opacity(0.2)).frame(width: 38)
                        
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12))
                    }
                }
                
//                Spacer()
                
                ZStack{
                    Capsule()
                        .fill(.clear)
                        .glassBackgroundEffect()
                        .frame(width: 530, height: 35)
                    
                    HStack{
                        Image(systemName: "mic")
                            .font(.system(size: 12))
                            .foregroundStyle(isRecording ? .blue : .white)
                            .padding(.leading, 10)
                            .onTapGesture {
                                if !isRecording {
                                    speechRecogniser.transcribe()
                                } else {
                                    speechRecogniser.stopTranscribing()
                                }
                                
                                isRecording.toggle()
                            }
                        TextField("Search by name/tag/entryNumber", text: $speechRecogniser.transcript)
                    }
                }
                .frame(width: 530)
            }
            .padding(.horizontal, 5)
            .frame(width: 700)
            
        }
        .frame(width: 700)
    }
}

#Preview {
    SearchBarCapsule()
}
