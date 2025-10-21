//
//  DayForecastViewController.swift
//  weather
//
//  Created by Einstein Nguyen on 10/20/25.
//

// swift
import UIKit

class DayForecastViewController: UIViewController {
    var forecastViewModel: ForecastViewModel?
    var dayIndex: Int = 0
    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        tableView.register(UINib(nibName: "ForecastCell", bundle: nil), forCellReuseIdentifier: "forecastCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.separatorColor = .black
        tableView.allowsSelection = false
    }
}

extension DayForecastViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecastViewModel?.dateArray[dayIndex].weathers.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let forecast = forecastViewModel?.dateArray[dayIndex].weathers[indexPath.row],
              let cell = tableView.dequeueReusableCell(withIdentifier: "forecastCell", for: indexPath) as? ForecastCell
        else { return UITableViewCell() }

        let dateString = DateHelper.formatDateString(dateString: forecast.startTime, format: .time)
        let tempString = ForecastHelper.convert(temp: Float(forecast.temperature), from: .fahrenheit, to: forecastViewModel?.newTemp ?? .fahrenheit)
        let rainString = String(forecast.probabilityOfPrecipitation.value) + "%"
        let windString = forecast.windSpeed

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
