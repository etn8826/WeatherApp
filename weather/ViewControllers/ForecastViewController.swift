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
    var blurEffectView = UIVisualEffectView()
    
    var forecastViewModel: ForecastViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        blurEffectView.effect = UIBlurEffect(style: .light)
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.isHidden = true
        self.view.addSubview(blurEffectView)
        self.registerTableViewCells()
        self.configureView()
        self.configurePageView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let gradientView = GradientView(frame: view.bounds, startColor: .systemCyan, endColor: .systemOrange)
        self.view.insertSubview(gradientView, at: 0)
    }
    
    private func registerTableViewCells() {
        let forecestCellNib = UINib(nibName: "ForecastCell", bundle: nil)
        self.tableView.register(forecestCellNib, forCellReuseIdentifier: "forecastCell")
    }
    
    private func configureView() {
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        self.tableView.backgroundView?.backgroundColor = .clear
        self.tableView.backgroundColor = .clear
        self.tableView.separatorStyle = .singleLine
        self.tableView.separatorColor = .black
        self.pickerView.setValue(UIColor.black, forKeyPath: "textColor")
        guard let cityState = self.forecastViewModel?.cityState else { return  }
        self.title = "\(String(describing: cityState.city)), \(String(describing: cityState.state))"
    }
    
    private func configurePageView() {
        let pageVC = DayForecastPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageVC.forecastViewModel = self.forecastViewModel

        // add as child full-screen (or constrain to the area where the table was)
        addChild(pageVC)
        pageVC.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pageVC.view)
        NSLayoutConstraint.activate([
            pageVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageVC.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            pageVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        pageVC.didMove(toParent: self)

        // hide the old table view if present
        tableView.isHidden = true
    }
    
    @IBAction func degreeButtonPressed(_ sender: Any) {
        if self.pickerView.isHidden {
            blurEffectView.isHidden = false
            self.view.bringSubviewToFront(self.pickerView)
            self.pickerView.isHidden = false
        } else {
            blurEffectView.isHidden = true
            self.pickerView.isHidden = true
        }
    }

    @IBAction func addForecast(_ sender: Any) {
    }
}

// MARK: TableViewDataSource
extension ForecastViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.forecastViewModel?.dateArray.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.forecastViewModel?.dateArray[section].weathers.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let date = self.forecastViewModel?.dateArray[section].date else { return "" }
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        return formatter.string(from: date)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let forecast = self.forecastViewModel?.dateArray[indexPath.section].weathers[indexPath.row],
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
        DispatchQueue.main.async { [weak self] in
            self?.pickerView.isHidden = true
            self?.blurEffectView.isHidden = true
            guard let status = self?.forecastViewModel?.pickerStatuses[row] else { return }
            self?.forecastViewModel?.newTemp = status == "Celsius" ? .celsius : .fahrenheit
            self?.tableView.reloadData()
        }
    }
}
