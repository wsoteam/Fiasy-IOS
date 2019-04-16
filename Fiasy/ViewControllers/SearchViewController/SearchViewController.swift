//
//  SearchViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 4/16/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource  {
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 22
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 400.0;//Choose your custom row height
    }
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
    //    let cell:SearchCell = tableView.dequeueReusableCell(withIdentifier: "SearchCell") as! SearchCell!
        
        let cell : SearchCell = self.tableView.dequeueReusableCell(withIdentifier: "SearchCell") as! SearchCell
         cell.selectionStyle = .none
      
        
      
        return cell
    }
    
    @IBOutlet weak var tableView: UITableView!
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(SearchCell.self, forCellReuseIdentifier: "SearchCell")
        tableView.delegate = self
        tableView.dataSource = self

    }
    
    @IBAction func showAr(_ sender: Any) {
        
        if let viewController = UIStoryboard(name: "TestArStoryboard", bundle: nil).instantiateViewController(withIdentifier: "TestViewController") as? TestViewController {
            
            
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
        
    }
}
