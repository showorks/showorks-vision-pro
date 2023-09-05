//
//  KioskWelcomeView.swift
//  ShoWorks
//
//  Created by Lokesh on 15/08/23.
//

import SwiftUI
import Vision
import AVFoundation
import RealityKit
import UIKit

struct KioskWelcomeView: View {

    @EnvironmentObject var viewModel: KioskViewModel
    @Environment(\.presentationMode) var presentationMode
    @State var isPresented = false

    var body: some View {
        NavigationStack {
            ZStack {
                CustomBackground()
                    .edgesIgnoringSafeArea(.all)
                VStack{
                    HStack(){
                        Spacer()
                        
                        Button(action: {
                              
                            presentationMode.wrappedValue.dismiss()
                            
                           }, label: {
                               Image(systemName: "multiply.circle")
                                   .resizable(resizingMode: .stretch)
                                   .foregroundColor(.white)
                        })
                        .foregroundColor(Color.white)
                        .frame(width: 50.0, height: 50.0)
                        .padding(.trailing, 50)
                        .padding(.top, 30)
                        .buttonStyle(PlainButtonStyle())
                        
                    }
                    Text(SheetUtility.sharedInstance.getFairNameOfCurrentSheet(sheetDic: viewModel.selectedDictionary)).font(.heleveticNeueMedium(size: 50))
                        .foregroundColor(.white)
                        .padding(.leading,50)
                    Spacer().frame(height: 40)
                    Image("SplashLogo")
                        .resizable()
                        .frame(width: 150, height: 170, alignment: .center)
                    
                    Button(action: {
                          
                        print("Tap here to check-in")
                        isPresented = true
                       }, label: {
                           VStack{
                               Text("tap_here_to".localized())
                                   .font(.system(size: 36))
                                   .font(.heleveticNeueMedium(size: 36))
                                   .foregroundColor(Color.white)
                               Text("check_in_txt".localized())
                                   .font(.system(size: 55))
                                   .font(.heleveticNeueBold(size: 55))
                                   .foregroundColor(Color.white)
                           }
                           .padding(.trailing,250)
                           .padding(.leading,250)
                           .padding(.top,20)
                           .padding(.bottom,20)
                           .cornerRadius(5)
                    })
                    .sheet(isPresented: $isPresented) {
                                DocumentCameraViewControllerView()

                    }
                    .buttonStyle(PlainButtonStyle())
                    .cornerRadius(25)
                    .foregroundColor(Color.white)
                    .background(Color.aBlueBackgroundColor)
                    .padding(.init(top: 20, leading: 40, bottom: 20, trailing: 40))
                    .cornerRadius(25)
                    
                    
                    HStack{
                        Spacer()
                        VStack(){
                            Text("powered_by".localized()).font(.heleveticNeueMedium(size: 22))
                                .foregroundColor(.white)
                                .padding(.trailing,50)
                                .multilineTextAlignment(.center)
                            Image("showorksLogo")
                                .padding(.trailing,50)
                        }
                    }
                }
            }
        }.navigationBarHidden(true)
    }
    
    func checkIfCameraPermissionIsThere(){
        
    
//
//        let barcodeRequest = VNDetectBarcodesRequest(completionHandler: { request, error in
//
//            guard let results = request.results else { return }
//
//            // Loop through the found results
//            for result in results {
//                
//                // Cast the result to a barcode-observation
//                if let barcode = result as? VNBarcodeObservation {
//                    
//                    // Print barcode-values
//                    print("Symbology: \(barcode.symbology.rawValue)")
//                    
//                    if let desc = barcode.barcodeDescriptor as? CIQRCodeDescriptor {
//                        print("Error-Correction-Level: \(desc.errorCorrectionLevel)")
//                        print("Symbol-Version: \(desc.symbolVersion)")
//                    }
//                }
//            }
//        })
        
//        guard let image = myImage.cgImage else { return }
//        let handler = VNImageRequestHandler(cgImage: image, options: [:])
//
//        // Perform the barcode-request. This will call the completion-handler of the barcode-request.
//        guard let _ = try? handler.perform([barcodeRequest]) else {
//            return print("Could not perform barcode-request!")
//        }
    }
//    
//    public func getListOfCameras() -> [AVCaptureDevice] {
//        
//    #if os(iOS)
//        let session = AVCaptureDevice.DiscoverySession(
//            deviceTypes: [
//                .builtInWideAngleCamera,
//                .builtInTelephotoCamera
//            ],
//            mediaType: .video,
//            position: .unspecified)
//    #elseif os(macOS)
//        let videoDeviceDiscoverySession = AVCaptureDevice.DiscoverySession(
//            deviceTypes: [
//                .builtInWideAngleCamera
//            ],
//            mediaType: .video,
//            position: .unspecified)
//    #endif
//        
//        return session.devices
//    }
}

#Preview {
    KioskWelcomeView()
}
//
//struct JustPlaceBoxView: View {
//
//    var body: some View {
//        return JustPlaceBoxARViewContainer()
//            .edgesIgnoringSafeArea(.all)
//    }
//}
//
//struct JustPlaceBoxARViewContainer: UIViewRepresentable {
//        
//    func makeUIView(context: Context) -> ARView {
//        let arView = ARView(frame: .zero)
//        
//        let anchorEntity = AnchorEntity(plane: .horizontal)
//        let boxEntity = ModelEntity(mesh: .generateBox(size: [0.1,0.1,0.1],cornerRadius: 0.02))
//        let material = SimpleMaterial(color: .blue, isMetallic: true)
//        boxEntity.model?.materials = [material]
//        anchorEntity.addChild(boxEntity)
//        arView.scene.addAnchor(anchorEntity)
//        
//        return arView
//    }
//    
//    func updateUIView(_ uiView: ARView, context: Context) {
//    }
//}
//

struct DocumentCameraViewControllerView: UIViewControllerRepresentable {
    typealias UIViewControllerType = DocumentCameraViewController
    
    func makeUIViewController(context: Context) -> DocumentCameraViewController {
        // Return MyViewController instance
        return DocumentCameraViewController()
    }
    
    func updateUIViewController(_ uiViewController: DocumentCameraViewController, context: Context) {
        // Updates the state of the specified view controller with new information from SwiftUI.
    }
}
