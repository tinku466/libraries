//
//  ASAlertPopUP.swift
//  ASVideoApp
//
//  Created by Ankit Saini on 11/10/20.
//

import UIKit

///Configuration Modal for 'ASAlertPopUP'
struct ASAlertConfiguration {
    /// External content container view Height
    var containerHeight: CGFloat = 0.0
    
    /// If yes then auto layout will be applied
    var applyAutoLayout: Bool = false
    
    /// Custom View for Continer
    var containerView: UIView?
    
    /// Dismiss popup on touch outside
    var dismissOnTouch: Bool = true
    
}

/// Custom Alert PopUp Modal
class ASAlertPopUP: UIViewController {
    ///
    //MARK:- PROPERTIES
    ///
    /// Configurations for UI
    var config = ASAlertConfiguration()
    /// Title for modal
    var strTitle: String = ""
    
    /// Message for modal
    var strMessage: String = ""
    
    /// Title for done button 'default is hidden'
    var buttonDoneTitle: String?
    
    /// Title for done button 'default is hidden'
    var buttonCancelTitle: String?
    
    /// When a choice is selected then this callback will be returned with selected values
    var onSelection: ((_ choice: Bool) -> Void)?
    
    ///
    //MARK:- OUTLETS
    ///
    /// Bacground button to dismiss on touch up
    @IBOutlet weak private var btnBg: UIButton!
    
    /// Alert title label
    @IBOutlet weak private var lblTitle: UILabel!
    
    /// Title label top constraint
    @IBOutlet weak var titleTopConstraint: NSLayoutConstraint!
    
    /// Alert Description label
    @IBOutlet weak private var lblDescription: UILabel!
    
    /// Description label top Constraint
    @IBOutlet weak var descriptionTopConstraint: NSLayoutConstraint!
    
    /// Container view for external content views
    @IBOutlet weak private var containerView: UIView!
    /// Container view height constraint
    @IBOutlet weak private var containerHeightConstraint: NSLayoutConstraint!
    
    /// Alert cancel button
    @IBOutlet weak private var btnCancel: ASButton!
    
    /// Alert done button
    @IBOutlet weak private var btnYes: ASButton!
    
    /// Footer Button constraint for height
    @IBOutlet weak var footerHeightConstraints: NSLayoutConstraint!
    
    /// Container view
    lazy var tblMain: UITableView = {
        let tbl = UITableView(frame: .zero)
        tbl.backgroundColor = .clear
        tbl.dataSource = self
        tbl.delegate = self
        tbl.showsVerticalScrollIndicator = false
        tbl.showsHorizontalScrollIndicator = false
        return tbl
    }()
    //MARK:- VIEW CYCLE
    /// Do any additional setup after loading the view.
    override func viewDidLoad() {
        super.viewDidLoad()
        ///
        ///
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        ///
        setup()
        ///
        ///
        containerSetup()
    }
    
    deinit {
        print("DE-INIT ASAlertPopUP")
    }
    
    /// Setup
    func setup() {
        /// Title & Message setup
        lblTitle.text = strTitle
        lblDescription.text = strMessage
        ///
        /// Title & Message layout
        if strTitle.isEmpty == true {
            titleTopConstraint.constant = 0
            lblTitle.layoutIfNeeded()
        }
        if strMessage.isEmpty == true {
            descriptionTopConstraint.constant = 0
            lblDescription.layoutIfNeeded()
        }
        
        ///
        /// Cancel button setup
        if buttonCancelTitle == nil || buttonCancelTitle?.isEmpty == true {
            btnCancel.isHidden = true
        } else {
            btnCancel.isHidden = false
        }
        btnCancel.setTitle(buttonCancelTitle, for: .normal)
        ///
        /// Done button Setup
        if buttonDoneTitle == nil || buttonDoneTitle?.isEmpty == true {
            btnYes.isHidden = true
        } else {
            btnYes.isHidden = false
        }
        btnYes.setTitle(buttonDoneTitle, for: .normal)
        if buttonCancelTitle == nil && buttonDoneTitle == nil {
            footerHeightConstraints.constant = 0
        } else {
            footerHeightConstraints.constant = 40
        }
        
    }
    
    
    
    /// Container view setup
    func containerSetup() {
        ///
        /// Container view setup
        containerView.addSubview(tblMain)
        tblMain.anchorAllEdgesToSuperview()
        
        if config.containerHeight > (Screen.height - 200) {
            containerHeightConstraint.constant = config.containerHeight - 200
        } else {
            containerHeightConstraint.constant = config.containerHeight
        }
        
        containerView.layoutIfNeeded()
        containerView.layer.masksToBounds = true
        
//        if let externalView = config.containerView {
//            containerView.addSubview(externalView)
//            containerView.layer.masksToBounds = true
//            if config.applyAutoLayout == true {
//                externalView.anchorAllEdgesToSuperview()
//            }
//        }
    }
    
    //MARK:- ACTIONS
    /// Cancel button action
    @IBAction func actCancel(_ sender: UIButton) {
        removePopUP()
        onSelection?(false)
    }
    
    /// Yes button action
    @IBAction func actYes(_ sender: UIButton) {
        onSelection?(true)
    }
    
    /// Dissmiss on touch button action
    @IBAction func actDismissOnTouch(_ sender: UIButton) {
        if config.dismissOnTouch == false {
            return
        }
        removePopUP()
    }
    
    //MARK:- NAVIGATION
    
    /// Remove pop up
    func removePopUP() {
        dismiss(animated: true, completion: nil)
    }
}


//MARK:- UITableViewDataSource
extension ASAlertPopUP: UITableViewDataSource {
    
    /// Number Of Rows In Section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    /// Cell For Row At indexPath
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell()
    }
}

//MARK:- ASMoreVC
extension ASAlertPopUP: UITableViewDelegate {
    /// Height For Row At indexPath
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return config.containerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return config.containerHeight
    }
    
    /// Footer Height
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    
    /// Footer View
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}
