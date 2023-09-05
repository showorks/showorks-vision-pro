//
//  DocumentCameraViewController.swift
//  ShoWorks
//
//  Created by Lokesh on 05/09/23.
//

import Foundation
import VisionKit

class DocumentCameraViewController: UIViewController, VNDocumentCameraViewControllerDelegate {
    var documentCamera: VNDocumentCameraViewController?

    //...
    
    override func viewDidLoad() {
        showDocumentScanner()
    }

    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
      documentCamera?.dismiss(animated: true, completion: nil)
    }
      
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
      print("Document Scanner did fail with Error")
    }
      
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
      print("Did Finish With Scan.")
        documentCamera?.dismiss(animated: true, completion: nil)
        documentCamera = nil
        print("Finished scanning document \"\(String(describing: title))\"")
        print("Found \(scan.pageCount)")
        let firstImage = scan.imageOfPage(at: 0)
    }

    func showDocumentScanner() {
      guard VNDocumentCameraViewController.isSupported else { print("Document scanning not supported"); return }
      documentCamera = VNDocumentCameraViewController()
      documentCamera?.delegate = self
      present(documentCamera!, animated: true, completion: nil)
    }
    
}
