//
//  AddRecipeViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 6/18/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

protocol AddRecipeDelegate {
    func showPicker()
}

class AddRecipeViewController: UIViewController {
    
    // MARK: - Outlet -
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties -
    private lazy var mediaPicker: ImagePickerService = {
        self.mediaPicker = ImagePickerService()
        configureMediaPicker()
        return self.mediaPicker
    }()
    
    // MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    // MARK: - Action -
    @IBAction func backClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Private -
    private func setupTableView() {
        tableView.register(type: AddRecipeTableViewCell.self)
    }
    
    private func configureMediaPicker() {
        mediaPicker.targetVC = self
        mediaPicker.onImageSelected = { [weak self] image in
            guard let strongSelf = self else { return }
            if let cell = strongSelf.tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? AddRecipeTableViewCell {
                cell.fillSelectedImage(image)
            }
        }
    }
}

extension AddRecipeViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddRecipeTableViewCell") as? AddRecipeTableViewCell else { fatalError() }
        cell.fillCell(indexCell: indexPath, delegate: self)
//        if filteredProducts.indices.contains(indexPath.row) {
//            cell.fillCell(info: filteredProducts[indexPath.row])
//        }
        return cell
    }
}

extension AddRecipeViewController: AddRecipeDelegate {
    
    func showPicker() {
        mediaPicker.showPickAttachment()
    }
}
