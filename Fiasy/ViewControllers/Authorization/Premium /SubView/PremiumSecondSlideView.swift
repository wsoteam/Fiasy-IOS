//
//  PremiumSecondSlideView.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 10/17/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class PremiumSecondSlideView: UIView {

    // MARK: - Outlet -
    @IBOutlet weak var commentImageView: UIImageView!
    
    // MARK: - Interface -
    func fillView(index: Int, state: PremiumColorState) {
        if let appLanguage = StorageService.get(by: .APP_LANGUAGE) as? String {
            switch appLanguage {
            case "en":
                switch index {
                case 0:
                    commentImageView.image = state == .black ? #imageLiteral(resourceName: "#1 eng_Black") : #imageLiteral(resourceName: "#1 eng")
                case 1:
                    commentImageView.image = state == .black ? #imageLiteral(resourceName: "#2 eng_Black") : #imageLiteral(resourceName: "#2 eng")
                case 2:
                    commentImageView.image = state == .black ? #imageLiteral(resourceName: "#3 eng_Black") : #imageLiteral(resourceName: "#3 eng")
                default:
                    break
                }
            case "de":
                switch index {
                case 0:
                    commentImageView.image = state == .black ? #imageLiteral(resourceName: "#1 нем_Black") : #imageLiteral(resourceName: "#1 нем")
                case 1:
                    commentImageView.image = state == .black ? #imageLiteral(resourceName: "#2 нем_Black") : #imageLiteral(resourceName: "#2 нем")
                case 2:
                    commentImageView.image = state == .black ? #imageLiteral(resourceName: "#3 нем_Black") : #imageLiteral(resourceName: "#3 нем")
                default:
                    break
                }
            case "pt":
                switch index {
                case 0:
                    commentImageView.image = state == .black ? #imageLiteral(resourceName: "#1 порт_Black") : #imageLiteral(resourceName: "#1 порт")
                case 1:
                    commentImageView.image = state == .black ? #imageLiteral(resourceName: "#2 порт_Black") : #imageLiteral(resourceName: "#2 порт")
                case 2:
                    commentImageView.image = state == .black ? #imageLiteral(resourceName: "#3 порт_Black") : #imageLiteral(resourceName: "#3 порт")
                default:
                    break
                }
            case "es":
                switch index {
                case 0:
                    commentImageView.image = state == .black ? #imageLiteral(resourceName: "#1 исп_Black") : #imageLiteral(resourceName: "#1 исп")
                case 1:
                    commentImageView.image = state == .black ? #imageLiteral(resourceName: "#2 исп_Black") : #imageLiteral(resourceName: "#2 исп")
                case 2:
                    commentImageView.image = state == .black ? #imageLiteral(resourceName: "#3 исп_Black") : #imageLiteral(resourceName: "#3 исп")
                default:
                    break
                }
            default:
                switch index {
                case 0:
                    commentImageView.image = state == .black ? #imageLiteral(resourceName: "#1 rus_Black") : #imageLiteral(resourceName: "#1 rus")
                case 1:
                    commentImageView.image = state == .black ? #imageLiteral(resourceName: "#2 rus_Black") : #imageLiteral(resourceName: "#2 rus")
                case 2:
                    commentImageView.image = state == .black ? #imageLiteral(resourceName: "#3 rus_Black") : #imageLiteral(resourceName: "#3 rus")
                default:
                    break
                }
            }
        }
    }
}
