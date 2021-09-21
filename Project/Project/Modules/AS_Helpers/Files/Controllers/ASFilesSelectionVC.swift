//
//  ASFilesSelectionVC.swift
//  ABBC
//
//  Created by Mr. X on 28/04/21.
//

import UIKit

class ASFilesSelectionVC: ASBaseVC {
    enum ScreenInsertType {
        case push
        case present
    }
    
    /// Maximum file selection limit
    var maxSelectionLimit: Int = 10
    
    /// When Submit clicked then this callback will be returned
    var onSelection: ((_ files: [ASMediaFile]) -> Void)?
    
    /// Insertion type of screen
    var screenInsertType: ScreenInsertType = .push
    
    /// File array
    var arrFiles: [ASMediaFile] = [] {
        didSet {
            collectionView?.reloadData()
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView?
    
    //MARK:- VIEW-CYCLE
    
    /// Do any additional setup after loading the view.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ///
        setupUI()
    }
    
    /// Notifies the view controller that its view is about to be added to a view hierarchy.
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        ///
        /// NAV BAR
        ///
        navBar(withTitle: "Files", navigationItem: self.tabBarController?.navigationItem)
        navBarButtons(left: #imageLiteral(resourceName: "nav_back"), right: nil, shouldBack: false)
        btnRightMenu.setTitle("DONE", for: .normal)
    }
    
    //MARK:- SETUP UI
    
    /// Setup UI
    private func setupUI() {
        self.view.backgroundColor = UIColor.systemGray6
        collectionView?.backgroundColor = .clear
        
        collectionView?.register(UINib(nibName: "ASFileCell", bundle: nil), forCellWithReuseIdentifier: "ASFileCell")
    }
    
    /// Show no data lable in table view
    /// - Parameter msg: String
    /// - Parameter marginTop: margin from top if any
    private func showNoData(msg: String?, marginTop: CGFloat = 00.0) {
        guard let colView = collectionView else { return }
        noDataSettings(tblView: colView, msg: msg, rows: arrFiles.isEmpty ? 0 : 1, frame: CGRect.init(x: 10, y: marginTop, width: colView.frame.width - 20, height: colView.frame.height))
    }
    
    //MARK:- ACTIONS
    /// Go back to prevous screen
    private func goBackScreen() {
        if screenInsertType == .present {
            dismissVC()
        } else {
            goBack()
        }
    }
    
    /// Get files list
    /// - Returns: [ASMediaFile]
    private func getFinalFiles() -> [ASMediaFile] {
        var arrItems: [ASMediaFile] = []
        for file in arrFiles {
            if file.url == nil {
                if let item = ASFileDir.save(file: file) {
                    arrItems.append(item)
                }
            } else {
                arrItems.append(file)
            }
        }
        return arrItems
    }
    /// Left button clicked for back
    override func navLeftClicked(sender: UIButton) {
        goBackScreen()
    }
    
    /// Right button clicked
    override func navRightClicked(sender: UIButton) {
        if arrFiles.isEmpty == true {
            goBackScreen()
            return
        }
        let files = getFinalFiles()
        onSelection?(files)
        goBackScreen()
    }
    
    /// Delete button clicked
    @objc func actDeleteClicked(sender: UIButton) {
        guard let element = sender.accessibilityElements, let indPath = element.first as? IndexPath else {
            return
        }
        let index = indPath.item - 1
        if index < arrFiles.count {
            let file = arrFiles[index]
            arrFiles.remove(at: index)
            if let url = file.url {/// Delete from local directory
                ASFileDir.delete(fileUrl: url)
            }
            let files = getFinalFiles()
            onSelection?(files)
        }
    }
}
//
//MARK:- Collectionview Data Source
//
extension ASFilesSelectionVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrFiles.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width / 3) - 10
        return CGSize.init(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ASFileCell", for: indexPath) as? ASFileCell else {
            print("Cell is Nil")
            return UICollectionViewCell()
        }
        if indexPath.item == 0 {
            cell.loadAddCell()
            
        } else {
            let index = indexPath.item - 1
            let file = arrFiles[index]
            cell.load(file: file)
            
            cell.btnDelete.accessibilityElements = [indexPath]
            cell.btnDelete.addTarget(self, action: #selector(actDeleteClicked(sender:)), for: .touchUpInside)
        }
        
        return cell
    }
    
}
//
//MARK:- Collection view Delegates
//
extension ASFilesSelectionVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 1.5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.5
    }
    
    // Layout: Set Edges
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        // top, left, bottom, right
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            weak var weakSelf = self
            if arrFiles.count == maxSelectionLimit {
                ASUtility.shared.dissmissAlert(title: "", message: L10n.imgLimitReached.string, lblDone: L10n.ok.string)
                return
            }
            ASMediaPicker.showPicker { (files) in
                if files.isEmpty == false {
                    for item in files where (weakSelf?.arrFiles.count ?? 0) < (weakSelf?.maxSelectionLimit ?? 0) {
                        weakSelf?.arrFiles.append(item)
                    }
                }
            }
        }
    }
}
