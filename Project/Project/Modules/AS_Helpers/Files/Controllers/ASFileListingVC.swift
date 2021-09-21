//
//  ASFileListingVC.swift
//  ABBC
//
//  Created by Mr. X on 12/05/21.
//

import UIKit
import SKPhotoBrowser

class ASFileListingVC: ASBaseVC {
    enum ScreenInsertType {
        case push
        case present
    }
    
    /// Insertion type of screen
    var screenInsertType: ScreenInsertType = .push
    
    /// File array
    var arrFiles: [ASMediaFile] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    //MARK:- LAZY
    
    /// Collection view for tiles
    lazy private var collectionView: UICollectionView = {
        let col = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        col.showsVerticalScrollIndicator = false
        col.showsHorizontalScrollIndicator = false
        col.dataSource = self
        col.delegate = self
        col.backgroundColor = .clear
        return col
    }()
    
    /// Flow layout for tiles
    lazy private var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 2.5
        layout.minimumInteritemSpacing = 0.5
        layout.scrollDirection = .vertical
        return layout
    }()
    
    //MARK:- VIEW-CYCLE
    
    /// Do any additional setup after loading the view.
    override func viewDidLoad() {
        super.viewDidLoad()
        ///
        /// NAV BAR
        ///
        navBar(withTitle: "Files", navigationItem: self.tabBarController?.navigationItem)
        navBarButtons(left: #imageLiteral(resourceName: "nav_back"), right: nil, shouldBack: false)
        ///
        setupUI()
        ///
        resetFileType()
    }
    
    /// Notifies the view controller that its view is about to be added to a view hierarchy.
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    
    deinit {
        print("De-INIT ASFileListingVC")
    }
    
    //MARK:- SETUP UI
    
    /// Setup UI
    private func setupUI() {
        self.view.backgroundColor = UIColor.systemGray6
        collectionView.backgroundColor = .clear
        self.view.addSubview(collectionView)
        collectionView.anchorAllEdgesToSuperview()
        collectionView.register(UINib(nibName: "ASFileCell", bundle: nil), forCellWithReuseIdentifier: "ASFileCell")
    }
    
    /// Show no data lable in table view
    /// - Parameter msg: String
    /// - Parameter marginTop: margin from top if any
    private func showNoData(msg: String?, marginTop: CGFloat = 00.0) {
        noDataSettings(tblView: collectionView, msg: msg, rows: arrFiles.isEmpty ? 0 : 1, frame: CGRect.init(x: 10, y: marginTop, width: collectionView.frame.width - 20, height: collectionView.frame.height))
    }
    
    /// Reset the file type according to urls
    private func resetFileType() {
        for (index, item) in arrFiles.enumerated() {
            if let strUrl = item.url?.absoluteString {
                if strUrl.contains(MediaExtension.jpg.name) || strUrl.contains(MediaExtension.jpeg.name) || strUrl.contains(MediaExtension.png.name) {
                    
                    arrFiles[index].mediaType = .image
                    
                } else if strUrl.contains(MediaExtension.pdf.name) {
                    arrFiles[index].mediaType = .file
                } else {
                    arrFiles[index].mediaType = .file
                }
            }
        }
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
    
    /// Left button clicked for back
    override func navLeftClicked(sender: UIButton) {
        goBackScreen()
    }
    
}
//
//MARK:- Collectionview Data Source
//
extension ASFileListingVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrFiles.count
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
        let index = indexPath.item
        let file = arrFiles[index]
        cell.loadPreview(file: file)
        
        return cell
    }
    
}
//
//MARK:- Collection view Delegates
//
extension ASFileListingVC: UICollectionViewDelegate {
    
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
        let item = arrFiles[indexPath.item]
        if item.mediaType == .image {
            guard let url = item.url?.absoluteString else { return }
            previewPhoto(urls: [url])
            
        } else {
            guard let url = item.url else { return }
            let vc = ASFilePreviewVC()
            vc.fileUrl = url
            vc.entryType = .present
            let navVC = UINavigationController(rootViewController: vc)
            self.navigationController?.present(navVC, animated: true, completion: nil)
        }
    }
    
    /// Preview photos
    private func previewPhoto(urls: [String]) {
        // 1. create SKPhoto Array from UIImage
        var images = [SKPhoto]()
        for url in urls {
            let photo = SKPhoto.photoWithImageURL(url.decoding())
            photo.shouldCachePhotoURLImage = false // you can use image cache by true(NSCache)
            images.append(photo)
        }
        let browser = SKPhotoBrowser(photos: images)
        browser.initializePageIndex(0)
        guard let topController = UIApplication.topViewController() else {
            self.present(browser, animated: true, completion: nil)
            return
        }
        topController.present(browser, animated: true, completion: {})
        
    }
}
