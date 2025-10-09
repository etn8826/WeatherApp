//
//  ForecastDetailViewController.swift
//  weather
//
//  Created by Einstein Nguyen on 11/7/21.
//

import Foundation
import UIKit

class ForecastDetailViewController: UIViewController {
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var subWeatherLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var feelsLikeTempLabel: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var dateLabel: UILabel!
    
    var forecastDetailViewModel: ForecastDetailViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let viewModel = self.forecastDetailViewModel else { return }
        viewModel.blurEffectView.effect = viewModel.blurEffect
        viewModel.blurEffectView.frame = self.view.bounds
        viewModel.blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewModel.blurEffectView.isHidden = true
        self.view.addSubview(viewModel.blurEffectView)
        self.configureView()
    }

    private func configureView() {
        guard let viewModel = self.forecastDetailViewModel,
              let forecast = viewModel.forecast else { return }
        let tempString = ForecastHelper.convert(temp: forecast.main.temp, from: .kelvin, to: viewModel.newTemp)
        let feelsLikeTempString = ForecastHelper.convert(temp: forecast.main.feelsLike, from: .kelvin, to: viewModel.newTemp)
        let date = Date(timeIntervalSince1970: TimeInterval(forecast.dt))
        let dateString = DateHelper.convertDTToString(dateString: "", format: .dateTime)
        
        self.title = viewModel.cityName
        viewModel.blurEffectView.isHidden = true
//        self.view.addBackgroundFor(date: date, weather: forecast.weather[0].main)
        self.pickerView.setValue(UIColor.white, forKeyPath: "textColor")
        self.tempLabel.text = tempString
        self.subWeatherLabel.text = forecast.weather[0].description.capitalized
        self.weatherLabel.text = forecast.weather[0].main
        self.feelsLikeTempLabel.text = feelsLikeTempString
        self.dateLabel.text = dateString
    }

    @IBAction func tempButtonPressed(_ sender: Any) {
        if self.pickerView.isHidden {
            self.forecastDetailViewModel?.blurEffectView.isHidden = false
            self.view.bringSubviewToFront(self.pickerView)
            self.pickerView.isHidden = false
        } else {
            self.forecastDetailViewModel?.blurEffectView.isHidden = true
            self.pickerView.isHidden = true
        }
    }
}

// MARK: UIPickerViewDataSource && UIPickerViewDelegate
extension ForecastDetailViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.forecastDetailViewModel?.pickerStatuses.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.forecastDetailViewModel?.pickerStatuses[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        DispatchQueue.main.async {
            self.pickerView.isHidden = true
            guard let status = self.forecastDetailViewModel?.pickerStatuses[row] else { return }
            self.forecastDetailViewModel?.newTemp = status == "Celsius" ? .celsius : .fahrenheit
            self.configureView()
        }
    }
}
