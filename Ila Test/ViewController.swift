//
//  ViewController.swift
//  Ila Test
//
//  Created by Muhammad Saad on 07/01/2024.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate,  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout ,  UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {

    @IBOutlet weak var containerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pagerView: UIPageControl!
    @IBOutlet weak var searchViewBG: UIView!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    
    var arr1 : [String]?
    var visible_data_arr : [String]?
    var filter_data : [String]?
    var data_obj : [[String]]?
    var searchViewInitialY : CGFloat!
    var scrollXPosition : CGFloat!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchField.delegate = self
        scrollView.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        tableView.dataSource = self
        tableView.delegate = self
        
        searchViewInitialY = self.searchViewBG.frame.origin.y
        scrollXPosition = self.scrollView.contentOffset.x
        
        let nibName = UINib(nibName: "TopImageCarouselCollectionViewCell", bundle: nil)
        collectionView.register(nibName, forCellWithReuseIdentifier: "carouselCell")
        
        
        let nibName2 = UINib(nibName: "ListItemTableViewCell", bundle: nil)
        tableView.register(nibName2, forCellReuseIdentifier: "listCell")
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.separatorStyle = .none
        let insets = UIEdgeInsets(top: 10, left: 0, bottom: 20, right: 0)
        self.tableView.contentInset = insets
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissMyKeyboard))
        
        view.addGestureRecognizer(tap)
        
        self.searchField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        
        setupView()
        loadData()
    }
    
    @objc func dismissMyKeyboard(){
        view.endEditing(true)
    }
    
    
    @objc func textFieldDidChange(textField: UITextField){
        
        if searchField.text != "" {
            searchInArray(str: searchField.text ?? "")
        }
        
        tableView.reloadData()
    }
    
    func setupView(){
        collectionView.backgroundColor = UIColor.clear
        tableView.backgroundColor = UIColor.clear
        tableView.isScrollEnabled = false
        searchField.attributedPlaceholder = NSAttributedString(string: "Search", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
    }
    
    func loadData(){
        filter_data = []
        arr1 = ["img_0","img_1","img_2",]
        data_obj = [
                    ["Aaron-James", "Aarron", "Aaryan", "Aaryn", "Aayan", "Aazaan", "Abaan", "Abbas", "Abdallah", "Abdalroof", "Abdihakim", "Abdirahman", "Abdisalam", "Abdul", "Abdul-Aziz", "Abdulbasir",],
                    ["Aberdeen", "Abilene", "Akron", "Albany", "Albuquerque", "Alexandria", "Allentown", "Amarillo", "Anaheim", "Anchorage", "Ann Arbor", "Antioch", "Apple Valley", "Appleton", "Arlington", "Arvada", "Asheville", "Athens", "Atlanta", "Atlantic City", "Augusta", "Aurora", "Austin", "Bakersfield", "Baltimore", "Barnstable", "Baton Rouge", "Beaumont", "Bel Air", "Bellevue", "Berkeley", "Bethlehem", "Billings", "Birmingham", "Bloomington", "Boise", "Boise City", "Bonita Springs", "Boston", "Boulder", "Bradenton", "Bremerton", "Bridgeport", "Brighton", "Brownsville", "Bryan", "Buffalo"],
                    ["Cameroon", "Canada", "Cape Verde", "Cayman Islands", "Central African Republic", "Chad", "Chile", "China", "Christmas Island", "Cocos (Keeling) Islands", "Colombia", "Comoros", "Congo"],
        ]
        visible_data_arr = data_obj?[0] ?? []
        pagerView.numberOfPages = arr1?.count ?? 0
        pagerView.currentPage = 0
        pagerView.addTarget(self, action: #selector(pageControlHandle), for: .allEvents)
        
    
        updateHeight()
    }
    
    @objc private func pageControlHandle(sender: UIPageControl){
        let index = sender.currentPage
        pagerView.currentPage = index
        let indexPath = IndexPath(item: index, section: 0)
        
        collectionView.scrollToItem(at: indexPath, at: .right, animated: true)
        
        performPageChange(index: index)
    }
   
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(scrollView.contentOffset.x != scrollXPosition && scrollView.contentOffset.x != 0) {
            scrollXPosition =  scrollView.contentOffset.x
            
            let pageIndex = round(scrollView.contentOffset.x / self.collectionView.frame.width)
            let index = Int(pageIndex)
            self.pagerView.currentPage = index
            performPageChange(index: index)
        }
    
    
        var topFrame = searchViewBG.frame
        topFrame.origin.y = CGFloat(max(searchViewInitialY, scrollView.contentOffset.y))
        searchViewBG.frame = topFrame
    }
    
    func updateHeight(){
        containerHeightConstraint.constant = CGFloat(320 + (55 * (visible_data_arr?.count ?? 0)))
    }
    
    func performPageChange(index: Int){
        visible_data_arr = data_obj?[index] ?? []
        if searchField.text != "" {
            searchInArray(str: searchField.text ?? "")
        }
        updateHeight()
        tableView.reloadData()
    }
    
 
    func searchInArray (str: String){
        filter_data?.removeAll()
        filter_data = visible_data_arr?.filter({$0.lowercased().contains(str.lowercased())})
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arr1?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "carouselCell", for: indexPath) as! TopImageCarouselCollectionViewCell
        cell.cellImage.image = UIImage(named: arr1![indexPath.row])
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.collectionView.frame.width , height: self.collectionView.frame.height)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchField.text != "" {
            return filter_data?.count ?? 0
        }else{
            return visible_data_arr?.count ?? 0
        }
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as! ListItemTableViewCell
        
        if searchField.text != "" {
            cell.cellLabel.text = filter_data?[indexPath.row] ?? ""
        }else{
            cell.cellLabel.text = visible_data_arr![indexPath.row]
        }
        
        cell.cellLabel.textColor = UIColor.white
        cell.cellImage.layer.cornerRadius = cell.cellImage.frame.height / 2
        
        cell.selectionStyle = .none
        return cell
    }
    
    
}

