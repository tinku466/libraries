//
//  ASFileDir.swift
//  ABBC
//
//  Created by Mr. X on 08/05/21.
//

import Foundation
import UIKit

/// File Directory modal
struct ASFileDir {
    
    /// Save file in local directory
    /// - Parameter file: ASMediaFile
    /// - Returns: ASMediaFile?
    static func save(file: ASMediaFile) -> ASMediaFile? {
        var item = file
        if item.mediaType == .image, let image = item.image, let fileName = item.title { // Save Images
            let fileDoc = ASFileDir.createFileUrl(fileName: fileName)
            if fileDoc.isFileExist == false, let docURL = fileDoc.outputURL {
                let isSuccess = ASFileDir.uploadImageTo(url: docURL, image: image, compressionQuality: 0.6)
                if isSuccess {
                    item.url = docURL
                    return item
                }
            }
        }
        return nil
    }
    
    //MARK:- FILE UPLOADER IN LOCAL DIR.
    
    /// Create folder url to save files in local dir.
    /// - Parameters:
    ///   - fileName: String
    /// - Returns: isFileExist: Bool, outputURL: URL?
    static func createFileUrl(fileName: String) -> (isFileExist: Bool, outputURL: URL?) {
        //
        //File path where the file is stored on local directory
        //
        let manager = DefaultCenter.fileManager
        guard let documentDirectory = try? manager.url(for: .documentDirectory,
                                                       in: .userDomainMask,
                                                       appropriateFor: nil,
                                                       create: true) else {
            return (false, nil)
        }
        
        var outputURL = documentDirectory.appendingPathComponent(FOLDERS.savedFiles, isDirectory: true)
        do {
            try manager.createDirectory(at: outputURL, withIntermediateDirectories: true, attributes: nil)
            outputURL = outputURL.appendingPathComponent(fileName)
            
            if manager.fileExists(atPath: outputURL.path) == true {// File already exist
                print("File already exist")
                return(true, nil)
            }
        } catch let error {
            print(error)
            return (false, nil)
        }
        print(outputURL)
        return (false, outputURL)
    }
    
    /// Save Image to a local url
    /// - Parameters:
    ///   - url: URL
    ///   - image: UIImage
    ///   - compressionQuality: CGFloat = 1.0
    /// - Returns: Bool
    static func uploadImageTo(url: URL, image: UIImage, compressionQuality: CGFloat = 1.0) -> Bool {
        // get your UIImage jpeg data representation and check if the destination file url already exists
        guard let data = image.jpegData(compressionQuality: compressionQuality) else {
            print("Image data is nil")
            return false
        }
        if DefaultCenter.fileManager.fileExists(atPath: url.path) {
            print("File already exist")
            return false
        }
        
        do {
            try data.write(to: url)
            return true
        } catch {
            print("Error in image saving: ", error.localizedDescription)
            return false
        }
    }
    
    /// Copy one file to another
    /// - Parameters:
    ///   - sourceUrl: URL
    ///   - destinationUrl: URL
    /// - Returns: Bool
    static func copyFile(from sourceUrl: URL, to destinationUrl: URL) -> Bool {
        do {
            try DefaultCenter.fileManager.copyItem(at: sourceUrl, to: destinationUrl)
            return true
        } catch {
            print("Error in file copying: ", error.localizedDescription)
            return false
        }
    }
    
    //MARK:- DELETION
    
    /// Delete file from directory
    /// - Parameter fileUrl: URL
    static func delete(fileUrl: URL) {
        FileManager.removeItem(at: fileUrl)
    }
    
    
}
