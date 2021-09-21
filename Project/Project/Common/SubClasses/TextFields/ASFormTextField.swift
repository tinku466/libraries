//
//  ASFormTextField.swift
//  ASVideoApp
//
//  Created by Ankit Saini on 10/10/20.
//

import Foundation
import UIKit
import IQKeyboardManagerSwift

/// Form Fields Delegates
protocol ASFormTextFieldDelegate: class {
    
    /// Text field is clicked
    /// - Parameter textField: UITextField
    func ASFormTextFieldClicked(textField: UITextField)
    
    /// Return key pressed of textfield
    /// - Parameter textField: UITextField
    func ASFormTextFieldShouldReturn(textField: UITextField)
    
    /// Return if text field is edited
    /// - Parameter text: String?
    func ASFormTextFieldEdited(text: String?)
    
    /// Field begin editing
    func ASFormTextFieldDidBeginEditing(_ textField: UITextField)
    
    /// Field ended editing
    func ASFormTextFieldDidEndEditing(_ textField: UITextField)
}

/// Make Protocol optional
extension ASFormTextFieldDelegate {
    
    /// This Makes this protocol Optional
    func ASFormTextFieldClicked(textField: UITextField) {}
    /// This Makes this protocol Optional
    func ASFormTextFieldShouldReturn(textField: UITextField) {}
    
    /// Return if text field is edited
    func ASFormTextFieldEdited(text: String?) {}
    
    /// Field begin editing
    func ASFormTextFieldDidBeginEditing(_ textField: UITextField) {}
    
    /// Field ended editing
    func ASFormTextFieldDidEndEditing(_ textField: UITextField) {}
}

/// This class will represent the form textfields used in the application.
@IBDesignable class ASFormTextField: ASTextField, UITextFieldDelegate {
    
    /// Type of fields
    enum FieldType {
        /// Clickable field
        case clickable
        
        /// Normal field
        case normal
    }
    
    /// text field Actions
    var textFieldAction: FieldType = .normal
    
    /// Delegate for current textfield
    weak var formDelegate: ASFormTextFieldDelegate?
    
    /// Character limit in text field
    var charLimit: Int = -1
    
    
    /// Setup Textfield properties
    /// - Parameter placeholder: String
    /// - Parameter error: String
    /// - Parameter returnKey: UIReturnKeyType
    /// - Parameter actionType: FieldType
    /// - Parameter paddingLeft: CGFloat
    /// - Parameter charLimit: Int
    func setupFields(placeholder: String, error: String = "", returnKey: UIReturnKeyType = .done, actionType: FieldType = .normal, paddingLeft: CGFloat = 0.0, charLimit: Int = -1) {
        
        weak var weakSelf = self
        self.placeholder = placeholder
        self.addPaddingLeftIcon(nil, padding: paddingLeft)
        self.autocorrectionType = .no
        self.keyboardType = .emailAddress
        self.returnKeyType = returnKey
        self.delegate = weakSelf
        self.textFieldAction = actionType
        self.charLimit = charLimit
    }
    
    //MARK:- TEXTFIELD DELEGATES
    
    /// Asks the delegate if editing should begin in the specified text field.
    /// - Parameter textField: UITextField
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if self.textFieldAction == .clickable {
            print("clickable")
            formDelegate?.ASFormTextFieldClicked(textField: textField)
            return false
        }
        return true
    }
    
    /// TextField start editing
    func textFieldDidBeginEditing(_ textField: UITextField) {
        formDelegate?.ASFormTextFieldDidBeginEditing(textField)
    }
    
    /// Textfield ended editing
    func textFieldDidEndEditing(_ textField: UITextField) {
        formDelegate?.ASFormTextFieldDidEndEditing(textField)
    }
    
    /// Asks the delegate if the text field should process the pressing of the return button.
    /// - Parameter textField: UITextField
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.returnKeyType == .done {
            IQKeyboardManager.shared.resignFirstResponder()
        }
        formDelegate?.ASFormTextFieldShouldReturn(textField: textField)
        return false
    }
    
    /// Asks the delegate if the specified text should be changed.
    /// - Parameter textField: UITextField
    /// - Parameter range: NSRange
    /// - Parameter string: String
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let text = textField.text,
           let textRange = Range(range, in: text) {
           let updatedText = text.replacingCharacters(in: textRange,
                                                       with: string)
            
            formDelegate?.ASFormTextFieldEdited(text: updatedText)
            if charLimit > 0 && updatedText.count > charLimit {
                return false
            }
        }
        return true
    }
}
