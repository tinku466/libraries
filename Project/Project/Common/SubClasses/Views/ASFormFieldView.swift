//
//  ASFormFieldView.swift
//  ASVideoApp
//
//  Created by Ankit Saini on 10/10/20.
//

import Foundation
import UIKit
import IQKeyboardManagerSwift

/// Form Fields Delegates
protocol ASFormFieldViewDelegate: class {
    
    /// Text field is clicked
    /// - Parameter textField: UITextField
    func ASFormFieldViewClicked(textField: UITextField)
    
    /// Return key pressed of textfield
    /// - Parameter textField: UITextField
    func ASFormFieldViewShouldReturn(textField: UITextField)
    
    /// Return if text field is edited
    /// - Parameter text: String?
    func ASFormFieldViewEdited(text: String?)
    
    /// Field begin editing
    func ASFormFieldViewDidBeginEditing(_ textField: UITextField)
    
    /// Field ended editing
    func ASFormFieldViewDidEndEditing(_ textField: UITextField)
}

/// Make Protocol optional
extension ASFormFieldViewDelegate {
    
    /// This Makes this protocol Optional
    func ASFormFieldViewClicked(textField: UITextField) {}
    /// This Makes this protocol Optional
    func ASFormFieldViewShouldReturn(textField: UITextField) {}
    
    /// Return if text field is edited
    func ASFormFieldViewEdited(text: String?) {}
    
    /// Field begin editing
    func ASFormFieldViewDidBeginEditing(_ textField: UITextField) {}
    
    /// Field ended editing
    func ASFormFieldViewDidEndEditing(_ textField: UITextField) {}
}

/// View of Form field
@IBDesignable class ASFormFieldView: ASView {
    /// Lable for textfield
    var lblPlaceholder: UILabel = UILabel()
    
    /// Text field for the Form
    var textField: ASFormTextField = ASFormTextField()
    
    /// form delegate
    weak var fieldDelegate: ASFormFieldViewDelegate?
    
    /// Is field clickable i.e act as button
    var isFieldClickable: Bool = false
    
    /// Character limit in text field
    var charLimit: Int = -1
    
    /// View color
    @IBInspectable public var viewColor: UIColor? {
        didSet {
            setColors()
        }
    }
    
    /// Textfield color
    @IBInspectable public var textFieldColor: UIColor? {
        didSet {
            setColors()
        }
    }
    
    /// Textfield background color
    @IBInspectable public var textFieldBGColor: UIColor? {
        didSet {
            setColors()
        }
    }
    
    /// Textfield Placeholder string
    @IBInspectable public var placeholder: String? {
        didSet {
            setPlaceholder()
        }
    }
    
    /// Textfield Placeholder string
    @IBInspectable public var keyboard: UIKeyboardType = .emailAddress {
        didSet {
            setKeyboard()
        }
    }
    
    /// Textfield Placeholder string
    @IBInspectable public var enterKey: UIReturnKeyType = .done {
        didSet {
            setKeyboard()
        }
    }
    
    //MARK:-
    //MARK:- Initialization
    
    /// Initialize main view
    /// - Parameter frame: CGRect
    override public init(frame: CGRect) {
        super.init(frame: frame)
        customInitialization()
    }
    
    
    /// Initializations
    ///
    /// - Parameter aDecoder: NSCoder
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInitialization()
    }
    
    //MARK:- Overriden methods.
    
    /// prepareForInterfaceBuilder
    override public func prepareForInterfaceBuilder() {
        customInitialization()
    }
    
    /// layoutSubviews
    override public func layoutSubviews() {
        super.layoutSubviews()
    }
    
    //MARK:- CUSTOMISATIONS
    
    /// Initialize all views
    private func customInitialization() {
        weak var weakSelf = self
        ////
        ////Setup text field
        ///
        lblPlaceholder.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(lblPlaceholder)
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textField)
        
        NSLayoutConstraint.activate([
            lblPlaceholder.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            lblPlaceholder.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            lblPlaceholder.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            lblPlaceholder.heightAnchor.constraint(equalToConstant: 30),
            
            textField.topAnchor.constraint(equalTo: lblPlaceholder.bottomAnchor, constant: 0),
            textField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            textField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            textField.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
        ])
        textField.setupFields(placeholder: (placeholder ?? ""), error: "", returnKey: enterKey, actionType: .normal, paddingLeft: 8.0)
        setFieldProperties()
        setupViewProperties()
        textField.delegate = weakSelf
    }
    
    /// Set properties for current View
    func setupViewProperties() {
        borderColor = Color.border
        setColors()
    }
    
    /// Set the colors of all views
    private func setColors() {
        if viewColor == nil {
            self.backgroundColor = .clear
        } else {
            self.backgroundColor = viewColor
        }
        
        if textFieldColor == nil {
            
            textField.textColor = Color.textFieldActiveColor
            lblPlaceholder.textColor = Color.textFieldActiveColor
        } else {
            textField.textColor = textFieldColor
            lblPlaceholder.textColor = textFieldColor
        }
        
        if textFieldBGColor == nil {
            textField.backgroundColor = Color.textFieldBGColor
        } else {
            textField.backgroundColor = textFieldBGColor
        }
    }
    
    /// Set properties of Fields
    private func setFieldProperties() {
        textField.font = Font.textFieldFont
        lblPlaceholder.font = Font.textFieldFont
        textField.cornerRadius = 4.0
        textField.borderWidth = 0.2
        textField.borderColor = Color.border
    }
    
    /// Set Placeholders
    func setPlaceholder() {
        textField.placeholder = placeholder
        lblPlaceholder.text = placeholder
    }
    
    /// Set Keyboard
    func setKeyboard() {
        textField.keyboardType = keyboard
        textField.returnKeyType = enterKey
    }
}

//MARK:- UITextFieldDelegate
extension ASFormFieldView: UITextFieldDelegate {
    /// Asks the delegate if editing should begin in the specified text field.
    /// - Parameter textField: UITextField
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if isFieldClickable == true {
            print("clickable")
            fieldDelegate?.ASFormFieldViewClicked(textField: textField)
            return false
        }
        return true
    }
    
    /// Field begin Editing
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let field = textField as? ASFormTextField {
            switchFieldColors(field: field, didStart: true)
        }
        fieldDelegate?.ASFormFieldViewDidBeginEditing(textField)
    }
    
    /// Field end editing
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let field = textField as? ASFormTextField {
            switchFieldColors(field: field, didStart: false)
        }
        fieldDelegate?.ASFormFieldViewDidEndEditing(textField)
    }
    
    /// Asks the delegate if the specified text should be changed.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.returnKeyType == .done {
            IQKeyboardManager.shared.resignFirstResponder()
        }
        fieldDelegate?.ASFormFieldViewShouldReturn(textField: textField)
        return false
    }
    /// Asks the delegate if the specified text should be changed.
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let text = textField.text,
            let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange,
                                                       with: string)
            
            fieldDelegate?.ASFormFieldViewEdited(text: updatedText)
            if charLimit > 0 && updatedText.count > charLimit {
                return false
            }
        }
        
        return true
    }
    
    
    /// Switch The colors fo the Form fields View
    /// - Parameter field: ASFormTextField
    /// - Parameter didStart: Did field started
    func switchFieldColors(field: ASFormTextField, didStart: Bool) {
        /*
         self.placeholderColor = Color.lightText.value
         */
//        var bgColor: UIColor = Color.textFieldBGColor
//        var txtColor: UIColor = UIColor.white
//
//        if didStart == true {
//            bgColor = .white
//            txtColor = Color.textFieldActiveColor
//        }
//        viewColor = bgColor
//        textField.textColor = txtColor
    }
    
}
