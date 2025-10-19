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
    private let cellIdentifier: String
    private let configureCell: (UITableViewCell, Any, IndexPath) -> Void

    init(tableView: UITableView,
         cellIdentifier: String = "ForecastResultCell",
         configureCell: @escaping (UITableViewCell, Any, IndexPath) -> Void) {
        self.tableView = tableView
        self.cellIdentifier = cellIdentifier
        self.configureCell = configureCell
        super.init()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let item = items[indexPath.row]
        configureCell(cell, item, indexPath)
        return cell
    }

    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        didSelect?(item)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
