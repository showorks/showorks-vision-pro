//
//  HomeContentView.swift
//  VisionOSScreens
//
//  Created by Lokesh Sehgal on 27/10/23.
//

import SwiftUI
import RealityKit
import RealityKitContent

class Entry: Identifiable{
    var id: UUID
    var exhibitor: String
    var department: String
    var club: String
    var entryNumber: String
    var wen: String
    var division: String
    var Class: String
    var description: String
    var validationNumber: String
    var entryValidationDate: String
    var stateFair: String
    var salePrice: String
    
    init(exhibitor: String, department: String, club: String, entryNumber: String, wen: String, division: String, Class: String, description: String, validationNumber: String, entryValidationDate: String, stateFair: String, salePrice: String) {
        self.id = UUID()
        self.exhibitor = exhibitor
        self.department = department
        self.club = club
        self.entryNumber = entryNumber
        self.wen = wen
        self.division = division
        self.Class = Class
        self.description = description
        self.validationNumber = validationNumber
        self.entryValidationDate = entryValidationDate
        self.stateFair = stateFair
        self.salePrice = salePrice
    }
}

enum Tabs: String{
    case tab1, tab2, tab3
}


//1024
struct HomeContentView: View {
    
    @State var selectedTab: Tabs = .tab1
    @State private var offsetY: CGFloat = 0
    @State private var isDragging = false
    @State var isDeviceConnected = false
    @State var searchRecordContainsData = false
    var body: some View {
        
        ZStack{
            ShoWorksBackground()
//                .resizable()
//                .frame(width: 1366, height: 824)
            
            
            HStack(spacing: 20){
                
                customTab
                
                if selectedTab == .tab1{
                    ZStack{
                        VStack(spacing: 20){
                           
                            if searchRecordContainsData {
                                
                                SearchBarCapsule()
                                    .padding(.top, 100)
                                
                                HomeTabLayout()
                                    .frame(width: 960, height: 540)
                                    .glassBackgroundEffect()
                                    .padding(.bottom, 40)
                                
                                    HomeBottomCapsule()
                                        .offset(y:-88)

                            }else{
                                SearchBarCapsule()
                                
                                if DataCenter.sharedInstance.isDeviceConnected {
                                    QRScanTabView().frame(width: 960, height: 540)
                                        .glassBackgroundEffect()
                                        .padding(.bottom, 40)
                                }else{

                                    ConnectSearchView()
                                        .frame(width: 960, height: 540)
                                        .glassBackgroundEffect()
                                        .padding(.bottom, 40)
                                }
                             
                            }
                                
                        }
//                        VStack{
//                            Spacer()
//                            
//                            HomeBottomCapsule()
//                                .padding(.bottom, 90)
//                        }
                        
                            
                    }
                }else if selectedTab == .tab2{
                    ZStack{
                        Color.white.opacity(0.3)
                            .frame(width: 960, height: 540)
                            .glassBackgroundEffect()
                        
                            QRScanDisconnectedTabView()
                        
                    }
                }else{
                    ZStack{
                        Color.white.opacity(0.3)
                            .frame(width: 960, height: 540)
                            .glassBackgroundEffect()
                        
                        SettingsLayout()
                    }
                }
                
                
            }
        }
        .onReceive(.searchRecordChangesNotification) { info in

                        let searchRecordHasData = (info.object as? Bool) ?? false

                        self.searchRecordContainsData = searchRecordHasData

        }
        .navigationBarHidden(true)
        
    }
}

#Preview(windowStyle: .automatic) {
    HomeContentView()
        
}


struct QRScanTabView: View {
    
    var body: some View {
        ZStack(){
            
            VStack(alignment: .center, content: {
                
                Image("connected_state")
              
                Text("Device is connected and ready to scan")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .font(.system(size: 30))
                    .padding(.top,40)
               
                
            })
                        
        }
    }
}


struct QRScanDisconnectedTabView: View {
    
    var body: some View {
        ZStack(){
            
            VStack(alignment: .center, content: {
                
               
                ScrollView(){
                    Image("not_connected")
                        .padding(.top,60)
                  
                    Divider()
                        .background(Color.white)
                        .frame(width: 960)
                        .padding(.top,20)
                   
                    Text("How to connect your scanner device via Bluetooth ?")
                        .padding(.top,20).font(.system(size: 20))
                        .fontWeight(.bold)
                        .frame(alignment: .leading)
                    
                    Text("1. Go to the Bluetooth Connection Instruction Manual. \n\n2. Press scanner's button to power on the scanner. \n\n3. Bluetooth HID mode is usually set by default on new devices. ShoWorks uses the newer BLE mode for more efficient and reliable data communications and you must charge your device to this mode by scanning the code below or found in your instruction manual. \n\n4. Make sure the device is configured to use Bluetooth mode instead of USB. Please scan the following barcode to allow the device to work with Bluetooth mode.")
                        .padding(.top,20).font(.system(size: 15))
                        .frame(width: 860)
                        .frame(alignment: .leading)
                    
                    Image("netum_bluetooth")
                        .padding(.top,20)
                    Text("\n\n5. BLE Mode Serial Port Profile- For iOS Devices By scanning below barcode scanner will enter BLE Mode for ShoWorks Vision Pro app.")
                        .padding(.top,20).font(.system(size: 15))
                        .frame(width: 860)
                        .frame(alignment: .leading)
                    
                    Image("netum_scan")
                    
                    Text("\n\n6. Once the above barcode has been scanned with the Bluetooth scanner, it will automatically connect with the ShoWorks Vision app each time you start the app, however this initial setup requires that you force close (\"kill\") the app after the configuration has been made for the first time. There is a small dot appearing below the ShoWorks Vision Pro app screen, you can tap on it force close the app. \n\n7. If the Bluetooth scanner has been successfully paired with the Vision Pro prior and is active, a beep sound and brief visual message will occur when the ShoWorks Vision Pro App is launched, indicating that the two devices are now properly communicating. \n\nTROUBLESHOOTING: If the two devices do not seem to be communicating, try the following: \n\n - Force close the ShoWorks Vision Pro App and relaunch (See Vision OS documentation on how to force close apps). \n - Perform a hard reset on the Bluetooth scanner. The barcode below will hard reset your scanner. Once a hard reset has been made, you must again scan the two other barcodes with the scanner to \"Work with Bluetooth\" and \"BLE Mode\" (AT+MODE=3). After this has been done, you must force close the ShoWorks Vision Pro App and relaunch.")
                        .padding(.top,20).font(.system(size: 15))
                        .frame(width: 860)
                        .frame(alignment: .leading)
                    
                    Text("\n\n From your Vision Pro...")
                        .padding(.top,20).font(.system(size: 20))
                        .fontWeight(.bold)
                        .frame(alignment: .leading)
                    
                    Text("\n1. Go to the Settings app on the Vision Pro. \n\n2. Tap Bluetooth option from the list. \n\n3. Make sure to turn it on. If you do not see your handheld scanner in the list, make sure that the Bluetooth is turned on and also you have turned on the scanning device. \n\n4. Go to the ShoWorks Vision Pro app and start using your scanner with Vision Pro app.\n\n\n\n")
                        .padding(.top,20).font(.system(size: 15))
                        .frame(width: 860)
                        .frame(alignment: .leading)
                }
                .frame(width: 960,height: 530)
           
            })
                        
        }
    }
}
