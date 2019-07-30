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
    func switchChangeValue(state: Bool)
    func textChange(tag: Int, text: String?)
}

class AddRecipeViewController: UIViewController {
    
    // MARK: - Outlet -
    @IBOutlet weak var bottomNextButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Properties -
    private var selectedRecipe: Listrecipe?
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        hideKeyboardWhenTappedAround()
        configurationKeyboardNotification()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        removeObserver()
    }
    
    // MARK: - Action -
    @IBAction func backClicked(_ sender: Any) {
        let refreshAlert = UIAlertController(title: "Хотите выйти без сохранения?", message: "", preferredStyle: UIAlertController.Style.alert)
        refreshAlert.addAction(UIAlertAction(title: "Да", style: .default, handler: { [weak self] (action: UIAlertAction!) in
            guard let strongSelf = self else { return }
            strongSelf.navigationController?.popViewController(animated: true)
        }))
        refreshAlert.addAction(UIAlertAction(title: "Нет", style: .default, handler: nil))
        present(refreshAlert, animated: true)
    }
    
    @IBAction func nextStepClicked(_ sender: Any) {
        guard let recipeName = UserInfo.sharedInstance.recipeFlow.recipeName, !recipeName.isEmpty else {
            AlertComponent.sharedInctance.showSecondAlertMessage(message: "Введите название рецепта", vc: self) {
                if let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? AddRecipeTableViewCell {
                    cell.nameTextField.becomeFirstResponder()
                }
            }
            return
        }
        if recipeName.replacingOccurrences(of: " ", with: "").isEmpty {
            AlertComponent.sharedInctance.showSecondAlertMessage(message: "Название не может состоять только из пробелов", vc: self) {
                if let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? AddRecipeTableViewCell {
                    cell.nameTextField.becomeFirstResponder()
                }
            }
            return
        }
        guard let time = UserInfo.sharedInstance.recipeFlow.time, !time.isEmpty else {
            AlertComponent.sharedInctance.showSecondAlertMessage(message: "Введите время приготовления (мин)", vc: self) {
                if let cell = self.tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? AddRecipeTableViewCell {
                    cell.nameTextField.becomeFirstResponder()
                }
            }
            return
        }
        if let count = Int(time), count == 0 {
            AlertComponent.sharedInctance.showSecondAlertMessage(message: "Время не может состоять из нулей", vc: self) {
                if let cell = self.tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? AddRecipeTableViewCell {
                    cell.nameTextField.becomeFirstResponder()
                }
            }
            return
        }
        
        guard let complexity = UserInfo.sharedInstance.recipeFlow.complexity, !complexity.isEmpty else {
            AlertComponent.sharedInctance.showSecondAlertMessage(message: "Выберите сложность приготовления", vc: self) {
                if let cell = self.tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? AddRecipeTableViewCell {
                    cell.dropDown.show()
                }
            }
            return
        }
        performSegue(withIdentifier: "sequeAddIngredientsScreen", sender: nil)
    }
    
    func fillEditRecipe(recipe: Listrecipe) {
        UserInfo.sharedInstance.recipeFlow = AddRecipeFlow()
        self.selectedRecipe = recipe
        
        UserInfo.sharedInstance.recipeFlow.recipe = recipe
        UserInfo.sharedInstance.recipeFlow.recipeName = recipe.name
        UserInfo.sharedInstance.recipeFlow.time = "\(recipe.time ?? 0)"
        UserInfo.sharedInstance.recipeFlow.complexity = recipe.complexity
        
        UserInfo.sharedInstance.recipeFlow.allProduct = recipe.selectedProduct
        UserInfo.sharedInstance.recipeFlow.instructionsList = recipe.instruction ?? []
    }
    
    // MARK: - Private -
    private func setupTableView() {
        tableView.register(type: AddRecipeTableViewCell.self)
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
    }
    
    private func configureMediaPicker() {
        mediaPicker.targetVC = self
        mediaPicker.onImageSelected = { [weak self] image in
            guard let strongSelf = self else { return }
            if let cell = strongSelf.tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? AddRecipeTableViewCell {
                cell.fillSelectedImage(image)
                UserInfo.sharedInstance.recipeFlow.recipeImage = image
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
        cell.fillCell(indexCell: indexPath, delegate: self, UserInfo.sharedInstance.recipeFlow.recipeImage, selectedRecipe)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50.0
    }
}

extension AddRecipeViewController: AddRecipeDelegate {
    
    func switchChangeValue(state: Bool) {
        UserInfo.sharedInstance.recipeFlow.showAll = state
    }
    
    func textChange(tag: Int, text: String?) {
        switch tag {
        case 0:
            UserInfo.sharedInstance.recipeFlow.recipeName = text
        case 2:
            UserInfo.sharedInstance.recipeFlow.time = text
        case 3:
            UserInfo.sharedInstance.recipeFlow.complexity = text
        default:
            break
        }
    }
    
    func showPicker() {
        mediaPicker.showPickAttachment()
    }
}
