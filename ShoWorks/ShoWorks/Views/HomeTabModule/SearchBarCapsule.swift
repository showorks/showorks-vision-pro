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
                
                
                if DataCenter.sharedInstance.searchedRecords.count > 0 {
                    
                    HStack{
                        ZStack{
                            Circle().fill(.white.opacity(0.2)).frame(width: 38)
                            Image(systemName: "chevron.left")
                                .font(.system(size: 12))
                        }
                        
                        Text("\(DataCenter.sharedInstance.searchedSelectedIndex + 1) /" + "\( DataCenter.sharedInstance.searchedRecords.count)")
                            .font(.system(size: 15))
                        
                        ZStack{
                            Circle().fill(.white.opacity(0.2)).frame(width: 38)
                            
                            Image(systemName: "chevron.right")
                                .font(.system(size: 12))
                        }
                    }
                }
                
                
                
//                Spacer()
                
                ZStack{
                    if DataCenter.sharedInstance.searchedRecords.count > 0 {
                        Capsule()
                            .fill(.clear)
                            .glassBackgroundEffect()
                            .frame(width: 530, height: 35)
                        
                    }else{
                        Capsule()
                            .fill(.clear)
                            .glassBackgroundEffect()
                            .frame(width: 690, height: 45)
                    }
                    
                    
                    HStack{
                        Image(systemName: "mic")
                            .font(.system(size: 14))
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
                        TextField("Search by exhibitor name or entry number..", text: $speechRecogniser.transcript)
                            .font(.system(size: 12))
                            .onSubmit {
                               
                                if Utilities.sharedInstance.checkStringContainsText(text: speechRecogniser.transcript){
                                    DataCenter.sharedInstance.searchTextAndFindModels()
                                }
                            }
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
