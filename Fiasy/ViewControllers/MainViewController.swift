//
//  MainViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 4/1/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import Parchment
import MBCircularProgressBar

class CustomPagingViewController: PagingViewController<CalendarItem> {
    
    override func loadView() {
        view = CustomPagingView(options: options, collectionView: collectionView,
                                pageView: pageViewController.view)
    }
}

class MainViewController: UIViewController {
    
    //MARK: - Properties -
    private let isIphone5 = Display.typeIsLike == .iphone5
    private let pagingViewController = CustomPagingViewController()
    
    //MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChild(pagingViewController)
        view.addSubview(pagingViewController.view)
        view.constrainToEdges(pagingViewController.view)
        pagingViewController.didMove(toParent: self)
        
        // Customize the menu styling.
        pagingViewController.menuItemSize = .fixed(width: UIScreen.main.bounds.width, height: 40.0)
        pagingViewController.font = UIFont.fontRobotoBold(size: 16.0)
        pagingViewController.selectedFont = UIFont.fontRobotoBold(size: 16.0)
        pagingViewController.selectedTextColor = .black
        pagingViewController.borderColor = .clear
        pagingViewController.indicatorColor = .clear
        pagingViewController.indicatorOptions = .hidden
        
        // Contrain the paging view to all edges.
        pagingViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pagingViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            pagingViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            pagingViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pagingViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            ])
        
        pagingViewController.delegate = self
        pagingViewController.infiniteDataSource = self
        pagingViewController.select(pagingItem: CalendarItem(date: Date()))
    }
}

extension MainViewController: PagingViewControllerInfiniteDataSource {
    
    func pagingViewController<T>(_ pagingViewController: PagingViewController<T>, viewControllerForPagingItem pagingItem: T) -> UIViewController {
        guard let viewController = UIStoryboard(name: "MainStoryboard", bundle: nil).instantiateViewController(withIdentifier: "SecondMainViewController") as? SecondMainViewController else {
            return UIViewController()
        }
        let _ = viewController.view
        let height = pagingViewController.options.menuHeight + CustomPagingView.getHeaderHeight()
        let insets = UIEdgeInsets(top: height, left: 0, bottom: 0, right: 0)
        viewController.tableView.contentInset = insets
        viewController.tableView.scrollIndicatorInsets = insets
        viewController.tableView.delegate = self
        let calendarItem = pagingItem as! CalendarItem
        if let cell = pagingViewController.collectionView.visibleCells.first as? PagingTitleCell {
            cell.titleLabel.textAlignment = .center
            cell.titleLabel.text = DateFormatters.shortDateFormatter.string(from: calendarItem.date)
            cell.titleLabel.font = UIFont.fontRobotoBold(size: 22.0)
        }
        return viewController
    }
    
    func pagingViewController<T>(_ pagingViewController: PagingViewController<T>, pagingItemBeforePagingItem pagingItem: T) -> T? {
        let calendarItem = pagingItem as! CalendarItem
        return CalendarItem(date: calendarItem.date.addingTimeInterval(-86400)) as? T
    }
    
    func pagingViewController<T>(_ pagingViewController: PagingViewController<T>, pagingItemAfterPagingItem pagingItem: T) -> T? {
        let calendarItem = pagingItem as! CalendarItem
        return CalendarItem(date: calendarItem.date.addingTimeInterval(86400)) as? T
    }
}

extension MainViewController: PagingViewControllerDelegate {
    
    func pagingViewController<T>(_ pagingViewController: PagingViewController<T>, didScrollToItem pagingItem: T, startingViewController: UIViewController?, destinationViewController: UIViewController, transitionSuccessful: Bool) {
        guard let startingViewController = startingViewController as? SecondMainViewController else { return }
        guard let destinationViewController = destinationViewController as? SecondMainViewController else { return }
        
        if transitionSuccessful {
            startingViewController.tableView.delegate = nil
            destinationViewController.tableView.delegate = self
        }
    }
    
    func pagingViewController<T>(_ pagingViewController: PagingViewController<T>, willScrollToItem pagingItem: T, startingViewController: UIViewController, destinationViewController: UIViewController) {
        guard let destinationViewController = destinationViewController as? SecondMainViewController else { return }
        
        if let pagingView = pagingViewController.view as? CustomPagingView {
            if let headerHeight = pagingView.headerHeightConstraint?.constant {
                let offset = headerHeight + pagingViewController.options.menuHeight
                destinationViewController.tableView.contentOffset = CGPoint(x: 0, y: -offset)
            }
        }
    }
}

extension MainViewController: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.contentOffset.y < 0 else { return }
        if let menuView = pagingViewController.view as? CustomPagingView {
            let height = max(0, abs(scrollView.contentOffset.y) - pagingViewController.options.menuHeight)
            menuView.headerHeightConstraint?.constant = height
        }
    }
}
