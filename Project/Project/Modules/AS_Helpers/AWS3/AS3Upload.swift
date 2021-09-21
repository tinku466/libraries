//
//  AS3Upload.swift
//  ABBC
//
//  Created by Mr. X on 07/05/21.
//

/*import Foundation
import AWSS3
import AWSCore

let kAWSAccessKey: String = ""
let kAWSSecretKey: String = ""
let kAWSBucketName: String = ""


/// This class is responsible to upload any file over S3 bucket on AWS.
class AS3Upload: NSObject {
    static let sharedInstance: AS3Upload = {
        let instance = AS3Upload()
        
        instance.connectWithAWS()
        
        return instance
    }()
    
    /// This function is used to authorize user with AWS.
    func connectWithAWS() {
        
        let credentialsProvider = AWSStaticCredentialsProvider(accessKey: kAWSAccessKey, secretKey: kAWSSecretKey)
        let configuration = AWSServiceConfiguration(region: .CACentral1, credentialsProvider: credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        
    }
    
    /// upload a file to AWS S3 bucket.
    ///
    /// - Parameters:
    ///   - file: AWSS3File Modal of inputs
    ///   - completion: success: Bool, _ url: String, _ err: String
    func uploadFileToS3(file: ASMediaFile, completion:@escaping (_ response: AWSS3Response?, _ file: ASMediaFile) -> Void) {
        guard let url = file.url, let fileName = file.title else {
            completion(nil, file)
            return
        }// URL.init(fileURLWithPath: file.fileURL)
        var contentType: String = "image/jpg"
        switch file.mediaType {
        case .image:
            contentType = "image/jpg"
        case .file:
            contentType = "file/pdf"
        case .audio:
            contentType = "image/mp3"
        case .video:
            contentType = "image/mp4"
        }
        ///
        /// Start Uploading process
        ///
        let expression = AWSS3TransferUtilityUploadExpression()
        expression.setValue("public-read", forRequestHeader: "x-amz-acl")
        
        let transferUtility = AWSS3TransferUtility.default()
        
        let s3BucketName = kAWSBucketName
        
        transferUtility.uploadFile(url, bucket: s3BucketName, key: fileName, contentType: contentType, expression: expression) { (task, error) in
            kMainQueue.async {
                if error != nil {
                    print("Upload failed ❌ (\(error!))")
                    completion(AWSS3Response.init(success: false, url: "", err: "Upload failed ❌ (\(error!.localizedDescription))", fileName: fileName), file)
                    return
                }
                if task.status == AWSS3TransferUtilityTransferStatusType.completed {
                    let s3URL = "https://\(s3BucketName).s3.amazonaws.com/\(task.key)"
                    print("Uploaded to:\n\(s3URL)")
                    completion(AWSS3Response.init(success: true, url: s3URL, err: "", fileName: task.key), file)
                    return
                } else {
                    print("Not uploaded")
                }
            }
            
            }.continueWith { (task) -> Any? in
                if let error = task.error {
                    print("Upload failed ❌ (\(error))")
                    completion(AWSS3Response.init(success: false, url: "", err: "Upload failed ❌ (\(error.localizedDescription))", fileName: fileName), file)
                    return nil
                }
                
                if task.result != nil, task.isCompleted == true {
                    
                    let s3URL = "https://\(s3BucketName).s3.amazonaws.com/\(task.result!.key)"
                    print("Uploading Start of : \(s3URL)")
                    
                } else {
                    print("Unexpected empty result.")
                    
                }
                return nil
        }
    }
    
    /// Start uploading files on S3
    /// - Parameters:
    ///   - files: [ASMediaFile]
    ///   - showLoader: Bool = true
    ///   - completion: [ASMediaFile]
    static func startUploading(files: [ASMediaFile], showLoader: Bool = true, completion: @escaping(_ response: [ASMediaFile]) -> Void) {
        
        if showLoader == true {
            kAppDelegate.showLoader(with: L10n.uploading.string, interaction: false)
        }
        
        
        var arrSuccessFiles: [ASMediaFile] = []
        var sentFiles: Int = 0
        let totalFiles: Int = files.count
        
        for item in files {
            if item.fileLocation == .web {
                arrSuccessFiles.append(item)
                sentFiles = sentFiles + 1
                if sentFiles == totalFiles {
                    kAppDelegate.hideLoader()
                    completion(arrSuccessFiles)
                    return
                }
                
            } else if item.url != nil {
                AS3Upload.sharedInstance.uploadFileToS3(file: item) { (response, uploadedFile) in
                    if response?.success == true {
                        var newFile = uploadedFile
                        newFile.awsUrlStr = response?.url
                        arrSuccessFiles.append(newFile)
                    }
                    sentFiles = sentFiles + 1
                    if sentFiles == totalFiles {
                        kAppDelegate.hideLoader()
                        completion(arrSuccessFiles)
                        return
                    }
                }
            } else {
                if let file = ASFileDir.save(file: item) {
                    AS3Upload.sharedInstance.uploadFileToS3(file: file) { (response, uploadedFile) in
                        if response?.success == true {
                            var newFile = uploadedFile
                            newFile.awsUrlStr = response?.url
                            arrSuccessFiles.append(newFile)
                        }
                        sentFiles = sentFiles + 1
                        if sentFiles == totalFiles {
                            kAppDelegate.hideLoader()
                            completion(arrSuccessFiles)
                            return
                        }
                    }
                }
            }
        }
        if sentFiles == totalFiles {
            kAppDelegate.hideLoader()
            completion(arrSuccessFiles)
            return
        }
    }
}

/// Modal of aws s3 response
struct AWSS3Response {
    var success: Bool
    var url: String
    var err: String
    var fileName: String
}
*/
