//
//  ForecastResultsDataSource.swift
//  weather
//
//  Created by Einstein Nguyen on 10/19/25.
//

import UIKit

class ForecastResultsDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    private weak var tableView: UITableView?
    private var items: [Any] = []
    var didSelect: ((Any) -> Void)?

    init(tableView: UITableView) {
        self.tableView = tableView
        super.init()
        tableView.dataSource = self
        tableView.delegate = self
    }

    func update(items: [Any]) {
        self.items = items
        tableView?.reloadData()
    }

    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let id = "ForecastResultCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath)
        return cell
    }

    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        didSelect?(item)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
