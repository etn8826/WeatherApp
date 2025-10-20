//
//  DayForecastPageViewController.swift
//  weather
//
//  Created by Einstein Nguyen on 10/20/25.
//

import UIKit

class DayForecastPageViewController: UIPageViewController {
    var forecastViewModel: ForecastViewModel!

    private var pages: [DayForecastViewController] = []
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

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        buildPages()
        setupTopBar()
        if let first = pages.first {
            setViewControllers([first], direction: .forward, animated: false, completion: nil)
        }
    }

    private func buildPages() {
        pages = []
        guard var vm = forecastViewModel else { return }
        for index in 0..<(vm.dateArray.count) {
            let vc = DayForecastViewController()
            vc.forecastViewModel = vm
            vc.dayIndex = index
            pages.append(vc)
        }
    }
    
    private func setupTopBar() {
        // Add scroll view and stack
        view.addSubview(topBarScrollView)
        topBarScrollView.addSubview(topBarStackView)
        NSLayoutConstraint.activate([
            topBarScrollView.topAnchor.constraint(equalTo: view.topAnchor),
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
        for index in 0..<pages.count {
            let btn = UIButton(type: .system)
            btn.tag = index
            btn.setTitle(formattedTitle(for: index), for: .normal)
            btn.titleLabel?.font = UIFont.preferredFont(forTextStyle: .subheadline)
            btn.setTitleColor(.darkGray, for: .normal)
            btn.setTitleColor(.white, for: .selected)
            btn.tintColor = .darkGray
            btn.addTarget(self, action: #selector(dateButtonTapped(_:)), for: .touchUpInside)
            btn.contentEdgeInsets = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)
            btn.layer.cornerRadius = 8
            btn.clipsToBounds = true
            topBarStackView.addArrangedSubview(btn)
            dateButtons.append(btn)
        }
        
        // Push page content down so the top of pages is anchored to the bottom of the bar
        additionalSafeAreaInsets.top += topBarHeight + 200

        // Make sure the top bar is above the page view's internal scroll view
        view.bringSubviewToFront(topBarScrollView)
        self.updateTopBarSelection(for: 0)
    }
    
    private func formattedTitle(for index: Int) -> String? {
        guard var vm = forecastViewModel,
              index >= 0, index < vm.dateArray.count else {
            return nil
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, MMM d" // shorter format for a bar
        return formatter.string(from: vm.dateArray[index].date)
    }

    @objc private func dateButtonTapped(_ sender: UIButton) {
        goToPage(index: sender.tag, animated: true)
    }

    func goToPage(index: Int, animated: Bool = true) {
        guard index >= 0, index < pages.count else { return }
        let direction: UIPageViewController.NavigationDirection = (viewControllers?.first.flatMap { pages.firstIndex(of: $0 as! DayForecastViewController) } ?? 0) <= index ? .forward : .reverse
        setViewControllers([pages[index]], direction: direction, animated: animated) { [weak self] _ in
            self?.updateTopBarSelection(for: index)
        }
    }
    
    private func updateTopBarSelection(for index: Int) {
        guard index >= 0, index < dateButtons.count else { return }
        for (i, btn) in dateButtons.enumerated() {
            let selected = (i == index)
            btn.isSelected = selected
            btn.titleLabel?.font = selected ? UIFont.boldSystemFont(ofSize: UIFont.preferredFont(forTextStyle: .subheadline).pointSize) : UIFont.preferredFont(forTextStyle: .subheadline)
        }

        let selectedButton = dateButtons[index]
        let visibleRect = selectedButton.frame
        topBarScrollView.scrollRectToVisible(visibleRect, animated: true)
    }
}

extension DayForecastPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let current = (viewController as? DayForecastViewController), let idx = pages.firstIndex(of: current) else { return nil }
        let prev = idx - 1
        return (prev >= 0) ? pages[prev] : nil
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let current = (viewController as? DayForecastViewController), let idx = pages.firstIndex(of: current) else { return nil }
        let next = idx + 1
        return (next < pages.count) ? pages[next] : nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        guard completed, let visible = viewControllers?.first as? DayForecastViewController, let idx = pages.firstIndex(of: visible) else { return }
        updateTopBarSelection(for: idx)
    }
}
