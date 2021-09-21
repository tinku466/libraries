//
//  LocalizedStrings.swift
//  ASVideoApp
//
//  Created by Ankit Saini on 10/10/20.
//

import Foundation

/// Localization fo used strings
enum L10n {
    /// Logout
    case logout
    /// Load From Files
    case loadFromFiles
    /// No internet connected
    case noInternet
    /// Camera
    case camera
    /// Cancel
    case cancel
    /// OK
    case ok
    /// Dismiss
    case dismiss
    /// Done
    case done
    /// Yes
    case yes
    /// Entered email or mobile is not valid
    case enteredEmailOrMobileIsNotValid
    /// Error
    case error
    /// No record found
    case noRecordFound
    /// Password must be 6 characters long
    case passwordMustBe6CharactersLong
    /// Photo Library
    case photoLibrary
    /// Please enter password
    case pleaseEnterPassword
    /// Please enter email or username
    case pleaseEnterEmailUsername
    /// Saved Photo Album
    case savedPhotoAlbum
    /// Select Source
    case selectSource
    /// Settings
    case settings
    /// Unable to upload file, try again
    case unableToUploadFileTryAgain
    /// Warning
    case warning
    /// You have denied the permission to access camera and gallery
    case youHaveDeniedThePermissionToAccessCamera
    /// "Name cannot be blank"
    case noName
    /// First name cannot be blank
    case noFirstName
    /// Last name cannot be blank
    case noLastName
    /// "Name should be atleast 2 character long"
    case nameLength
    /// Username cannot be blank
    case noUsername
    /// "Email cannot be blank"
    case noEmail
    /// "Country cannot be blank"
    case noCountry
    /// "Mobile number cannot be blank"
    case noPhone
    /// Please Enter the OTP
    case noOTP
    /// "Mobile number is not valid"
    case noValidPhone
    /// "Email is not valid"
    case invalidEmail
    /// Only characters are allowed
    case invalidName
    /// "Password cannot be blank"
    case noPwd
    /// "Password minimum 6 char long"
    case pwdLength
    /// Password is not valid
    case invalidPwd
    /// "Password does not match"
    case pwdNotMatched
    /// "Please choose a profile picture."
    case chooseprofilepic
    /// loader msg
    case loading
    /// Uploading..
    case uploading
    /// Invalid response from server
    case invalidResponse
    /// You are not authorised to login.
    case unauthorised
    /// "Maximum selection limit reached"
    case imgLimitReached
    /// No User is logged in.
    case noLoggedInUser
    /// is Required
    case isRequired
    /// Upload to server
    case uploadtoserver
    /// Authentication Failed
    case authenticationfailed
    /// NEXT
    case next
    /// Please enter 6-digit verification code
    case pleaseEnter6digitVerificationCode
    /// Do you want to cancel?
    case doYouWantToCancel
    ///INBOX
    case inbox
    /// PROFILE
    case profile
    /// UPDATE
    case update
    /// NEXT TIME
    case nextTime
    /// Are you sure?
    case areYouSure
    /// "Already On Call!!!"
    case onAnotherCall
}

// swiftlint:enable type_body_length
extension L10n: CustomStringConvertible {
    
    /// Description
    var description: String { return self.string }
    
    /// Actual String value
    var string: String {
        switch self {
        case .onAnotherCall:
            return L10n.tr(key: "Already On Call!!!")
        case .logout:
            return L10n.tr(key: "Logout")
        case .loadFromFiles:
            return L10n.tr(key: "Load From Files")
        case .noFirstName:
            return L10n.tr(key: "First name cannot be blank")
        case .noLastName:
            return L10n.tr(key: "Last name cannot be blank")
        case .noUsername:
            return L10n.tr(key: "Username cannot be blank")
        case .invalidName:
            return L10n.tr(key: "Only characters are allowed")
        case .update:
            return L10n.tr(key: "UPDATE")
        case .nextTime:
            return L10n.tr(key: "NEXT TIME")
        case .inbox:
            return L10n.tr(key: "INBOX")
        case .profile:
            return L10n.tr(key: "PROFILE")
        case .doYouWantToCancel:
            return L10n.tr(key: "Do you want to cancel?")
        case .yes:
            return L10n.tr(key: "Yes")
        case .pleaseEnter6digitVerificationCode:
            return L10n.tr(key: "Please enter 6-digit verification code")
        case .next:
            return L10n.tr(key: "NEXT")
        case .authenticationfailed:
            return L10n.tr(key: "Authentication Failed")
        case .noInternet:
            return L10n.tr(key: "No internet connected")
        case .camera:
            return L10n.tr(key: "Camera")
        case .cancel:
            return L10n.tr(key: "Cancel")
        case .ok:
            return L10n.tr(key: "OK")
        case .dismiss:
            return L10n.tr(key: "Dismiss")
        case .done:
            return L10n.tr(key: "Done")
        case .enteredEmailOrMobileIsNotValid:
            return L10n.tr(key: "Entered email or mobile is not valid")
        case .error:
            return L10n.tr(key: "Error")
        case .noRecordFound:
            return L10n.tr(key: "No record found")
        case .passwordMustBe6CharactersLong:
            return L10n.tr(key: "Password must be 6 characters long")
        case .invalidPwd:
            return L10n.tr(key: "Password is not valid")
        case .photoLibrary:
            return L10n.tr(key: "Photo Library")
        case .pleaseEnterPassword:
            return L10n.tr(key: "Please enter password")
        case .pleaseEnterEmailUsername:
            return L10n.tr(key: "Please enter email or username")
        case .savedPhotoAlbum:
            return L10n.tr(key: "Saved Photo Album")
        case .selectSource:
            return L10n.tr(key: "Select Source")
        case .settings:
            return L10n.tr(key: "Settings")
        case .unableToUploadFileTryAgain:
            return L10n.tr(key: "Unable to upload file, try again")
        case .warning:
            return L10n.tr(key: "Warning")
        case .youHaveDeniedThePermissionToAccessCamera:
            return L10n.tr(key: "You have denied the permission to access camera and gallery")
        case .noName:
            return L10n.tr(key: "Name cannot be blank")
        case .nameLength:
            return L10n.tr(key: "Minimum 2 characters required")
        case .noEmail:
            return L10n.tr(key: "Email cannot be blank")
        case .noCountry:
            return L10n.tr(key: "Country cannot be blank")
        case .invalidEmail:
            return L10n.tr(key: "Email is not valid")
        case .noOTP:
            return L10n.tr(key: "Please Enter the OTP")
        case .noPhone:
            return L10n.tr(key: "Mobile number cannot be blank")
        case .noValidPhone:
            return L10n.tr(key: "Mobile number is not valid")
        case .noPwd:
            return L10n.tr(key: "Password cannot be blank")
        case .pwdLength:
            return L10n.tr(key: "Minimum 6 characters required")
        case .pwdNotMatched:
            return L10n.tr(key: "Password does not match")
        case .chooseprofilepic:
            return L10n.tr(key: "Please choose a profile picture.")
        case .loading:
            return L10n.tr(key: "Loading")
        case .uploading:
            return L10n.tr(key: "Uploading")
        case .invalidResponse:
            return L10n.tr(key: "Invalid response from server")
        case .unauthorised:
            return L10n.tr(key: "You are not authorised to login.")
        case .imgLimitReached:
            return L10n.tr(key: "Maximum selection limit reached")
        case .noLoggedInUser:
            return L10n.tr(key: "No User is Logged In")
        case .isRequired:
            return L10n.tr(key: "is required")
        case .uploadtoserver:
            return L10n.tr(key: "Upload to server as:")
        case .areYouSure:
            return L10n.tr(key: "Are you sure?")
        }
    }
    
    private static func tr(key: String, _ args: CVarArg...) -> String {
        let format = NSLocalizedString(key, bundle: Bundle(for: BundleToken.self), comment: "")
        return String(format: format, locale: Locale.current, arguments: args)
    }
}

/// Value for localised key
/// - Parameter key: String
func tr(_ key: L10n) -> String {
    return key.string
}

private final class BundleToken {}
