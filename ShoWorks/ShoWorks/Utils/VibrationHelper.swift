//
//  VibrationHelper.swift
//  ShoWorks
//
//  Created by Lokesh on 21/07/23.

import Foundation
import AVFoundation

class VibrationHelper {
    
    static func vibrate() {
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
    
    static func longVibrate(){
        AudioServicesPlaySystemSoundWithCompletion(kSystemSoundID_Vibrate) {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        }
    }
}
