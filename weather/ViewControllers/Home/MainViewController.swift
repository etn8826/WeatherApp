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
    private var searchResultsTableView: UITableView!
    private var searchResultsTableHeightConstraint: NSLayoutConstraint?
    private var dimmingView: UIView!
    private let searchCellId = "SeachResultCell"
    private let maxOverlayHeight: CGFloat = 300.0
    private let viewModel = MainViewModel()
    private var searchDataSource: SearchResultsDataSource!
    private var forecastDataSource: ForecastResultsDataSource!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchCompleter.delegate = self
        self.locationManager.delegate = self
        self.locationSearchBar.delegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        self.configureView()
        self.configureSearchTableView()
        self.configureTableViewDataSource()
        self.bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let gradientView = GradientView(frame: view.bounds, startColor: .systemCyan, endColor: .systemOrange)
        self.view.insertSubview(gradientView, at: 0)
        self.locationSearchBar.text = ""
        self.searchResults = []
    }

    private func configureTableViewDataSource() {
        forecastDataSource = ForecastResultsDataSource(tableView: locationSearchTableView) { cell, item, _ in
            if let s = item as? String {
                cell.textLabel?.text = s
            } else {
                cell.textLabel?.text = String(describing: item)
            }
        }
        forecastDataSource.didSelect = { [weak self] item in
            print("API row selected:", item)
        }
        
        searchDataSource = SearchResultsDataSource(tableView: searchResultsTableView)
        searchDataSource.didSelect = { [weak self] completion in
            self?.hideOverlay()
            self?.locationSearchBar.resignFirstResponder()
            let request = MKLocalSearch.Request(completion: completion)
            if let cityState = request.naturalLanguageQuery {
                self?.viewModel.getForecast(cityState: cityState)
            }
        }
    }
    
    private func bindViewModel() {
        viewModel.onForecastFetched = { [weak self] forecast, location in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                let sender: [String: Any?] = ["forecast": forecast, "location": location]
                self?.performSegue(withIdentifier: "showForecast", sender: sender)
            }
        }
        
        viewModel.onError = { [weak self] error in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self?.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    private func configureView() {
        self.locationSearchBar.setSearchFieldBackgroundImage(UIImage(), for: .normal)
        self.locationSearchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        let searchBarTextField = locationSearchBar.value(forKey: "searchField") as? UITextField
        searchBarTextField?.textColor = .black
    }
    
    private func configureSearchTableView() {
        dimmingView = UIView(frame: .zero)
        dimmingView.translatesAutoresizingMaskIntoConstraints = false
        dimmingView.backgroundColor = UIColor(white: 0, alpha: 0.4)
        dimmingView.alpha = 0
        dimmingView.isHidden = true
        let dismissTap = UITapGestureRecognizer(target: self, action: #selector(dismissOverlay))
        dimmingView.addGestureRecognizer(dismissTap)
        view.addSubview(dimmingView)
        NSLayoutConstraint.activate([
            dimmingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimmingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dimmingView.topAnchor.constraint(equalTo: view.topAnchor),
            dimmingView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        searchResultsTableView = UITableView(frame: .zero, style: .plain)
        searchResultsTableView.translatesAutoresizingMaskIntoConstraints = false
        searchResultsTableView.backgroundColor = .white
        searchResultsTableView.layer.cornerRadius = 12
        searchResultsTableView.layer.masksToBounds = true
        searchResultsTableView.layer.shadowColor = UIColor.black.cgColor
        searchResultsTableView.layer.shadowOpacity = 0.2
        searchResultsTableView.layer.shadowOffset = CGSize(width: 0, height: 4)
        searchResultsTableView.layer.shadowRadius = 8
        searchResultsTableView.separatorColor = .lightGray
        searchResultsTableView.separatorStyle = .singleLine
        searchResultsTableView.register(UITableViewCell.self, forCellReuseIdentifier: searchCellId)

        view.addSubview(searchResultsTableView)

        let leading = searchResultsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12)
        let trailing = searchResultsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12)
        let top = searchResultsTableView.topAnchor.constraint(equalTo: locationSearchBar.bottomAnchor, constant: 8)
        let height = searchResultsTableView.heightAnchor.constraint(equalToConstant: 0)
        NSLayoutConstraint.activate([leading, trailing, top])
        height.isActive = true
        searchResultsTableHeightConstraint = height

        searchResultsTableView.isHidden = true
        view.bringSubviewToFront(dimmingView)
        view.bringSubviewToFront(searchResultsTableView)
    }
    
    @objc func dismissOverlay() {
       hideOverlay()
       dismissKeyboard()
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
            forecastViewController?.forecastViewModel = ForecastViewModel(cityForecast: obj?["forecast"] as? HourlyForecastResponse,
                                                                          cityState: obj?["location"] as? RelativeLocationProperties)
        }
    }
    
    private func showOverlay() {
        guard searchResultsTableView.isHidden else { return }
        dimmingView.isHidden = false
        searchResultsTableView.isHidden = false
        view.bringSubviewToFront(dimmingView)
        view.bringSubviewToFront(searchResultsTableView)
        UIView.animate(withDuration: 0.2) {
            self.dimmingView.alpha = 1
        }
        if searchResultsTableHeightConstraint?.constant == 0 {
            searchResultsTableHeightConstraint?.constant = min(maxOverlayHeight, view.bounds.height / 2)
        }
    }

    private func hideOverlay() {
        guard !searchResultsTableView.isHidden else { return }
        UIView.animate(withDuration: 0.2, animations: {
            self.dimmingView.alpha = 0
        }, completion: { _ in
            self.dimmingView.isHidden = true
        })
        searchResultsTableView.isHidden = true
    }
}

// MARK: CLLocationManagerDelegate
extension MainViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.activityIndicator.startAnimating()
        self.activityIndicator.isHidden = false
        viewModel.getForecast(location: locations)
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
            searchResults = []
            searchDataSource.update(searchResults)
        } else {
            self.searchCompleter.queryFragment = searchText
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchDataSource.update(searchResults)
        showOverlay()
        view.bringSubviewToFront(searchResultsTableView)
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
        searchDataSource.update(searchResults)
    }
}
