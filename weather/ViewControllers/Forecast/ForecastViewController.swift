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
    var blurEffectView = UIVisualEffectView()
    private let topBarScrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.showsHorizontalScrollIndicator = false
        return sv
    }()
    private let topBarStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 14
        sv.alignment = .center
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    private var dateButtons: [UIButton] = []
    private let topBarHeight: CGFloat = 44
    private var pageVC: DayForecastPageViewController?
    var forecastViewModel: ForecastViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
        self.configurePageView()
        blurEffectView.effect = UIBlurEffect(style: .light)
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.isHidden = true
        self.view.addSubview(blurEffectView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.addBackgroundFor(date: Date(), weather: self.forecastViewModel?.cityForecast?.properties.periods.first?.shortForecast ?? "")
//        let gradientView = GradientView(frame: view.bounds, startColor: .systemCyan, endColor: .systemOrange)
//        self.view.insertSubview(gradientView, at: 0)
    }
    
    private func configureView() {
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        self.pickerView.setValue(UIColor.black, forKeyPath: "textColor")
        guard let cityState = self.forecastViewModel?.cityState else { return  }
        self.title = "\(String(describing: cityState.city)), \(String(describing: cityState.state))"
    }
    
    private func configurePageView() {
        let pageVC = DayForecastPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        self.pageVC = pageVC
        pageVC.forecastViewModel = self.forecastViewModel
        self.setupTopBar()
        addChild(pageVC)
        pageVC.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pageVC.view)
        NSLayoutConstraint.activate([
            pageVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageVC.view.topAnchor.constraint(equalTo: self.topBarScrollView.bottomAnchor),
            pageVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupTopBar() {
        view.addSubview(topBarScrollView)
        topBarScrollView.addSubview(topBarStackView)
        NSLayoutConstraint.activate([
            topBarScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topBarScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            topBarScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            topBarScrollView.heightAnchor.constraint(equalToConstant: topBarHeight),

            topBarStackView.topAnchor.constraint(equalTo: topBarScrollView.topAnchor),
            topBarStackView.bottomAnchor.constraint(equalTo: topBarScrollView.bottomAnchor),
            topBarStackView.leadingAnchor.constraint(equalTo: topBarScrollView.leadingAnchor),
            topBarStackView.trailingAnchor.constraint(equalTo: topBarScrollView.trailingAnchor),
            topBarStackView.heightAnchor.constraint(equalTo: topBarScrollView.heightAnchor)
        ])

        // Create date buttons
        dateButtons = []
        for index in 0..<(forecastViewModel?.dateArray.count ?? 0) {
            let btn = UIButton(type: .system)
            btn.tag = index
            btn.setTitle(formattedTitle(for: index), for: .normal)
            btn.titleLabel?.font = UIFont.preferredFont(forTextStyle: .subheadline)
            btn.setTitleColor(.darkGray, for: .normal)
            btn.setTitleColor(.white, for: .selected)
            btn.tintColor = .darkGray
            btn.addTarget(self.pageVC, action: #selector(self.pageVC?.dateButtonTapped(_:)), for: .touchUpInside)
            btn.contentEdgeInsets = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)
            btn.layer.cornerRadius = 8
            btn.clipsToBounds = true
            topBarStackView.addArrangedSubview(btn)
            dateButtons.append(btn)
        }
        self.pageVC?.dateButtons = dateButtons
        self.pageVC?.topBarScrollView = topBarScrollView

        view.bringSubviewToFront(topBarScrollView)
        self.pageVC?.updateTopBarSelection(for: 0)
    }
    
    private func formattedTitle(for index: Int) -> String? {
        guard let vm = forecastViewModel,
              index >= 0, index < vm.dateArray.count else {
            return nil
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, MMM d" // shorter format for a bar
        return formatter.string(from: vm.dateArray[index].date)
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
        // Add forecast to local storage to view on mainscreen
        
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
            self?.pageVC?.pages.forEach { vc in
                vc.tableView.reloadData()
            }
        }
    }
}
