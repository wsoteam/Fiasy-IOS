//
//  RecipeCollectionViewCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 11/26/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import Kingfisher
import Alamofire
import VisualEffectView

class RecipeCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlet's -
    @IBOutlet weak var clickedButton: UIButton!
    @IBOutlet weak var unitTitleLabel: UILabel!
    @IBOutlet weak var premiumTitleLabel: UILabel!
    @IBOutlet weak var caloriesButton: UIButton!
    @IBOutlet weak var premiumContainerView: UIView!
    @IBOutlet weak var blurView: VisualEffectView!
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var alphaView: UIView!
    
    // MARK: - Properties -
    private var recipe: SecondRecipe?
    
    // MARK: - Life Cicle -
    override func awakeFromNib() {
        super.awakeFromNib()
        
        blurView.colorTint = .gray
        blurView.colorTintAlpha = 0.1
        blurView.blurRadius = 5
        blurView.scale = 1
        
        premiumContainerView.clipsToBounds = true
        premiumContainerView.layer.cornerRadius = 8
        premiumContainerView.layer.maskedCorners = [.layerMinXMaxYCorner]
        premiumTitleLabel.text = LS(key: .PREMIUM_TITLE)
        unitTitleLabel.text = LS(key: .CALORIES_UNIT)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        articleImageView.image = nil
    }
    
    // MARK: - Interface -
    func fillRow(recipe: SecondRecipe) {
        self.recipe = recipe
        
        if let calor = recipe.calories {
            caloriesButton.setTitle(" \(calor)", for: .normal)
        }
        nameLabel.text = recipe.recipeName
        if let path = recipe.imageUrl, let url = try? path.asURL() {
            articleImageView.kf.indicatorType = .activity
            let resource = ImageResource(downloadURL: url)
            KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
                switch result {
                case .success(let value):
                    self.articleImageView.image = value.image
                    self.alphaView.backgroundColor = self.getPixelColor(value.image, CGPoint(x: 2, y: 2))
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        }
    }
    
    @IBAction func buttonClicked(_ sender: Any) {
        guard let recipe = self.recipe else { return }
        if let vc = UIApplication.getTopMostViewController() as? NutritionDetailsViewController {
            vc.performSegue(withIdentifier: "sequeArticleDetailsScreen", sender: recipe)
        }
    }
    
    // MARK: - Private -
    private func getPixelColor(_ image: UIImage, _ point: CGPoint) -> UIColor {
        let cgImage : CGImage = image.cgImage!
        guard let pixelData = CGDataProvider(data: (cgImage.dataProvider?.data)!)?.data else {
            return UIColor.clear
        }
        let data = CFDataGetBytePtr(pixelData)!
        let x = Int(point.x)
        let y = Int(point.y)
        let index = Int(image.size.width) * y + x
        let expectedLengthA = Int(image.size.width * image.size.height)
        let expectedLengthGrayScale = 2 * expectedLengthA
        let expectedLengthRGB = 3 * expectedLengthA
        let expectedLengthRGBA = 4 * expectedLengthA
        let numBytes = CFDataGetLength(pixelData)
        switch numBytes {
        case expectedLengthA:
            return UIColor(red: 0, green: 0, blue: 0, alpha: CGFloat(data[index])/255.0)
        case expectedLengthGrayScale:
            return UIColor(white: CGFloat(data[2 * index]) / 255.0, alpha: CGFloat(data[2 * index + 1]) / 255.0)
        case expectedLengthRGB:
            return UIColor(red: CGFloat(data[3*index])/255.0, green: CGFloat(data[3*index+1])/255.0, blue: CGFloat(data[3*index+2])/255.0, alpha: 1.0)
        case expectedLengthRGBA:
            return UIColor(red: CGFloat(data[4*index])/255.0, green: CGFloat(data[4*index+1])/255.0, blue: CGFloat(data[4*index+2])/255.0, alpha: CGFloat(data[4*index+3])/255.0)
        default:
            return UIColor.clear
        }
    }
}