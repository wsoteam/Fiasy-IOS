//
//  NutritionPlanListTableCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 1/20/20.
//  Copyright © 2020 Eugen Lipatov. All rights reserved.
//

import UIKit
import Kingfisher
import Alamofire
import VisualEffectView

class NutritionPlanListTableCell: UICollectionViewCell {

    // MARK: - Outlet's -
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dayCountButton: UIButton!
    @IBOutlet weak var premTitleLabel: UILabel!
    @IBOutlet weak var premiumContainerView: UIView!
    @IBOutlet weak var blurView: VisualEffectView!
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var alphaView: UIView!
    
    //MARK: - Properties -
    private var delegate: NutritionPlanDelegate?
    private var nutrition: NutritionDetail?
    
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
        premTitleLabel.text = LS(key: .PREMIUM_TITLE)
    }
    
    // MARK: - Interface -
    func fillRow(nutrition: NutritionDetail, delegate: NutritionPlanDelegate?) {
        self.delegate = delegate
        self.nutrition = nutrition
        
        likeButton.setImage(nutrition.isLiked ? #imageLiteral(resourceName: "someLike") : #imageLiteral(resourceName: "nutrition_favorite_empty"), for: .normal)
        nameLabel.text = nutrition.name
        dayCountButton.setTitle(" \(nutrition.countDays ?? 0) дней", for: .normal)
        if let path = nutrition.urlImage, let url = try? path.asURL() {
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
        premiumContainerView.isHidden = !(nutrition.premium ?? false)
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
    
    // MARK: - Actions -
    @IBAction func likeClicked(_ sender: Any) {
        guard let nutrition = self.nutrition else { return }
        if nutrition.isLiked {
            self.delegate?.removeLike(nutrition: self.nutrition, self.likeButton)
        } else {
            FirebaseDBManager.saveLikeNutritionInDataBase(nutrition: nutrition) { (key) in
                self.nutrition?.removeKey = key
                self.nutrition?.isLiked = true
                if let key1 = key {
                    self.likeButton.setImage(#imageLiteral(resourceName: "someLike"), for: .normal)
                    self.delegate?.fillLike(key: key1, nutrition: nutrition)
                }
            }
        }
    }
}
