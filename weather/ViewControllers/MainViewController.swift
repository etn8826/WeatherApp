//
//  MainViewController.swift
//  weather
//
//  Created by Einstein Nguyen on 11/6/21.
//

import Foundation
import UIKit
import MapKit
import CoreLocation
import CoreLocationUI

class MainViewController: UIViewController {
    @IBOutlet weak var locationSearchTableView: UITableView!
    @IBOutlet weak var locationSearchBar: UISearchBar!
    @IBOutlet weak var locationButton: CLLocationButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    var locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchCompleter.delegate = self
        self.locationManager.delegate = self
        self.locationSearchBar.delegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        self.configureView()
    }
    
    private func configureView() {
        self.locationSearchBar.setSearchFieldBackgroundImage(UIImage(), for: .normal)
        self.locationSearchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        let searchBarTextField = locationSearchBar.value(forKey: "searchField") as? UITextField
        searchBarTextField?.textColor = .white
        self.view.addBackgroundFor(date: Date())
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func useCurrentLocationTapped(_ sender: Any) {
        self.locationManager.requestLocation()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showForecast" {
            let forecastViewController = segue.destination as? ForecastViewController
            let obj = sender as? [String: Any?]
            forecastViewController?.forecastViewModel = ForecastViewModel(cityForecast: obj?["forecast"] as? CityForeCast)
        }
    }
}

// MARK: CLLocationManagerDelegate
extension MainViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.activityIndicator.startAnimating()
        self.activityIndicator.isHidden = false
        MainViewInteractor.getForecastWithUserLocation(
            locations: locations,
            success: { [weak self] cityForecast in
                DispatchQueue.main.async {
                    self?.activityIndicator.stopAnimating()
                    self?.activityIndicator.isHidden = true
                    let sender: [String: Any?] = ["forecast": cityForecast]
                    self?.performSegue(withIdentifier: "showForecast", sender: sender)
                }
            },
            failure: { [weak self] error in
                DispatchQueue.main.async {
                    self?.activityIndicator.stopAnimating()
                    self?.activityIndicator.isHidden = true
                    let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self?.present(alert, animated: true, completion: nil)
                }
            }
        )
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        manager.requestLocation()
    }
}

// MARK: UISearchBarDelegate
extension MainViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            self.searchResults = []
            self.locationSearchTableView.reloadData()
        } else {
            self.searchCompleter.queryFragment = searchText
        }
    }
}

// MARK: MKLocalSearchCompleterDelegate
extension MainViewController: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.searchResults = completer.results
        self.searchResults = completer.results.filter { result in
            if !result.title.contains(",") {
                return false
            }
            if result.title.rangeOfCharacter(from: CharacterSet.decimalDigits)?.isEmpty != nil {
                return false
            }
            if result.subtitle.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil {
                return false
            }
            return true
        }

        self.locationSearchTableView.reloadData()
    }
}

// MARK: UITableViewDataSource
extension MainViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchResult = self.searchResults[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.backgroundColor = .clear
        cell.textLabel?.text = searchResult.title
        cell.textLabel?.textColor = .white
        cell.detailTextLabel?.text = searchResult.subtitle
        cell.detailTextLabel?.textColor = .white
        return cell
    }
}

// MARK: UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.activityIndicator.startAnimating()
        self.activityIndicator.isHidden = false
        MainViewInteractor.getForecastWithSearchResults(
            searchResults: self.searchResults,
            row: indexPath.row,
            success: { [weak self] cityForecast in
                DispatchQueue.main.async {
                    self?.activityIndicator.stopAnimating()
                    let sender: [String: Any?] = ["forecast": cityForecast]
                    self?.performSegue(withIdentifier: "showForecast", sender: sender)
                }
            },
            failure: { [weak self] error in
                DispatchQueue.main.async {
                    self?.activityIndicator.stopAnimating()
                    let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self?.present(alert, animated: true, completion: nil)
                }
            }
        )
    }
}
