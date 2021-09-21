//
//  StoryboardConstants.swift
//  Anra
//
//  Created by Mr. X on 04/06/21.
//

import Foundation

//MARK:- Storyboard
/// USAGE :
/// - let storyboard = Storyboard.main.instance
/// - let objVC = Storyboard.main.instance.instantiateViewController(withIdentifier: ViewController.storyboardID)
/// - guard let vc = Storyboard.main.viewController(viewControllerClass: ViewController.self) else { return }
/// - Extented further in EnumUtil.swift class
enum Storyboard: String {
    /// SignIn_Up Storyboard
    case login = "ASignIn"
    
    /// Chat storyboard
    case chat = "Chat"
    
    /// Group storyboard
    case group = "Group"
    
    /// ASAlertPopUpStoryboard
    case alertPopUP = "ASAlertPopUpStoryboard"
    
    /// ASFiles
    case files = "ASFiles"
}
