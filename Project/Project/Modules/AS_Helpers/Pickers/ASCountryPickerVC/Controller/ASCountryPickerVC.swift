//
//  ASCountryPickerVC.swift
//  Anra
//
//  Created by Mr. X on 31/05/21.
//

import UIKit
import SDWebImage

/// Country Picker VC
class ASCountryPickerVC: ASBaseVC {
    /// CALLABACKS
    ///
    /// When Picker is dismissed then this callback will be returned with selected values
    var onCodePicked: ((_ name: String?, _ countryCode: String?, _ phoneCode: String?, _ flag: String?) -> Void)?
    
    /// Country List
    private var arrCountries: [ASCountry] = [] {
        didSet {
            arrFilteredCountries = arrCountries
        }
    }
    
    /// Filtered Countries List
    private var arrFilteredCountries: [ASCountry] = [] {
        didSet {
            tblMain?.reloadData()
        }
    }
    
    //MARK:- Outlet
    ///
    /// Search Bar
    @IBOutlet weak private var searchBar: UISearchBar!
    
    /// Table object
    @IBOutlet weak private var tblMain: UITableView!
    
    // MARK:- VIEW-CYCLE
    /// Do any additional setup after loading the view.
    override func viewDidLoad() {
        super.viewDidLoad()
        ///
        /// NAV BAR
        ///
        self.view.backgroundColor = UIColor.systemGray6
        tblMain.backgroundColor = .clear
        setupSearchBar()
        requestCountryList()
        
    }
    
    deinit {
        print("DE-INIT CountryPickerVC")
    }
    
    
    /// Setup Search Bar
    func setupSearchBar() {
        searchBar.barTintColor = UIColor.systemGray6
        searchBar.tintColor = UIColor.systemGray6
        
        /// Textfield setup
        ///
        searchBar.textField?.backgroundColor = .white
        searchBar.textField?.tintColor = .black
        searchBar.backgroundImage = UIImage()
        
        weak var weakSelf = self
        searchBar.delegate = weakSelf
    }
    
    //MARK:- ACTIONS
    /// Cancel pressed
    @IBAction func actCancel(_ sender: UIButton?) {
        dismiss(animated: true, completion: nil)
    }
    
}

//MARK:- UISearchBarDelegate
extension ASCountryPickerVC: UISearchBarDelegate {
    /// Search Button Clicked
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        resignKeyboard()
        searchCountry()
    }
    
    /// text changed in search bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchCountry()
    }
    
    /// Search the country for the search string
    func searchCountry() {
        let searchText = searchBar.text?.lowercased() ?? ""
        
        if searchText.isEmpty == true {
            arrFilteredCountries = arrCountries
            return
        }
        let filter = arrCountries.filter { (country) -> Bool in
            let name = country.name?.lowercased() ?? ""
            let phoneCode = country.phoneCode?.lowercased() ?? ""
            if name.contains(searchText) || phoneCode.contains(searchText) {
                return true
            }
            return false
        }
        
        arrFilteredCountries = filter
    }
}

//MARK:- LOAD COUNTRIES
extension ASCountryPickerVC {
    /// Fetch country list
    private func requestCountryList() {
        lblNoData.isHidden = true
        var countries = [ASCountry]()
        
        guard let jsonPath = Bundle.main.path(forResource: "Countries", ofType: "json"), let jsonData = try? Data(contentsOf: URL(fileURLWithPath: jsonPath)) else {
            arrCountries.removeAll()
            return
        }
        
        do {
            let jsonDecoder = JSONDecoder()
            let values = try jsonDecoder.decode([ASCountry].self, from: jsonData)
            countries = values
        } catch {
            print(error.localizedDescription)
        }
        
        arrCountries = countries
    }
}

//MARK:- UITableViewDataSource
extension ASCountryPickerVC: UITableViewDataSource {
    /// Number Of Rows In Section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        noDataSettings(tblView: tblMain, msg: "No country found", rows: arrFilteredCountries.isEmpty ? 0 : 1)
        lblNoData.textColor = .black
        
        return arrFilteredCountries.count
    }
    
    /// Cell For Row At indexPath
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DPCountryCell! = tableView.dequeueReusableCell(withIdentifier: "DPCountryCell") as? DPCountryCell
        
        let item = arrFilteredCountries[indexPath.row]
        
        cell.lblCode.text = item.phoneCode
        cell.lblName.text = item.name
        
        cell.imgVPic.image = item.flag
//        cell.imgVPic.sd_imageIndicator = SDWebImageActivityIndicator.gray
//        cell.imgVPic.sd_setImage(with: URL(string: item.flag ?? "")) { (_, _, _, _) in
//        }
        
        cell.lblName.numberOfLines = 2
        
        tableView.separatorStyle = .singleLine
        
        return cell
    }
}

//MARK:- UITableViewDelegate
extension ASCountryPickerVC: UITableViewDelegate {
    
    /// Height For Row At indexPath
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
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
        let item = arrFilteredCountries[indexPath.row]
        
        onCodePicked?(item.name, item.code, item.phoneCode, nil)
        actCancel(nil)
    }
    
}
