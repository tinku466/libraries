//
//  ASDataModal.swift
//  SwiftProject
//
//  Created by Gaurav Murghai on 20/03/19.
//  Copyright © 2019 Ankit Saini. All rights reserved.
//

import Foundation

class ASDataModal: NSObject {
    
    let objUtil = ASUtility.shared
    
    static let shared = ASDataModal()
    
    //MARK:- POST REQUEST
    
    /// This function is used to hit api to server with parameters.
    ///
    /// - Parameters:
    ///   - url: Url string of the request.
    ///   - parameters: Parameters which is required to use the API.
    ///   - method: Http method for the APi.
    ///   - contentType: Content Type for the request.
    ///   - extraHeader: send header fields
    ///   - showErrorToast: Weather to show error alert or not.
    ///   - completion: validatedData => The response of the APi, isSuccess => true or false based on status code, msg: String of the message received with response.
    func requestPostDataApi<T: Codable>(with url: String,
                                        parameters: Dictionary<String, Any>,
                                        method: String = HttpMethods.post,
                                        contentType: String = ContentType.applicationJson,
                                        extraHeader: Dictionary<String, String> = [:],
                                        showErrorToast: Bool = true,
                                        completion: @escaping (T?, ResponseTuples) -> Void) {
        
        print(parameters)
        
        ASWebServices.shared.requestPostDataApi(url: url, parameters: parameters, method: method, contentType: contentType, extraHeader: extraHeader) { (result: Result<Success<T>, Error>) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
                let response = ASDataModal.shared.validateData(with: false, statusCode: 201, error: error.localizedDescription, showAlert: showErrorToast)
                let tuple = ResponseTuples.init(isSuccess: response.isSuccess, statusCode: response.statusCode, error: response.msg, errorCode: nil, pageNo: nil, pageSize: nil, total: nil)
                completion(nil, tuple)
            case .success(let data):
                let response = ASDataModal.shared.validateData(with: data.isSuccess, statusCode: data.statusCode, error: data.error, showAlert: showErrorToast)
                let tuple = ResponseTuples.init(isSuccess: response.isSuccess, statusCode: response.statusCode, error: response.msg, errorCode: data.errorCode, pageNo: data.pageNo, pageSize: data.pageSize, total: data.total)
                
                completion(data.data ?? data.items, tuple)
            }
        }
    }
    
    //MARK:- UPLOAD FILE REQUEST
    
    /// This function is used to hit api to server with parameters.
    ///
    /// - Parameters:
    ///   - url: Url string of the request.
    ///   - parameters: Parameters which is required to use the API.
    ///   - method: Http method for the APi.
    ///   - contentType: Content Type for the request.
    ///   - showErrorToast: Weather to show error alert or not.
    ///   - completion: validatedData => The response of the APi, isSuccess => true or false based on status code, msg: String of the message received with response.
    func requestUploadFileApi<T: Codable>(with url: String,
                                          parameters: Dictionary<String, Any>,
                                          method: String = HttpMethods.post,
                                          contentType: String = ContentType.applicationJson,
                                          mediaFiles: [MediaFiles],
                                          showErrorToast: Bool = true,
                                          completion: @escaping (T?, ResponseTuples) -> Void) {
        
        print(parameters)
        
        ASWebServices.shared.requestMultiPartApi(url: url, parameters: parameters, mediaFiles: mediaFiles) { (result: Result<Success<T>, Error>) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
                let response = ASDataModal.shared.validateData(with: false, statusCode: 201, error: error.localizedDescription, showAlert: showErrorToast)
                let tuple = ResponseTuples.init(isSuccess: response.isSuccess, statusCode: response.statusCode, error: response.msg, errorCode: nil, pageNo: nil, pageSize: nil, total: nil)
                completion(nil, tuple)
            case .success(let data):
                let response = ASDataModal.shared.validateData(with: data.isSuccess, statusCode: data.statusCode, error: data.error, showAlert: showErrorToast)
                let tuple = ResponseTuples.init(isSuccess: response.isSuccess, statusCode: response.statusCode, error: response.msg, errorCode: data.errorCode, pageNo: data.pageNo, pageSize: data.pageSize, total: data.total)
                
                completion(data.data ?? data.items, tuple)
            }
        }
        
    }
    
    //MARK:- GET REQUEST
    
    /// This function is used to hit api to server with parameters.
    ///
    /// - Parameters:
    ///   - url: Url string of the request.
    ///   - parameters: Parameters which is required to use the API.
    ///   - method: Http method for the APi.
    ///   - extraHeader: Header fields for request
    ///   - showErrorToast: Weather to show error alert or not.
    ///   - completion: validatedData => The response of the APi, isSuccess => true or false based on status code, msg: String of the message received with response.
    func requestGetDataApi<T: Codable>(with url: String,
                                       parameters: Dictionary<String, Any>,
                                       method: String = HttpMethods.get,
                                       extraHeader: Dictionary<String, String> = [:],
                                       showErrorToast: Bool = true,
                                       completion: @escaping (T?, ResponseTuples) -> Void) {
        
        ASWebServices.shared.requestGETDataApi(url: url, parameters: parameters, method: method, extraHeader: extraHeader) { (result: Result<Success<T>, Error>) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
                let response = ASDataModal.shared.validateData(with: false, statusCode: 201, error: error.localizedDescription, showAlert: showErrorToast)
                let tuple = ResponseTuples.init(isSuccess: response.isSuccess, statusCode: response.statusCode, error: response.msg, errorCode: nil, pageNo: nil, pageSize: nil, total: nil)
                completion(nil, tuple)
            case .success(let data):
                let response = ASDataModal.shared.validateData(with: data.isSuccess, statusCode: data.statusCode, error: data.error, showAlert: showErrorToast)
                let tuple = ResponseTuples.init(isSuccess: response.isSuccess, statusCode: response.statusCode, error: response.msg, errorCode: data.errorCode, pageNo: data.pageNo, pageSize: data.pageSize, total: data.total)
                
                completion(data.data ?? data.items, tuple)
            }
        }
    }
    
}
extension ASDataModal {
    
    /// This function is used to validate the response received from API in order to check success and failure and custom handling.
    ///
    /// - Parameters:
    ///   - isSuccess: Bool
    ///   - statusCode: Status code of the request i.e 200, 401 etc.
    ///   - error: Error returned by HTTP Client if any, otherwise empty.
    ///   - showAlert: If want to show the alert for failure.
    /// - Returns:  isSuccess => true or false based on status code, msg: String of the message received with response.
    func validateData(with isSuccess: Bool,
                      statusCode: Int,
                      error: String?,
                      showAlert: Bool = false) -> (isSuccess: Bool, msg: String, statusCode: Int) {
        
        var msg = ""
        if let message = error {
            msg = message
        }
        
        if statusCode == 200 {
            if isSuccess == true {
                return (true, msg, statusCode)
            }
            return (false, msg, statusCode)
        }
        
        if showAlert == true {
            if msg.isEmpty == false {
                kMainQueue.async {
                    ASUtility.shared.dissmissAlert(title: "", message: msg, lblDone: L10n.ok.string)
                }
                return (false, "", statusCode)
            }
        }
        return (false, msg, statusCode)
    }
}
