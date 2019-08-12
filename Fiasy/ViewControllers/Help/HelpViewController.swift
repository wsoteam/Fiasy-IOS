//
//  HelpViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 8/6/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController {
    
    // MARK: - Outlet -
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Properties -
    private var models: [HelpModel] = []
    private var filteredModels: [HelpModel] = []
    override internal var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    //MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInitialState()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configurationKeyboardNotification()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        removeObserver()
    }
    
    // MARK: - Private -
    private func setupTableView() {
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        tableView.register(type: HelpTableViewCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
    }
    
    private func setupInitialState() {
        for index in 0...6 {
            var model = HelpModel()
            switch index {
            case 0:
                model.questionTitle = "Как получить доступ к Premium функциям?"
                model.message = "Что бы оформить Premium достаточно зайти в любой раздел, который недоступный для пользователей без премиальной подписки, и оформить подписку на него. В начале можно оформить пробную подписку на 3 дня, что бы посмотреть все функции."
            case 1:
                model.questionTitle = "Что такое Premium аккаунт?"
                model.message = "Premium аккаунт - это пользовательский профиль с расширенным, премиальным функционалом. В таком аккаунте доступно большее количество планов питания, полезных статей, тренировок и т.д."
            case 2:
                model.questionTitle = "Как редактировать свои данные?"
                model.message = "Для редактирования пользовательских данных необходимо зайти во вкладку 'Профиль'. Затем нажать на пиктограмму 'Настроить свои параметры' или на значок карандаша возле фото профиля."
            case 3:
                model.questionTitle = "Что такое статьи?"
                model.message = "В этом разделе вы найдете полезные статьи о правильном питании, тренировках, ЗОЖ, а также мотивационные статьи и не только. Статьи регулярно обновляются. Также есть строка для быстрого поиска нужной статьи."
            case 4:
                model.questionTitle = "Что такое рецепты?"
                model.message = "В  этом разделе вы сможете найти бесконечное количество полезных блюд, которые можете приготовить в домашних условиях. Все они разделены по приемам пищи: завтрак, обед, ужин, перекус. В верхней части есть поисковая строка, которая поможет вам быстро найти то или иное блюдо."
            case 5:
                model.questionTitle = "Как добавить продукт в дневник питания?"
                model.message = "Все очень просто. Сначала нажимаем значок '+' внизу справа в дневнике питания. Затем выбираем время приема пищи. Вводим название продукта, например, 'колбаса' в поле для поиска. Из списка предложенных продуктов выбираем нужный. В завершении  указываем порцию продукта и  жмем 'Добавить'. Готово"
            case 6:
                model.questionTitle = "Что такое дневник питания?"
                model.message = "Дневник питания - это дневник, в котором мы ежедневно фиксируем абсолютно всю информацию о съеденных продуктах по таким критериям:\n\n  •  что вы съели и в каком количестве (вплоть до грамм), чем перекусывали на ходу; \n  •  всё, что вы выпили (воду отдельно) \n  •  в какое время был прием пищи. \n\nДневник автоматически произведет пересчет употребленных продуктов в калории, белки, жиры и углеводы (КБЖУ)."
            default:
                break
            }
            models.append(model)
            filteredModels.append(model)
        }
    }
    
    private func isContains(pattern: String, in text: String?) -> Bool {
        guard let text = text else { return false }
        let lowcasePattern = pattern.lowercased()
        let lowcaseText = text.lowercased()
        
        let fullNameArr = lowcasePattern.split{$0 == " "}.map(String.init)
        var states: [Bool] = []
        for item in fullNameArr {
            states.append(lowcaseText.contains(item))
        }
        return states.contains(true)
    }
    
    //MARK: - Actions -
    @IBAction func backClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func searchItems(_ sender: UITextField) {
        guard let text = sender.text else { return }
        if text.isEmpty {
            filteredModels = models
        } else {
            filteredModels.removeAll()
            for item in models where self.isContains(pattern: text, in: item.questionTitle) {
                filteredModels.append(item)
            }
        }
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? QuestionViewController, let indexPath = sender as? IndexPath, (segue.identifier == "sequeQuestionScreen") {
            vc.questionTitle = filteredModels[indexPath.row].questionTitle
            vc.message = filteredModels[indexPath.row].message
        }
    }
}

extension HelpViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HelpTableViewCell") as? HelpTableViewCell else { fatalError() }
        cell.fillCell(model: filteredModels[indexPath.row], isLastCell: filteredModels.indices.contains(indexPath.row + 1))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "sequeQuestionScreen", sender: indexPath)
    }
}

extension HelpViewController {
    
    @objc override func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.tableBottomConstraint.constant = keyboardHeight - (tabBarController?.tabBar.frame.height ?? 49.0)
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc override func keyboardWillHide(notification: NSNotification) {
        self.tableBottomConstraint.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}
