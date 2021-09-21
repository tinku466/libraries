//
//  ASCloudFilesPicker.swift
//  Cudo
//
//  Created by Ankit Saini on 05/03/21.
//

import Foundation
import UIKit
import MobileCoreServices

/// This modal is responsible to pick the media files from iCloud files app.
class ASCloudFilesPicker: NSObject, UIDocumentPickerDelegate {
    
    /// Shared Instance
    static let shared = ASCloudFilesPicker()
    
    /// When files are selected then this callback will be returned with selected values
    var onFileSelection: ((_ files: [ASMediaFile]) -> Void)?
    
    /// Name of the folder containing all files
    private let folderName = FOLDERS.icloud
    
    //MARK:- INIT
    
    /// Get the files from iCloud
    /// - Parameter type: [CFString] => supported file Extensions. default 'kUTTypePDF, kUTTypeImage'
    func pickICloudFile(with type: [CFString] = [kUTTypePDF, kUTTypeImage, kUTTypePresentation]) {
        
        let allExtensions = type.compactMap({String($0)})
        
        let documentPickerController = UIDocumentPickerViewController(documentTypes: allExtensions, in: .import)
        //String(kUTTypePDF), String(kUTTypeImage), String(kUTTypeMovie), String(kUTTypeVideo), String(kUTTypePlainText),
        
        documentPickerController.delegate = self
        guard let controller = UIApplication.topViewController() else {
            onFileSelection?([])
            return
        }
        controller.present(documentPickerController, animated: true, completion: nil)
    }
    
    /// ICloud document picker cancelled
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("Controller Cancelled")
        onFileSelection?([])
    }
    
    /// Document picked from iCLoud files
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        print("Document picked:", urls)
        
        var arrFiles: [ASMediaFile] = []
        
        kAppDelegate.showLoader()
        for item in urls {
            let lastPathComponent = item.lastPathComponent
            if lastPathComponent.lowercased().contains(".icloud") {
                // File is not on the device. Download from iCLoud
                // This code launch the download
                do {
                    try FileManager.default.startDownloadingUbiquitousItem(at: item)
                } catch let err {
                    print("iCloud Download error: \(err.localizedDescription).")
                }
                
            } else {
              // The file is on the device, use it normaly
                // This code launch the download
//                do {
//                    try FileManager.default.startDownloadingUbiquitousItem(at: item)
//                } catch let err {
//                    print("iCloud Download error: \(err.localizedDescription).")
//                }
            }
            
            //FileName in string
            //
            let arrNames = lastPathComponent.components(separatedBy: ".icloud")
            let fileName = arrNames.first ?? lastPathComponent
            
            //
            //File path where the file is stored on local directory
            //
            let manager = DefaultCenter.fileManager
            guard let documentDirectory = try? manager.url(for: .documentDirectory,
                                                           in: .userDomainMask,
                                                           appropriateFor: nil,
                                                           create: true) else {return}
            
            var outputURL = documentDirectory.appendingPathComponent(folderName)
            do {
                try manager.createDirectory(at: outputURL, withIntermediateDirectories: true, attributes: nil)
                outputURL = outputURL.appendingPathComponent(fileName)
                
                if manager.fileExists(atPath: outputURL.path) == true {
                    let date = Date().toString(format: .custom("yyyyMMddHHmmss_SSS"))
                    let fileNameNew = String(format: "%@_%@_%@", String.randomString(len: 5), date, fileName).cleanFileName()
                    outputURL.deleteLastPathComponent()
                    outputURL = outputURL.appendingPathComponent(fileNameNew)
                }
            } catch let error {
                print(error)
            }
            print(outputURL)
            do {
                try manager.moveItem(at: item, to: outputURL)
            } catch let err {
                print("Error in file moving: \(err.localizedDescription)")
            }
            
            ///
            /// Create Media File
            let name = outputURL.lastPathComponent
            var mediaFile = ASMediaFile.init(mediaType: .file, fileLocation: .local)
            mediaFile.url = outputURL
            mediaFile.title = name
            
            arrFiles.append(mediaFile)
        }
        kAppDelegate.hideLoader()
        
        onFileSelection?(arrFiles)
    }
}
