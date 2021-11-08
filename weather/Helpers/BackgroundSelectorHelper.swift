//
//  BackgroundSelectorHelper.swift
//  weather
//
//  Created by Einstein Nguyen on 11/7/21.
//

import Foundation
import UIKit

struct BackgroundSelectorHelper {
    static func mainViewBackgroundSelector(date: Date) -> UIImage {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        switch hour {
        case 0...5, 21...24:
            guard let image = UIImage(named: "night") else { return UIImage() }
            return image
        case 6...8:
            guard let image = UIImage(named: "morning") else { return UIImage() }
            return image
        case 9...17:
            guard let image = UIImage(named: "day") else { return UIImage() }
            return image
        case 18...20:
            guard let image = UIImage(named: "evening") else { return UIImage() }
            return image
        default:
            guard let image = UIImage(named: "day") else { return UIImage() }
            return image
        }
    }
    
    static func forecastDetailBackgroundSelector(date: Date = Date(), weather: String) -> UIImage {
        if weather == "Clouds" {
            guard let image = UIImage(named: "clouds_day") else { return UIImage() }
            return image
        } else if weather == "Clear" {
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: date)
            switch hour {
            case 0...6, 18...24:
                guard let image = UIImage(named: "clear_night") else { return UIImage() }
                return image
            default:
                guard let image = UIImage(named: "clear_day") else { return UIImage() }
                return image
            }
        } else if weather == "Rain" {
            guard let image = UIImage(named: "rain") else { return UIImage() }
            return image
        } else if weather == "Snow" {
            guard let image = UIImage(named: "snow") else { return UIImage() }
            return image
        } else {
            return UIImage()
        }
    }
}

extension UIView {
    func addBackgroundFor(date: Date, weather: String = "") {
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        let imageViewBackground = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        
        if weather.isEmpty {
            imageViewBackground.image = BackgroundSelectorHelper.mainViewBackgroundSelector(date: date)
        } else {
            imageViewBackground.image = BackgroundSelectorHelper.forecastDetailBackgroundSelector(date: date, weather: weather)
        }
        
        imageViewBackground.contentMode = UIView.ContentMode.scaleAspectFill
        self.addSubview(imageViewBackground)
        self.sendSubviewToBack(imageViewBackground)
    }
}
