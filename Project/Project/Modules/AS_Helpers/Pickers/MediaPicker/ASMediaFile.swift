//
//  ASMediaFile.swift
//  Cudo
//
//  Created by Ankit Saini on 05/03/21.
//

import Foundation
import UIKit
import Photos

/// Media type available
enum ASMediaType: String {
    case video
    case image
    case audio
    case file
    
    /// String representation of object
    var val: String {
        return self.rawValue
    }
    
}

/// This modal will represent the media files which needs to upload on server.
struct ASMediaFile {
    /// Location of the file
    enum FileLocationType {
        case iTunes
        case local
        case web
        case gallery
    }
    
    /// Location of the file
    var fileLocation: FileLocationType
    
    /// Title name of file
    var title: String?
    
    /// Timestamp for uniq identifier
    var timeStamp: String
    
    /// Media type of file
    var mediaType: ASMediaType
    
    /// Image
    var image: UIImage?
    
    /// Media url
    var url: URL?
    
    /// Media url from AWS
    var awsUrlStr: String?
    
    /// A representation of an image, video, or Live Photo in the Photos library.
    var asset: PHAsset?
    
    /// The abstract class used to model timed audiovisual media such as videos and sounds.
    var avAsset: AVAsset?
    
    /// Image frames of a video in case if media type is video
    var videoFrames: [UIImage] = []
    
    /// Initialize the media file modal
    /// - Parameters:
    ///   - mediaType: ASMediaType
    ///   - image: UIImage?
    ///   - url: URL?
    ///   - strUrl: String?
    init(mediaType: ASMediaType, image: UIImage? = nil, url: URL? = nil, fileLocation: FileLocationType) {
        self.mediaType = mediaType
        self.image = image
        self.url = url
        self.timeStamp = "\(Date().timeIntervalSince1970)"
        self.fileLocation = fileLocation
        self.title = "\(self.timeStamp).\(ASMediaFile.getExtension(mediaType: self.mediaType))"
        self.awsUrlStr = nil
    }
    
    /// Initialize with only media type
    init(mediaType: ASMediaType, fileLocation: FileLocationType) {
        self.mediaType = mediaType
        self.image = nil
        self.url = nil
        self.timeStamp = "\(Date().timeIntervalSince1970)"
        self.title = nil
        self.fileLocation = fileLocation
        self.title = "\(self.timeStamp).\(ASMediaFile.getExtension(mediaType: self.mediaType))"
        self.awsUrlStr = nil
    }
    
    /// Get media Extension
    /// - Parameter mediaType: ASMediaType
    /// - Returns: String
    static func getExtension(mediaType: ASMediaType) -> String {
        switch mediaType {
        case .image:
            return MediaExtension.jpg.name
        case .file:
            return MediaExtension.pdf.name
        case .audio:
            return MediaExtension.mp3.name
        case .video:
            return MediaExtension.mp4.name
        }
    }
}
