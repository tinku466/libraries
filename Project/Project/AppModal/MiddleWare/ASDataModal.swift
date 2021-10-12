//
//  ASDataModal.swift
//  ASVideoApp
//
//  Created by Ankit Saini on 10/10/20.
//

import UIKit

/// This class is responsible for handling all API request's and validations of response.
class ASDataModal: NSObject {
    
    /// Shared Instance
    static let shared = ASDataModal()
    
    /// Utilities Shared Instance
    private let objUtil = ASUtility.shared
    
    /// JSONDecoder
    let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        return jsonDecoder
    }()
    
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
                                        completion: @escaping (T?, ResponseTuples?) -> Void) {
        
        print(parameters)
        weak var weakSelf = self
        ASWebServices.shared.requestPostDataApi(url: url, parameters: parameters, method: method, contentType: contentType, extraHeader: extraHeader) { (result: Result<Data, Error>, _ statusCode: Int) in
            ///
            /// Convert into codable format
            weakSelf?.codableFormatter(response: result, completion: { (result1: Result<Success<T>, Error>) in
                
                let response = weakSelf?.responseOutput(result: result1, showErrorToast: showErrorToast, statusCode)
                completion(response?.0, response?.1)
            })
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
    ///   - extraHeader: send header fields
    ///   - showErrorToast: Weather to show error alert or not.
    ///   - completion: validatedData => The response of the APi, isSuccess => true or false based on status code, msg: String of the message received with response.
    func requestUploadFileApi<T: Codable>(with url: String,
                                          parameters: Dictionary<String, Any>,
                                          method: String = HttpMethods.post,
                                          contentType: String = ContentType.multipartFormData,
                                          extraHeader: Dictionary<String, String> = [:],
                                          mediaFiles: [MediaFiles],
                                          showErrorToast: Bool = true,
                                          completion: @escaping (T?, ResponseTuples?) -> Void) {
        
        print(parameters)
        weak var weakSelf = self
        ASWebServices.shared.requestMultiPartApi(url: url, parameters: parameters, mediaFiles: mediaFiles, extraHeader: extraHeader) { (result: Result<Data, Error>, _ statusCode: Int) in
            ///
            /// Convert into codable format
            weakSelf?.codableFormatter(response: result, completion: { (result1: Result<Success<T>, Error>) in
              
                let response = weakSelf?.responseOutput(result: result1, showErrorToast: showErrorToast, statusCode)
                completion(response?.0, response?.1)
            })
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
                                       modifyUrl: Bool = true,
                                       completion: @escaping (T?, ResponseTuples?) -> Void) {
        
        weak var weakSelf = self
        ASWebServices.shared.requestGETDataApi(url: url, parameters: parameters, method: method, extraHeader: extraHeader, modifyUrl: modifyUrl) { (result: Result<Data, Error>, _ statusCode: Int) in
            ///
            /// Convert into codable format
            weakSelf?.codableFormatter(response: result, completion: { (result1: Result<Success<T>, Error>) in
              
                let response = weakSelf?.responseOutput(result: result1, showErrorToast: showErrorToast, statusCode)
                completion(response?.0, response?.1)
            })
        }
    }
}

//MARK:- RESPONSE VALIDATIONS
extension ASDataModal {
    /// Convert APi response into codable format
    /// - Parameters:
    ///   - response: Result<Data, Error>
    ///   - completion: Result<T, Error>
    func codableFormatter<T: Codable>(response: Result<Data, Error>, completion: @escaping (Result<T, Error>) -> Void) {
        switch response {
        case .failure(let error):
            completion(.failure(error))
            return
        case .success(let data):
            do {
                let reply = String(data: data, encoding: .utf8)
                print(reply ?? "")
                
                let values = try self.jsonDecoder.decode(T.self, from: data)
                completion(.success(values))
                return
            } catch {
                let reply = String(data: data, encoding: .utf8)
                print(reply ?? "")
                
                let error = NSError(domain: "decoding issue", code: 0, userInfo: [NSLocalizedDescriptionKey: reply ?? "Response is not in correct format"])
                completion(.failure(error))
                return
            }
        }
    }
    
    /// This function will validate and returns the validated response of request.
    /// - Parameter result: Result<Success<T>, Error>
    /// - Parameter showErrorToast: If true then app will show a toast for any error that occurs else false.
    private func responseOutput<T: Codable>(result: Result<Success<T>, Error>, showErrorToast: Bool = true, _ statusCode: Int) -> (T?, ResponseTuples) {
        
        switch result {
        case .failure(let error):
            print(error.localizedDescription)
            
            let response = ASDataModal.shared.validateData(with: false, statusCode: statusCode, error: [error.localizedDescription], showAlert: showErrorToast)
            
            let tuple = ResponseTuples.init(isSuccess: response.isSuccess, statusCode: response.statusCode, error: response.msg, token: nil)
            
            
            return (nil, tuple)
            
        case .success(let data):
            let response = ASDataModal.shared.validateData(with: data.isSuccess, statusCode: statusCode, error: data.error ?? ["No Error"], showAlert: showErrorToast)
            
            let tuple = ResponseTuples.init(isSuccess: response.isSuccess, statusCode: response.statusCode, error: response.msg, token: data.token)
            
            return (data.data, tuple)
        }
    }
    
    /// This function is used to validate the response received from API in order to check success and failure and custom handling.
    ///
    /// - Parameters:
    ///   - isSuccess: Bool
    ///   - statusCode: Status code of the request i.e 200, 401 etc.
    ///   - error: Error returned by HTTP Client if any, otherwise empty.
    ///   - showAlert: If want to show the alert for failure.
    /// - Returns:  isSuccess => true or false based on status code, msg: String of the message received with response.
    private func validateData(with isSuccess: Bool, statusCode: Int, error: [String]?, showAlert: Bool = false) -> (isSuccess: Bool, msg: [String], statusCode: Int) {
        
        if statusCode == 200 {// OK
            if isSuccess == true {
                return (true, error ?? [], statusCode)
            }
            return (false, error ?? [], statusCode)
        } else if statusCode == 400 {// Bad Request
            return (false, error ?? [], statusCode)
            
        } else if statusCode == 404 || statusCode == 401 {// Not Found
            if let message = error, message.isEmpty == false {
                let msg = message.joined(separator: "\n")
                kMainQueue.async {
                    ASUtility.shared.showToast(with: msg) {
                        //LogOut User
                        DefaultCenter.notification.post(name: Notifications.logout.name, object: nil)
                    }
                }
            }
            return (false, [], statusCode)
        } else {
            if showAlert == true {
                if let message = error, message.isEmpty == false {
                    let msg = message.joined(separator: "\n")
                    kMainQueue.async {
                        ASUtility.shared.dissmissAlert(title: "", message: msg, lblDone: L10n.ok.string)
                    }
                    return (false, [], statusCode)
                }
            }
        }
        return (false, error ?? [], statusCode)
    }
}
