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
    case home, instructions, settings
}


//1024
struct HomeContentView: View {
    
    @State var selectedTab: Tabs = .home
    @State private var offsetY: CGFloat = 0
    @State private var isDragging = false
    @State var isDeviceConnected = true
    @State var searchRecordContainsData = false
    @State var isCheckIn: Bool = true
    @State var sheetsViewModel = SheetsViewModel()
    @ObservedObject var homeViewModel = HomeViewModel()
    @EnvironmentObject var viewModel: ShoWorksAuthenticationModel
    @State var mScreenState: AppConstant.AppStartupStatus?
    @State var currentSearchCount = 0
    @State private var alertItem: AlertItem?
    var ribbonArray: [String] = ["Blue Ribbon", "Red Ribbon", "Yellow Ribbon", "White Ribbon", "Pink Ribbon","Green Ribbon","Purple Ribbon","Brown Ribbon","Gray Ribbon","Aqua Ribbon","Black Ribbon"]
    @State var selectedRibbon: String = "Gray Ribbon"

    var body: some View {
        
        ZStack{
            ShoWorksBackground()
//                .resizable()
//                .frame(width: 1366, height: 824)
            
            
            HStack{
                
                customTab
                    .padding(.trailing,20)
                
                if selectedTab == .home{
                    ZStack{
                        VStack(spacing: 20){
                           
                            if searchRecordContainsData {
                                
                                HomeListView(isCheckIn: isCheckIn, currentSearchCount: currentSearchCount, sheetsViewModel: sheetsViewModel)
                                 
                            }else{
                                HStack(spacing: 20) {

                                    SelectedSheetCapsule(sheetViewModel: $sheetsViewModel,mSelectedSheet: sheetsViewModel.mSelectedSheetName)
                                    
                                    SearchBarCapsule(sheetsViewModel: $sheetsViewModel, currentSearchCount: $currentSearchCount)
                                }
                                
                                if DataCenter.sharedInstance.isDeviceConnected {
                                    QRScanTabView().frame(width: 1060, height: 570)
                                        .glassBackgroundEffect()
                                        .padding(.bottom, 40)
                                }else{

                                    ConnectSearchView()
                                        .frame(width: 1060, height: 540)
                                        .glassBackgroundEffect()
                                        .padding(.bottom, 10)
                                    
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
                    
                    if !isCheckIn {
                        
                        ZStack{
                            Capsule()
                                .fill(.white.opacity(0.3))
                                .frame(width: 65, height: 580)
                                .glassBackgroundEffect()
                                .padding(.top,20)
                                .padding(.leading, 10)
                            
                            ScrollView(.vertical) {
                                LazyVStack(spacing: 10) {
                                    ForEach(ribbonArray, id: \.self){imageName in
                                        Image(imageName)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 25)
                                    }
                                }
                            }.frame(width: 65, height: 640)
                                .padding(.top,105)
                                .scrollIndicators(.never)
                                .padding(.leading, 10)
                        }
                    }
                    
                }else if selectedTab == .instructions{
                    ZStack{
//                        Color.white.opacity(0.3)
                            
                        VStack{
                            Spacer().frame(maxHeight: 35)
                                QRScanDisconnectedTabView()
                                .frame(width: 1060, height: 670)
                                .glassBackgroundEffect()
                        }
                        
                    }
                }else{
                    ZStack{
//                        Color.white.opacity(0.3)
//                            .frame(width: 1060, height: 540)
//                            .glassBackgroundEffect()
                        VStack{
                            Spacer().frame(maxHeight: 35)
                            SettingsLayout()
                                .frame(width: 1060, height: 670)
                                .glassBackgroundEffect()
                        }
                        
                    }
                }
                
                
            }.offset(x:-40)
        }
        .onAppear {
            decideAndLoadDataOnScreenAccordingly()
        }
        .onReceive(.checkInJudgeModeNotification) { info in

            self.isCheckIn = UserSettings.shared.selectedMode!

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
            loadAllSheetsDefaultToKiosk()
        }
    }
    
    func loadAllSheetsDefaultToKiosk(){
        let plistSheetDetailArray:NSMutableArray! = SharedDelegate.sharedInstance.plistSheetDetailArray
      
        guard let plistArray = plistSheetDetailArray else {
            return
        }
        
        sheetsViewModel = SheetsViewModel(arrayOfSheets: plistArray)
//
//        for sheetDic in plistArray {
//           
//            let sheetObj = sheetDic as! NSDictionary
//
//            if SheetUtility.sharedInstance.isKioskModeEnabledInSheet(sheetDic: sheetObj){
//                print("Found kiosk")
//            }else{
//                print("Other sheet")
//            }
            
//            // default first sheet selected
//
//            sheetsViewModel = SheetsViewModel(selectedDictionary: sheetObj,arrayOfSheets: plistArray)
//            
//            break
//            
//         }
        
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
                        .frame(width: 1060)
                        .padding(.top,20)
                   
                    Text("How to connect your scanner device via Bluetooth ?")
                        .padding(.top,20).font(.system(size: 20))
                        .fontWeight(.bold)
                        .frame(alignment: .leading)
                    
                    Text("1. Go to the Bluetooth Connection Instruction Manual. \n\n2. Press scanner's button to power on the scanner. \n\n3. Bluetooth HID mode is usually set by default on new devices. ShoWorks uses the newer BLE mode for more efficient and reliable data communications and you must charge your device to this mode by scanning the code below or found in your instruction manual. \n\n4. Make sure the device is configured to use Bluetooth mode instead of USB.\n\n5. For ShoWorks Vision Pro app, Make sure BLE Mode = (AT+MODE = 3) is active on the scanner.") //Please scan the following barcode to allow the device to work with Bluetooth mode.
                        .padding(.top,20).font(.system(size: 15))
                        .frame(width: 860)
                        .frame(alignment: .leading)
                    
//                    Image("netum_bluetooth")
//                        .padding(.top,20)
//                    Text("\n\n5. BLE Mode Serial Port Profile- For iOS Devices By scanning below barcode scanner will enter BLE Mode for ShoWorks Vision Pro app.")
//                        .padding(.top,20).font(.system(size: 15))
//                        .frame(width: 860)
//                        .frame(alignment: .leading)
//                    
//                    Image("netum_scan")
                    
                    Text("\n\n6. Once the barcode has been scanned with the Bluetooth scanner, it will automatically connect with the ShoWorks Vision app each time you start the app, however this initial setup requires that you force close (\"kill\") the app after the configuration has been made for the first time. There is a small dot appearing below the ShoWorks Vision Pro app screen, you can tap on it force close the app. \n\n7. If the Bluetooth scanner has been successfully paired with the Vision Pro prior and is active, a beep sound and brief visual message will occur when the ShoWorks Vision Pro App is launched, indicating that the two devices are now properly communicating. \n\nTROUBLESHOOTING: If the two devices do not seem to be communicating, try the following: \n\n - Force close the ShoWorks Vision Pro App and relaunch (See Vision OS documentation on how to force close apps). \n - Perform a hard reset on the Bluetooth scanner. The barcode below will hard reset your scanner. Once a hard reset has been made, you must again scan the two other barcodes with the scanner to \"Work with Bluetooth\" and \"BLE Mode\" (AT+MODE=3). After this has been done, you must force close the ShoWorks Vision Pro App and relaunch.")
                        .font(.system(size: 15))
                        .frame(width: 860)
                        .frame(alignment: .leading)
                        .padding(.leading,12)
                    
                    HStack{
                        Text("\n\n\nOnce the device is connected, you should see a connected status with a ") + Text(Image("green_dot")) + Text(" green dot in front of home tab.")
                    }
                    .fontWeight(.bold)
                    .padding(.top,20).font(.system(size: 18))
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
                .frame(width: 1060,height: 530)
           
            })
                        
        }
    }
}

struct HomeListView : View {
    @State var isCheckIn: Bool = true
    @State var currentSearchCount = 0
    @State var sheetsViewModel:SheetsViewModel
    @State var isListRequired = true

    var body: some View{
        ZStack{
            VStack(spacing: 20){
                
                if isListRequired {
                    
                    HStack(spacing: 20) {

                        SelectedSheetCapsule(sheetViewModel: $sheetsViewModel,mSelectedSheet: sheetsViewModel.mSelectedSheetName)
                        
                        SearchBarCapsule(isSearchedListOption: true, sheetsViewModel: $sheetsViewModel, currentSearchCount: $currentSearchCount)
                    }
                    
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
                            
                        }.padding(.bottom,40)
                    }
                    .frame(width: 1060, height: 540)
                        .glassBackgroundEffect()
                        .padding(.bottom, 40)                       
                    
                }else{
                    
                    HStack(spacing: 20) {
                        
                        SelectedSheetCapsule(sheetViewModel: $sheetsViewModel,mSelectedSheet: sheetsViewModel.mSelectedSheetName)
                        
                        SearchBarCapsule(sheetsViewModel: $sheetsViewModel, currentSearchCount: $currentSearchCount)
                    }
                    
                    HomeTabLayout(isCheckIn: $isCheckIn, currentSearchCount: $currentSearchCount)
                        .frame(width: 1060, height: 540)
                        .glassBackgroundEffect()
                        .padding(.bottom, 40)
                    
                    HomeBottomCapsule(isCheckIn: $isCheckIn)
                        .offset(y:-88)
                    
                    if !isCheckIn {
                        ZStack{
                            Capsule()
                                .fill(.white.opacity(0.3))
                                .frame(width: 770, height: 55)
                                .glassBackgroundEffect()
                            
                                ScrollView(.horizontal) {
                                    LazyHStack(spacing: 5) {
                                        ForEach(1...9, id: \.self) { index in
                                            Text(String(index))
                                                .font(.system(size: 12))
                                                .frame(width: 25, height: 25, alignment: .center)
                                                .padding()
                                                .overlay(
                                                    Circle()
                                                    .stroke(Color.white, lineWidth: 2)
                                                    .padding(10)
                                                )
                                                
                                        }
                                        Text(String("10-99"))
                                            .font(.system(size: 10))
                                            .frame(width: 45, height: 25, alignment: .center)
                                            .padding()
                                            .overlay(
                                                Circle()
                                                .stroke(Color.white, lineWidth: 2)
                                                .padding(10)
                                            )
                                    }
                                    .padding(.leading,20)
                                }.frame(width: 720, height: 55)
                            .scrollIndicators(.never)

                        }
                        .offset(y:-68)
                    }
                }
                
                
            }.padding(.top,!isListRequired ? 100 : 0)
        }
        .onAppear {
            isListRequired = UserSettings.shared.showListAfterSearch ?? true
        }
    }
}



struct SelectedSheetCapsule: View {
    

    @Binding var sheetViewModel: SheetsViewModel
    @State var mSelectedSheet: String?

    var body: some View {
        ZStack{
            
            Capsule()
            .fill(.white.opacity(0.1))
            .frame(width: 250, height: 55)
            .glassBackgroundEffect()
            
            
                
                if sheetViewModel.mSheetNamesArray.count > 0 {
                    
                     Menu{
                         
                         ForEach(0...sheetViewModel.mSheetNamesArray.count-1, id: \.self) { index in
                             if let sheetName = sheetViewModel.mSheetNamesArray[index] as? String{
                                 Button {
                                     sheetViewModel.mSelectedSheetName = sheetName
                                     sheetViewModel.currentSelectedIndex = index
                                     sheetViewModel.updateCurrentSheetDetails()
                                     DataCenter.sharedInstance.refreshViewWithEmptyLayout()
                                     mSelectedSheet = sheetName                                    
                                 } label: {
                                     Text(sheetName).font(.system(size: 18))
                                 }
                                 
                             }
                         } .frame(width: 235)
                        
                     } label: {
                         HStack(spacing: 6){
                             Text(mSelectedSheet ?? "").font(.sfProRegular(size: 14))
                             Image(systemName: "chevron.down")
                                 .font(.system(size: 12))
                         }.frame(width: 235)
                    }
                      .menuStyle(.borderlessButton)
                     .frame(width: 240)
//                }
               
            }
            
        }
         .onReceive(.refreshNameSelectionOfSheetNotification) { info in

             let selectedSheetName = (info.object as? String) ?? ""
             self.mSelectedSheet = selectedSheetName


         }
        .frame(width: 250)

        
    }
}



struct ShoWorksSideBarLayout < T: View >: View {
    
    var extendedView: () -> T
    var isNumber: Bool
    @State var showCapsuleElements: Bool = false
    @State var capsuleWidth: CGFloat = 110
    
    @State var maxCapsuleWidth: CGFloat = 1355 * 0.56
    
    init( isNumberStack: Bool , @ViewBuilder extendedView: @escaping () -> T){
        self.extendedView = extendedView
        isNumber = isNumberStack
    }
    
    var body: some View {
        ZStack{
            
            HStack{
                Capsule().fill(.white.opacity(0.92))
                    .frame(width: capsuleWidth, height: 70)
                Spacer()
            }
            
                
            
            if showCapsuleElements{
                HStack{
                    ScrollView(.horizontal, showsIndicators: false){
                        
//                        hstack below are the items when extended.
                        extendedView()
                        
                        
                        
                    }
                    .frame(width: capsuleWidth - 50)
                    
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18))
                        .foregroundColor(.black)
                        .padding(.horizontal, 10)
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.5)){
                                capsuleWidth = 110
                            }

                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
                                showCapsuleElements = false
                            }
                        }
                }
            }else{
//                collapsed stack
                HStack{
//                    collapsedView()
                    if isNumber{
                        ZStack{
                            Circle().stroke(.black, lineWidth: 3).frame(width: 50)

                            Text("9")
                                .font(.system(size: 19))
                        }
                        
                    }else{
                        ZStack{
                            Circle().fill(.white).frame(width: 50)

                            Image(systemName: "bolt.heart.fill")
                                .font(.system(size: 19))
                        }
                    }
//                    UIDevice.current.userInterfaceIdiom == .
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 16))
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    
                }
                .padding(.leading)
                .onTapGesture {
                    if !showCapsuleElements{
                        withAnimation(.easeInOut(duration: 0.5)){
                            capsuleWidth = maxCapsuleWidth
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
                            showCapsuleElements = true
                        }
                    }
                }
                
            }
            
            
        }
        .frame(width: maxCapsuleWidth)
    }
}
