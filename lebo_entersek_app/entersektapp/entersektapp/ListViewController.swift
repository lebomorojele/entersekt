//
//  ListViewController.swift
//  entersektapp
//
//  Created by Lebo Morojele on 2019/09/22.
//  Copyright © 2019 Lebo Morojele. All rights reserved.
//

import UIKit
import entersektsdk

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var kCellIdentifier:String = "ListItemCell"
    var listItems:[ListItemDescription]
    var barTitle:String
    @IBOutlet weak var tableView: UITableView!
    
    
    init(title:String, listItems:[ListItemDescription]){
        self.listItems = listItems
        self.barTitle = title
        super.init(nibName: "ListViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.backgroundColor = .black
        navigationItem.title = barTitle
        navigationController?.navigationBar.prefersLargeTitles = true // Navigation bar large titles
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        navigationController?.navigationBar.barTintColor = .black
        
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(UINib(nibName: kCellIdentifier, bundle: nil), forCellReuseIdentifier: kCellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func showItems(title:String, items:[ListItemDescription]){
        let vc = ListViewController(title: title, listItems: items)
        self.navigationController?.show(vc, sender: self)
    }
    
    // MARK: - Table View Delegate/Datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCellIdentifier, for: indexPath) as! ListItemCell
        let item = listItems[indexPath.row]
        cell.label.text = item.name
        cell.accessoryType = item.items() == nil ? .none : .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let items = listItems[indexPath.row].items() else {return}
        
        if listItems.first is City{
            let alert = UIAlertController(title: nil, message: "Would you like to see a list of malls or a list of shops?", preferredStyle: .actionSheet)
            alert.addAction(.init(title: "Malls", style: .default, handler: { [weak self] (alert) in
                self?.showItems(title: items.title, items: items.items)
            }))
            alert.addAction(.init(title: "Shops", style: .default, handler: { [weak self] (alert) in
                let malls = items.items.compactMap{$0.items()}
                let shops = malls.compactMap{$0.items}.flatMap{$0}
                self?.showItems(title: "Shops", items: shops)
            }))
            alert.addAction(.init(title: "Cancel", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }else{
            self.showItems(title: items.title, items: items.items)
        }
    }

}
