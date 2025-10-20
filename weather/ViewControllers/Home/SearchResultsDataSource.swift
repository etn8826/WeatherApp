//
//  SearchResultsDataSource.swift
//  weather
//
//  Created by Einstein Nguyen on 10/19/25.
//

import UIKit
import MapKit

class SearchResultsDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    private weak var tableView: UITableView?
    private var results: [MKLocalSearchCompletion] = []
    var didSelect: ((MKLocalSearchCompletion) -> Void)?

    init(tableView: UITableView) {
        self.tableView = tableView
        super.init()
        tableView.dataSource = self
        tableView.delegate = self
    }

    func update(_ results: [MKLocalSearchCompletion]) {
        self.results = results
        tableView?.reloadData()
    }

    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let id = "SearchResultCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: id) ??
            UITableViewCell(style: .subtitle, reuseIdentifier: id)
        let item = results[indexPath.row]
        cell.textLabel?.text = item.title
        cell.detailTextLabel?.text = item.subtitle
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        return cell
    }

    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = results[indexPath.row]
        didSelect?(item)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
