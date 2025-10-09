//
//  ForecastViewController.swift
//  weather
//
//  Created by Einstein Nguyen on 11/6/21.
//

import Foundation
import UIKit

class ForecastViewController: UIViewController {
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var tableView: UITableView!
    
    var forecastViewModel: ForecastViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let viewModel = self.forecastViewModel else { return }
        viewModel.blurEffectView.effect = self.forecastViewModel?.blurEffect
        viewModel.blurEffectView.frame = self.view.bounds
        viewModel.blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewModel.blurEffectView.isHidden = true
        self.view.addSubview(viewModel.blurEffectView)
        self.registerTableViewCells()
        self.configureView()
    }
    
    private func registerTableViewCells() {
        let forecestCellNib = UINib(nibName: "ForecastCell", bundle: nil)
        self.tableView.register(forecestCellNib, forCellReuseIdentifier: "forecastCell")
    }
    
    private func configureView() {
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        self.title = "Cincinnati"//self.forecastViewModel?.cityForecast?.city.name
        self.tableView.backgroundView?.backgroundColor = .clear
        self.tableView.backgroundColor = .clear
        self.tableView.separatorStyle = .singleLine
        self.tableView.separatorColor = .black
        self.pickerView.setValue(UIColor.black, forKeyPath: "textColor")
//        self.view.addBackgroundFor(date: Date(), weather: "Clear")
    }
    
    @IBAction func degreeButtonPressed(_ sender: Any) {
        if self.pickerView.isHidden {
            self.forecastViewModel?.blurEffectView.isHidden = false
            self.view.bringSubviewToFront(self.pickerView)
            self.pickerView.isHidden = false
        } else {
            self.forecastViewModel?.blurEffectView.isHidden = true
            self.pickerView.isHidden = true
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "presentForecastDetail" {
            let forecastDetailViewController = segue.destination as? ForecastDetailViewController
            let obj = sender as? [String: Any?]
            let viewModel = ForecastDetailViewModel(forecast: obj?["forecast"] as? Forecast, cityName: "Cincinnati")
            forecastDetailViewController?.forecastDetailViewModel = viewModel
        }
    }
}

// MARK: TableViewDataSource
extension ForecastViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
//        return self.forecastViewModel?.dateArray.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let forecast = self.forecastViewModel?.cityForecast?.properties.periods else { return 0 }
//        var count = 0
//        for item in forecast {
//            if self.forecastViewModel?.dateArray[section] == item.startTime {
//                count += 1
//            }
//        }
//        
//        return count
        return forecast.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.forecastViewModel?.dateArray[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let forecast = self.forecastViewModel?.cityForecast?.properties.periods[indexPath.row],
              let cell = tableView.dequeueReusableCell(withIdentifier: "forecastCell", for: indexPath) as? ForecastCell
        else { return UITableViewCell() }

        let dateString = DateHelper.convertDTToString(dateString: forecast.startTime, format: .time)
        let tempString = ForecastHelper.convert(temp: Float(forecast.temperature), from: .fahrenheit, to: self.forecastViewModel?.newTemp ?? .fahrenheit) //String(forecast.temperature)
        let rainString = "0%"//"\(Int(forecast.pop * 100))%"
        let windString = forecast.windSpeed//"\(ForecastHelper.calculateDirection(deg: forecast.wind.deg)) \(Int(forecast.wind.speed)) mph"

        cell.weatherLabel.text = forecast.shortForecast
        cell.tempLabel.text = tempString
        cell.dateLabel.text = dateString
        cell.rainLabel.text = rainString
        cell.windLabel.text = windString
        cell.backgroundColor = .clear
        cell.backgroundView?.backgroundColor = .clear
        return cell
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let header = UIView()
//        header.backgroundColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.5)
//        
//        let label = UILabel()
//        label.text =  forecastViewModel?.dateArray[section]
//        label.textColor = .darkGray
//        label.font = .boldSystemFont(ofSize: 16)
//        
//        header.addSubview(label)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            label.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 16),
//            label.centerYAnchor.constraint(equalTo: header.centerYAnchor)
//        ])
//        
//        return header
//    }
}

// MARK: UITableViewDelegate
extension ForecastViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            tableView.deselectRow(at: indexPath, animated: true)
            let sender: [String: Any?] = ["forecast": self.forecastViewModel?.cityForecast?.properties.periods[indexPath.row]]
            self.performSegue(withIdentifier: "presentForecastDetail", sender: sender)
        }
    }
    
//    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//        if let headerView = view as? UITableViewHeaderFooterView {
//            headerView.contentView.backgroundColor = .clear
//            headerView.backgroundView?.backgroundColor = .clear
//            headerView.tintColor = .clear
//            headerView.textLabel?.textColor = .black
//        }
//    }
}

// MARK: UIPickerViewDataSource && UIPickerViewDelegate
extension ForecastViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.forecastViewModel?.pickerStatuses.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.forecastViewModel?.pickerStatuses[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        DispatchQueue.main.async {
            self.pickerView.isHidden = true
            self.forecastViewModel?.blurEffectView.isHidden = true
            guard let status = self.forecastViewModel?.pickerStatuses[row] else { return }
            self.forecastViewModel?.newTemp = status == "Celsius" ? .celsius : .fahrenheit
            self.tableView.reloadData()
        }
    }
}
