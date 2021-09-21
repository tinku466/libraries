//
//  ASHomeVC.swift
//  Project
//
//  Created by Ankit Saini on 21/09/21.
//

import UIKit

class ASHomeVC: ASBaseVC {
    
    /// List of all data
    private var arrData: [String] = ["Group & Chat", "Custom PopUp", "File Picker", "File Listing"]
    
    //MARK:- OUTLETS
    /// List view
    lazy var tblMain: UITableView = {
        let tbl = UITableView()
        tbl.backgroundColor = .clear
        tbl.dataSource = self
        tbl.delegate = self
        return tbl
    }()
    
    //MARK:- VIEW-CYCLE
    
    /// Do any additional setup after loading the view.
    override func viewDidLoad() {
        super.viewDidLoad()
        ///
        setupMenu()
        ///
        setupUI()
    }
    
    /// Notifies the view controller that its view is about to be added to a view hierarchy.
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        ///
        /// NAV BAR
        ///
        setupMenu()
    }
    
    //MARK:- SETUP UI
    /// Setup Menu bar
    private func setupMenu() {
        navBar(withTitle: "HOME", navigationItem: self.tabBarController?.navigationItem)
        navBarButtons(left: #imageLiteral(resourceName: "nav_back"), right: nil, shouldBack: true, navigationItem: self.tabBarController?.navigationItem)
    }
    
    /// Setup UI
    private func setupUI() {
        self.view.backgroundColor = UIColor.systemGray6
        self.view.addSubview(tblMain)
        tblMain.anchorAllEdgesToSuperview()
        
    }
    
    //MARK:- ACTIONS
    
}

//MARK:- UITableViewDataSource
extension ASHomeVC: UITableViewDataSource {
    /// Cell For Row At indexPath
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
        
        cell.detailTextLabel?.text = nil
        
        let item = arrData[indexPath.row]
        cell.textLabel?.text = item
        cell.textLabel?.textColor = .black
        cell.textLabel?.font = Font(.systemWeighted(weight: .regular), size: .standard(.h3)).instance
        
        cell.backgroundColor = .white
//        cell.selectionStyle = .none
        tableView.separatorStyle = .singleLine
        
        return cell
        
    }
    
    /// Number of sections in tableview
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /// Number Of Rows In Section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrData.count
    }
}

//MARK:- ASMoreVC
extension ASHomeVC: UITableViewDelegate {
    
    /// Height For Row At indexPath
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    /// Footer Height
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    
    /// Footer View
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    /// Did Select Row At indexPath
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {//["Group & Chat", "Custom PopUp", "File Picker", "File Listing"]
        case 0:
            guard let vc = Storyboard.chat.viewController(viewControllerClass: CBMessageListVC.self) else {return}
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            showCustomPopUp()
        case 2:
            showFilePicker()
        case 3:
            showFileListing()
        default:
            return
        }
    }
    
    /// Custom PopUP
    private func showCustomPopUp() {
        let datePicker = UIDatePicker()
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        datePicker.datePickerMode = .dateAndTime
        datePicker.maximumDate = Date()
        
        let config = ASAlertConfiguration.init(containerHeight: 250, applyAutoLayout: true, containerView: datePicker)
        kAppDelegate.showCustomAlert(title: "Title", message: "This is the message", doneTitle: "SUBMIT", config: config) { (choice, vc) in
            vc?.dismiss(animated: true, completion: nil)
        }
    }
    
    /// FilePicker
    private func showFilePicker() {
        ASMediaPicker.showPicker(selection: 4) { (_) in
        }
    }
    
    /// File Listing
    private func showFileListing() {
        let files = ["https://placehold.jp/150x150.png", "https://placehold.jp/150x150.png"]
        var arrFiles: [ASMediaFile] = []
        for url in files {
            var file = ASMediaFile.init(mediaType: .file, fileLocation: .web)
            file.title = ""
            file.url = URL.init(string: url)
            arrFiles.append(file)
        }
        if arrFiles.isEmpty == false {
            let vc = ASFileListingVC()
            vc.arrFiles = arrFiles
            self.navigationController?.pushViewController(vc)
        }
    }
}
