//
//  ASMediaPicker.swift
//  Cudo
//
//  Created by Ankit Saini on 05/03/21.
//

import Foundation
import UIKit
import BSImagePicker
import Photos
import AVKit

/// Media picker modal
struct ASMediaPicker {
    /// Download phasset request modal
    private struct DownloadAssets {
        /// Asset
        var asset: PHAsset
        
        /// Unique equest id received when requesting for download
        var imageResourceId: PHImageRequestID
        
        /// Downloaded video asset
        var avAsset: AVAsset?
        
        /// Downloaded image from the phasset
        var assetImage: UIImage?
    }
    
    /// Object for NSObject
    static let objSelf = NSObject()
    
    /// Selected asset to download
    private static var arrSelectedAssets: [DownloadAssets] = []
    
    //MARK:- SHOW PICKER OPTIONS
    
    /// Show Media picker to show action sheet
    /// - Parameters:
    ///   - selection: Set the maximum number of images to select
    ///   - completion: files: [ASMediaFile]
    static func showPicker(selection: Int = 10, supportedMediaTypes: Set<Settings.Fetch.Assets.MediaTypes> = [.image], completion: @escaping(_ files: [ASMediaFile]) -> Void) {
        
        ASMediaPicker.objSelf.openActionSheet(title: nil, message: L10n.selectSource.string, with: [L10n.photoLibrary.string, L10n.camera.string]) { (ind) in//L10n.loadFromFiles.string
            
            kMainQueue.async {
                guard let index = ind else {
                    print("Index is nil")
                    completion([])
                    return
                }
                if index == 0 {/// Gallery
                    ASMediaPicker.pickMediaFile(selection: selection, supportedMediaTypes: supportedMediaTypes) { (files) in
                        completion(files)
                    }
                    return
                    
                } else if index == 1 {/// Camera
                    guard let controller = UIApplication.topViewController() else {
                        completion([])
                        return
                    }
                    CameraImage.shared.captureImage(from: controller, captureOptions: [.camera], allowEditting: false, fileTypes: [.image]) { (img, _) in
                        
                        let file = ASMediaFile.init(mediaType: .image, image: img?.fixedOrientation(), url: nil, fileLocation: .gallery)
                        
                        completion([file])
                        return
                    }
                } else if index == 2 {/// Files-iCloud
                    ASCloudFilesPicker.shared.pickICloudFile()
                    ASCloudFilesPicker.shared.onFileSelection = {(_ files: [ASMediaFile]) in
                        completion(files)
                        ASCloudFilesPicker.shared.onFileSelection = nil
                        return
                    }
                }
            }
        }
    }
    
    //MARK:- PICKER
    
    /// Pick media files from gallery
    /// - Parameters:
    ///   - selection: Set the maximum number of images to select
    ///   - supportedMediaTypes: [.image, .video]
    ///   - completion: files: [ASMediaFile]
    static func pickMediaFile(selection: Int = 10, supportedMediaTypes: Set<Settings.Fetch.Assets.MediaTypes> = [.image, .video], completion: @escaping(_ files: [ASMediaFile]) -> Void) {
        if kAppDelegate.checkInternet() == false {
            return
        }
        ASMediaPicker.arrSelectedAssets.removeAll()
        
        let vc = ImagePickerController()
        vc.settings.selection.max = selection  //Set the maximum number of images to select
        vc.settings.theme.selectionStyle = .numbered
        vc.settings.fetch.assets.supportedMediaTypes = supportedMediaTypes
        vc.settings.theme.albumTitleAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15),
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]
        ///
        /// Cell Size
        ///
        vc.settings.list.cellsPerRow = {(verticalSize: UIUserInterfaceSizeClass, horizontalSize: UIUserInterfaceSizeClass) -> Int in
            switch (verticalSize, horizontalSize) {
            case (.compact, .regular): // iPhone5-6 portrait
                return 4
            case (.compact, .compact): // iPhone5-6 landscape
                return 4
            case (.regular, .regular): // iPad portrait/landscape
                return 4
            default:
                return 4
            }
        }
        
        /// Album settings to categories files
        ///
        let options = vc.settings.fetch.album.options
        vc.settings.fetch.album.fetchResults = [
            PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: options),
            PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumBursts, options: options),
            PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumVideos, options: options),
            PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumFavorites, options: options),
            PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: options)
        ]
        
        vc.navigationBar.tintColor = .black
        guard let topController = UIApplication.topViewController() else { return }
        topController.presentImagePicker(vc, animated: true, select: { (asset) in
            // User selected an asset. Do something with it. Perhaps begin processing/upload?
            var modal = DownloadAssets.init(asset: asset, imageResourceId: .zero, avAsset: nil, assetImage: nil)
            
            if asset.mediaType == .video {
                let imageId = ASMediaPicker.downloadVideoFromCloud(asset: asset)
                modal.imageResourceId = imageId
            } else {
                let imageId = ASMediaPicker.downloadImageFromCloud(asset: asset)
                modal.imageResourceId = imageId
            }
            
            ASMediaPicker.arrSelectedAssets.append(modal)
            
        }, deselect: { (asset) in
            // User deselected an asset. Cancel whatever you did when asset was selected.
            print("deselected: \(asset.localIdentifier)")
            
            if let index = ASMediaPicker.arrSelectedAssets.firstIndex(where: {asset.localIdentifier == $0.asset.localIdentifier}) {
                if ASMediaPicker.arrSelectedAssets.count > index {
                    let resource = ASMediaPicker.arrSelectedAssets[index]
                    
                    ASMediaPicker.arrSelectedAssets.remove(at: index)
                    
                    ASMediaPicker.cancelDownloading(requestId: resource.imageResourceId)
                }
            }
            
        }, cancel: { (_) in
            // User canceled selection.
        }, finish: { (assets) in
            // User finished with these assets
            print("Finish-1")
            kMainQueue.async {
                kAppDelegate.showProgressLoader(progress: 0.4, status: "Loading from iCloud")
                BackgroundQueue.mediaDownloadQueue.async {
                    ASMediaPicker.finishPickingMedia(from: assets) { (images) in
                        kMainQueue.async {
                            kAppDelegate.hideLoader()
                            completion(images)
                        }
                        return
                    }
                }
            }
            
        }, completion: nil)
    }
    
    //MARK:- iCloud Download
    
    /// Download image from iCloud
    /// - Parameter asset: PHAsset
    /// - Returns: PHImageRequestID
    private static func downloadImageFromCloud(asset: PHAsset) -> PHImageRequestID {
        
        let manager = PHImageManager.default()
        let requestOptions = PHImageRequestOptions()
        requestOptions.resizeMode = .exact
        requestOptions.deliveryMode = .highQualityFormat
        requestOptions.isNetworkAccessAllowed = true
//        requestOptions.isSynchronous = true
        requestOptions.progressHandler = { (progress, error, _, _) in
            if let err = error {
                print("Error: ", err.localizedDescription)
            }
            if progress == 1.0 {
                print("Progress done")
                kMainQueue.async {
                    kAppDelegate.hideLoader()
                }

            } else {
                kMainQueue.async {
                    kAppDelegate.showProgressLoader(progress: Float(progress), status: "Downloading from iCloud")
                }
            }
        }

        // Request the maximum size. If you only need a smaller size make sure to request that instead.
        let imageId = manager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: PHImageContentMode.default, options: requestOptions) { (image, _) in
            // Do something with image
            kMainQueue.async {
                kAppDelegate.hideLoader()
                if let img = image?.fixedOrientation() {
                    if let index = ASMediaPicker.arrSelectedAssets.firstIndex(where: {asset.localIdentifier == $0.asset.localIdentifier}) {
                        if ASMediaPicker.arrSelectedAssets.count > index {
                            ASMediaPicker.arrSelectedAssets[index].assetImage = img
                        }
                    }
                }
            }
        }
        return imageId
    }
    
    /// Download Video from iCloud
    /// - Parameter asset: PHAsset
    /// - Returns: PHImageRequestID
    private static func downloadVideoFromCloud(asset: PHAsset, deliveryMode: PHVideoRequestOptionsDeliveryMode = .mediumQualityFormat) -> PHImageRequestID {
        
        let manager = PHImageManager.default()
        
        let requestOptions = PHVideoRequestOptions()
        requestOptions.deliveryMode = deliveryMode
//        requestOptions.version = .current
        requestOptions.isNetworkAccessAllowed = true
        
        requestOptions.progressHandler = { (progress, error, _, _) in
            if let err = error {
                print("Error video: ", err.localizedDescription)
            }
            if progress == 1.0 {
                print("Progress done")
                kMainQueue.async {
                    kAppDelegate.hideLoader()
                }

            } else {
                kMainQueue.async {
                    kAppDelegate.showProgressLoader(progress: Float(progress), status: "Downloading from iCloud")
                }
            }
        }

        // Request Video
        let imageId = manager.requestAVAsset(forVideo: asset, options: requestOptions) { (avAsset, _, _) in
            // Do somethign with Data
            kMainQueue.async {
                kAppDelegate.hideLoader()
                if avAsset?.tracks(withMediaType: .video).first == nil {
                    print("Video not available in the asset")
                    let imgID = ASMediaPicker.downloadVideoFromCloud(asset: asset, deliveryMode: .highQualityFormat)
                    print("imgID", imgID)
                    return
                }
                
                if let index = ASMediaPicker.arrSelectedAssets.firstIndex(where: {asset.localIdentifier == $0.asset.localIdentifier}) {
                    if ASMediaPicker.arrSelectedAssets.count > index {
                        ASMediaPicker.arrSelectedAssets[index].avAsset = avAsset
                    }
                }
            }
        }
        print("imageId", imageId)
        return imageId
    }
    
    /// Cancel Downloading
    /// - Parameter requestId: PHImageRequestID
    static func cancelDownloading(requestId: PHImageRequestID) {
        let manager = PHImageManager.default()
        manager.cancelImageRequest(requestId)
        kMainQueue.async {
            kAppDelegate.hideLoader()
        }
    }
    
    //MARK:- Fetch
    /// Convert the image from PHAsset
    /// - Parameter assets: [PHAsset]
    private static func finishPickingMedia(from assets: [PHAsset], completion: @escaping(_ images: [ASMediaFile]) -> Void) {
        var arrFiles: [ASMediaFile] = []
        
        let totalAssets: Int = assets.count
        var convertedAssets: Int = 0
        
        // User finished with these assets
        let requestImageOption = PHImageRequestOptions()
        requestImageOption.deliveryMode = .highQualityFormat
        requestImageOption.isNetworkAccessAllowed = true
        //        requestImageOption.isSynchronous = true
        
        let requestVideoOption = PHVideoRequestOptions()
        requestVideoOption.deliveryMode = .mediumQualityFormat
        requestVideoOption.isNetworkAccessAllowed = true
        
        for asset in assets {
            
            var downloadedImage = false
            if let resource = ASMediaPicker.arrSelectedAssets.filter({asset.localIdentifier == $0.asset.localIdentifier}).first {
                
                if asset.mediaType == .video, let avAsset = resource.avAsset {// Media type is VIDEO
                    downloadedImage = true
                    ASMediaPicker.getFirstFrames(avAsset: avAsset) { (img) in
                        var file = ASMediaFile.init(mediaType: .video, fileLocation: .gallery)
                        file.asset = asset
                        file.avAsset = avAsset
                        if let image = img {
                            file.videoFrames = [image]
                        }
                        if let urlAsset = avAsset as? AVURLAsset {
                            file.url = urlAsset.url
                            arrFiles.append(file)
                            
                            convertedAssets = convertedAssets + 1
                            if convertedAssets == totalAssets {
                                kMainQueue.async {
                                    completion(arrFiles)
                                }
                                return
                            }
                            
                        } else {// It seems like a AVComposition video. Export this video into external url
                            print("AVComposition video")
                            ASMediaPicker.exportSlomoVideo(avAsset: avAsset) { (url1) in
                                file.url = url1
                                arrFiles.append(file)
                                
                                convertedAssets = convertedAssets + 1
                                if convertedAssets == totalAssets {
                                    kMainQueue.async {
                                        completion(arrFiles)
                                    }
                                    return
                                }
                            }
                        }
                    }
                    
                } else {// Media type is IMAGE
                    if let img = resource.assetImage {
                        downloadedImage = true
                        ///
                        /// add the downloaded resource image
                        var file = ASMediaFile.init(mediaType: .image, image: img, fileLocation: .gallery)
                        file.asset = asset
                        arrFiles.append(file)
                        
                        convertedAssets = convertedAssets + 1
                        if convertedAssets == totalAssets {
                            kMainQueue.async {
                                completion(arrFiles)
                            }
                            return
                        }
                    }
                }
            }
            
            if asset.mediaType == .video && downloadedImage == false {
                PHImageManager.default().requestAVAsset(forVideo: asset, options: requestVideoOption) { (avAsset, _, _) in
                    
                    ASMediaPicker.getFirstFrames(avAsset: avAsset) { (img) in
                        var file = ASMediaFile.init(mediaType: .video, fileLocation: .gallery)
                        file.asset = asset
                        file.avAsset = avAsset
                        if let image = img {
                            file.videoFrames = [image]
                        }
                        if let urlAsset = avAsset as? AVURLAsset {
                            file.url = urlAsset.url
                            arrFiles.append(file)
                            
                            convertedAssets = convertedAssets + 1
                            if convertedAssets == totalAssets {
                                kMainQueue.async {
                                    completion(arrFiles)
                                }
                                return
                            }
                            
                        } else {// It seems like a AVComposition video. Export this video into external url
                            print("AVComposition video")
                            ASMediaPicker.exportSlomoVideo(avAsset: avAsset) { (url1) in
                                file.url = url1
                                arrFiles.append(file)
                                
                                convertedAssets = convertedAssets + 1
                                if convertedAssets == totalAssets {
                                    kMainQueue.async {
                                        completion(arrFiles)
                                    }
                                    return
                                }
                            }
                        }
                    }
                }
                
            } else {
                if downloadedImage == false {
                    print("Downloading newly")
                    // Request the maximum size. If you only need a smaller size make sure to request that instead.
                    PHImageManager.default().requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: PHImageContentMode.default, options: requestImageOption) { (image, _) in
                        // Do something with image
                        if let img = image?.fixedOrientation() {
                            var file = ASMediaFile.init(mediaType: .image, image: img, fileLocation: .gallery)
                            file.asset = asset
                            arrFiles.append(file)
                        }
                        convertedAssets = convertedAssets + 1
                        if convertedAssets == totalAssets {
                            kMainQueue.async {
                                completion(arrFiles)
                            }
                            return
                        }
                    }
                }
            }
            
        }
    }
    
    //MARK:- EXPORT SLOMO VIDEO
    
    /// This function is used to export slomotion video into directory
    /// - Parameters:
    ///   - avAsset: AVAsset
    ///   - completed: URL?
    static func exportSlomoVideo(avAsset: AVAsset?, completed: @escaping(_ url: URL?) -> Void) {
        if let docDir = FileManager.default.pathFor(.documents) {
            let date = Date().toString(format: .custom("yyyyMMddHHmmss_SSS"))
            let fileName = String(format: "/slomovideo_%@_%@.mov", String.randomString(len: 5), date)
            let filePAth = docDir.appending(fileName)
            let fileUrl = URL.init(fileURLWithPath: filePAth)
            print(fileUrl)
            //
            //Begin slow mo video export
            if let videoAsset = avAsset {
                let exporter = AVAssetExportSession.init(asset: videoAsset, presetName: AVAssetExportPresetMediumQuality)
                exporter?.outputURL = fileUrl
                exporter?.outputFileType = .mov
                exporter?.shouldOptimizeForNetworkUse = true
                exporter?.exportAsynchronously {
                    kMainQueue.async {
                        print("SloMo Export completed")
                        switch exporter!.status {
                        case .failed, .cancelled:
                            if let error = exporter?.error {
                                print(error.localizedDescription)
                            }
                            kMainQueue.async {
                                completed(nil)
                            }
                        case .completed:
                            kMainQueue.async {
                                completed(exporter?.outputURL)
                            }
                        default:
                            print("Default")
                            kMainQueue.async {
                                completed(nil)
                            }
                        }
                    }
                }
            } else {
                kMainQueue.async {
                    completed(nil)
                }
            }
            
        } else {
            kMainQueue.async {
                completed(nil)
            }
        }
    }
    
    //MARK:- FRAMES
    
    /// Get all frames of video url
    /// - Parameters:
    ///   - avAsset: AVAsset
    ///   - completion: [UIImage]
    static func getAllFrames(avAsset: AVAsset?, completion: @escaping(_ frames: [UIImage]) -> Void) {
        var frames: [UIImage] = []
        
        guard let asset = avAsset else {
            completion(frames)
            return
        }
        
        let duration: Float64 = CMTimeGetSeconds(asset.duration)
        let generator: AVAssetImageGenerator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        for index: Int in 0 ..< Int(duration) {
            
            if let image = ASMediaPicker.getFrame(fromTime: Float64(index), generator: generator) {
                frames.append(image)
            }
        }
        completion(frames)
    }
    
    /// Get First frames of video url
    /// - Parameters:
    ///   - avAsset: AVAsset
    ///   - fromDuration: Float64 = 'From which duration thumbnail should be captured'
    ///   - completion: [UIImage]
    static func getFirstFrames(avAsset: AVAsset?, fromDuration: Float64 = 1, completion: @escaping(_ frames: UIImage?) -> Void) {
        var frames: UIImage?
        
        guard let asset = avAsset else {
            completion(frames)
            return
        }
        
        let duration: Float64 = CMTimeGetSeconds(asset.duration)
        let generator: AVAssetImageGenerator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        
        if duration > fromDuration {
            if let image = ASMediaPicker.getFrame(fromTime: fromDuration, generator: generator) {
                frames = image
            }
        }
        completion(frames)
    }
    
    /// Get frame on a particular time
    /// - Parameters:
    ///   - fromTime: Float64
    ///   - generator: AVAssetImageGenerator
    private static func getFrame(fromTime: Float64, generator: AVAssetImageGenerator) -> UIImage? {
        let time: CMTime = CMTimeMakeWithSeconds(fromTime, preferredTimescale: 600)
        let image: CGImage
        do {
            try image = generator.copyCGImage(at: time, actualTime: nil)
        } catch {
            return nil
        }
        return UIImage(cgImage: image).fixedOrientation()
    }
    
    //MARK:- SAVE TO GALLERY
    
    /// Save a file to gallery
    /// - Parameters:
    ///   - url: URL
    ///   - completion: isSuccess: Bool, _ err: String?
    static func saveToGallery(url: URL, completion: @escaping(_ isSuccess: Bool, _ err: String?) -> Void) {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)
        }) { (saved, error) in
            completion(saved, error?.localizedDescription)
        }
    }
}

