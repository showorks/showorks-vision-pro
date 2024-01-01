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
    var descriptionInfo: String
    var validationNumber: String
    var entryValidationDate: String
    var stateFair: String
    var salePrice: String
    var isAllowedForSale: Bool
    
    init(exhibitor: String, department: String, club: String, entryNumber: String, wen: String, division: String, Class: String, description: String, validationNumber: String, entryValidationDate: String, stateFair: String, salePrice: String,isAllowedForSale: Bool) {
        self.id = UUID()
        self.exhibitor = exhibitor
        self.department = department
        self.club = club
        self.entryNumber = entryNumber
        self.wen = wen
        self.division = division
        self.Class = Class
        self.descriptionInfo = description
        self.validationNumber = validationNumber
        self.entryValidationDate = entryValidationDate
        self.stateFair = stateFair
        self.salePrice = salePrice
        self.isAllowedForSale = isAllowedForSale
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
    @State var isCheckIn: Bool = true
    @State var kioskViewModel = KioskViewModel()
    @ObservedObject var homeViewModel = HomeViewModel()
    @EnvironmentObject var viewModel: ShoWorksAuthenticationModel
    @State var mScreenState: AppConstant.AppStartupStatus?
    @State var currentSearchCount = 0
    @State private var alertItem: AlertItem?
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
                                
                                HomeListView(isCheckIn: isCheckIn, currentSearchCount: currentSearchCount, kioskViewModel: kioskViewModel)

                            }else{
                                SearchBarCapsule(kioskViewModel: $kioskViewModel, currentSearchCount: $currentSearchCount)
                                
                                if DataCenter.sharedInstance.isDeviceConnected {
                                    QRScanTabView().frame(width: 1160, height: 540)
                                        .glassBackgroundEffect()
                                        .padding(.bottom, 40)
                                }else{

                                    ConnectSearchView()
                                        .frame(width: 1160, height: 540)
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
//                        Color.white.opacity(0.3)
                            
                        VStack{
                            Spacer().frame(maxHeight: 35)
                                QRScanDisconnectedTabView()
                                .frame(width: 1160, height: 540)
                                .glassBackgroundEffect()
                        }
                        
                    }
                }else{
                    ZStack{
//                        Color.white.opacity(0.3)
//                            .frame(width: 1160, height: 540)
//                            .glassBackgroundEffect()
                        VStack{
                            Spacer().frame(maxHeight: 35)
                            SettingsLayout()
                                .frame(width: 1160, height: 540)
                                .glassBackgroundEffect()
                        }
                        
                    }
                }
                
                
            }
        }
        .onAppear {
            decideAndLoadDataOnScreenAccordingly()
        }
        .onReceive(.searchRecordChangesNotification) { info in

                        let searchRecordHasData = (info.object as? Bool) ?? false

                        self.searchRecordContainsData = searchRecordHasData
            
                        if searchRecordHasData == false {
                            
                            showNoEntriesFoundAlert()
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: AppConstant.NotificationWhenItIsNeededToFlushSearchBar), object: nil)
                        }

        }
        .onReceive(.refereshChangesNotification) { info in
        
                    let searchRecordHasData = (info.object as? Bool) ?? false

                    self.searchRecordContainsData = searchRecordHasData

                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: AppConstant.NotificationWhenItIsNeededToFlushSearchBar), object: nil)

        }
        .alert(item: self.$alertItem, content: { a in
            a.asAlert()
        })
        .navigationBarHidden(true)
        
    }
    
    
    func showNoEntriesFoundAlert(){
        self.alertItem = AlertItem(type: .dismiss(title: "showorks".localized(), message: "No records found", dismissText: "ok".localized(), dismissAction: {
            // Do something here
        }))
    }
    
    func decideAndLoadDataOnScreenAccordingly(){
        
         if mScreenState == .demoMode {
             loadPlistData()
         }else if mScreenState == .fetchSheetFromServer {
             loadDataOnScreenFromServer()
         }else if mScreenState == .fetchSheetFromLocal {
             loadPlistData()
         }
         

    }
    
    func loadDataOnScreenFromServer(){
        Task {
            DataCenter.sharedInstance.setupWithAccessKey(_accessKey: UserSettings.shared.accessKey, andSecretKey: UserSettings.shared.secretKey) { downloadCompleted in
                if downloadCompleted {
                    loadPlistData()
                }
            }
        }
    }
    
    func loadPlistData(){
        Task {
            await homeViewModel.loadPlistArrayWithSheetsDetailData(screenType: mScreenState ?? .demoMode)
            loadKioskModeSheet()
        }
    }
    
    func loadKioskModeSheet(){
        let plistSheetDetailArray:NSMutableArray! = SharedDelegate.sharedInstance.plistSheetDetailArray
      
        guard let plistArray = plistSheetDetailArray else {
            return
        }
        
        for sheetDic in plistArray {
           
            let sheetObj = sheetDic as! NSDictionary

            if SheetUtility.sharedInstance.isKioskModeEnabledInSheet(sheetDic: sheetObj){
                kioskViewModel = KioskViewModel(selectedDictionary: sheetObj)
                print("Found kiosk")
            }else{
                print("Other sheet")
            }
            
            // intentionally pulling first sheet in case of home and hobby..
//            kioskViewModel = KioskViewModel(selectedDictionary: sheetObj)
            
         }
        
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
                        .frame(width: 1160)
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
                .frame(width: 1160,height: 530)
           
            })
                        
        }
    }
}

struct HomeListView : View {
    @State var isCheckIn: Bool = true
    @State var currentSearchCount = 0
    @State var kioskViewModel:KioskViewModel
    @State var isListRequired = true
    var body: some View{
        ZStack{
            VStack(spacing: 20){
                
                if isListRequired {
                    
                    SearchBarCapsule(isSearchedListOption: true, kioskViewModel: $kioskViewModel, currentSearchCount: $currentSearchCount)
//                            .padding(.top, 100)
                    
                    VStack{
                        
                        Text("Searched Results for \(DataCenter.sharedInstance.searchedRecords[0].exhibitor)...")
                            .padding(.top,50).font(.sfProRegular(size: 32))
                            .padding(.bottom,30)
                        
                        List(DataCenter.sharedInstance.searchedRecords) { record in
                            HStack(alignment: .center) {
                                Text("\(record.entryNumber)")
                                .font(.sfProRegular(size: 18))
                                .frame(maxWidth: 70, alignment: .leading)
                                .hoverEffect(.lift)
                                
                                Spacer().frame(maxWidth: 30)
                                Divider().frame(width: 2).background(Color.white)
                                Spacer().frame(maxWidth: 30)
                                
                                Text("\(record.department)")
                                    .multilineTextAlignment(.leading)
                                    .font(.sfProRegular(size: 18))
                                    .frame(maxWidth: 150, alignment: .leading).hoverEffect(.lift)
                                
                                Spacer().frame(maxWidth: 30)
                                Divider().frame(width: 2).background(Color.white)
                                Spacer().frame(maxWidth: 30)
                                
                                Text("\(record.division)")
                                    .multilineTextAlignment(.leading)
                                    .font(.sfProRegular(size: 18))
                                    .frame(maxWidth: 250, alignment: .leading).hoverEffect(.lift)
                                
                                Spacer().frame(maxWidth: 30)
                                Divider().frame(width: 2).background(Color.white)
                                Spacer().frame(maxWidth: 30)
                                
                                Text("\(record.Class)")
                                    .multilineTextAlignment(.leading)
                                    .font(.sfProRegular(size: 18))
                                    .frame(maxWidth: 350, alignment: .leading).hoverEffect(.lift)
                            }.hoverEffect(.lift)
                            .onTapGesture {

                                var actualIndex = 0
                                
                                for recordObj in DataCenter.sharedInstance.searchedRecords {
                                    if recordObj.entryNumber == record.entryNumber{
                                        break
                                    }
                                    actualIndex += 1
                                }
                                
                                DataCenter.sharedInstance.searchedSelectedIndex = actualIndex
                                self.isListRequired = false
                            }
                            
                        }
                    }
                    .frame(width: 1160, height: 540)
                        .glassBackgroundEffect()
                        .padding(.bottom, 40)
                    
                }else{
                    SearchBarCapsule(kioskViewModel: $kioskViewModel, currentSearchCount: $currentSearchCount)
                        .padding(.top, 100)
                    
                    HomeTabLayout(isCheckIn: $isCheckIn, currentSearchCount: $currentSearchCount)
                        .frame(width: 1160, height: 540)
                        .glassBackgroundEffect()
                        .padding(.bottom, 40)
                    
                    HomeBottomCapsule(isCheckIn: $isCheckIn)
                        .offset(y:-88)
                }
                
                
            }
        }
        .onAppear {
            isListRequired = UserSettings.shared.showListAfterSearch ?? true
        }
    }
}
