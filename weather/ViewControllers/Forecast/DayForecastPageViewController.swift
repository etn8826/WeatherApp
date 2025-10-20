//
//  DayForecastPageViewController.swift
//  weather
//
//  Created by Einstein Nguyen on 10/20/25.
//

import UIKit

class DayForecastPageViewController: UIPageViewController {
    var forecastViewModel: ForecastViewModel!
    var pages: [DayForecastViewController] = []
    var topBarScrollView: UIScrollView?
    var dateButtons: [UIButton] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        buildPages()
        if let first = pages.first {
            setViewControllers([first], direction: .forward, animated: false, completion: nil)
        }
    }

    private func buildPages() {
        pages = []
        guard let vm = forecastViewModel else { return }
        for index in 0..<(vm.dateArray.count) {
            let vc = DayForecastViewController()
            vc.forecastViewModel = vm
            vc.dayIndex = index
            pages.append(vc)
        }
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

    @objc func dateButtonTapped(_ sender: UIButton) {
        goToPage(index: sender.tag, animated: true)
    }

    func goToPage(index: Int, animated: Bool = true) {
        guard index >= 0, index < pages.count else { return }
        let direction: UIPageViewController.NavigationDirection = (viewControllers?.first.flatMap { pages.firstIndex(of: $0 as! DayForecastViewController) } ?? 0) <= index ? .forward : .reverse
        setViewControllers([pages[index]], direction: direction, animated: animated) { [weak self] _ in
            self?.updateTopBarSelection(for: index)
        }
    }
    
    func updateTopBarSelection(for index: Int) {
        guard index >= 0, index < dateButtons.count else { return }
        for (i, btn) in dateButtons.enumerated() {
            let selected = (i == index)
            btn.isSelected = selected
            btn.titleLabel?.font = selected ? UIFont.boldSystemFont(ofSize: UIFont.preferredFont(forTextStyle: .subheadline).pointSize) : UIFont.preferredFont(forTextStyle: .subheadline)
        }

        let selectedButton = dateButtons[index]
        let visibleRect = selectedButton.frame
        topBarScrollView?.scrollRectToVisible(visibleRect, animated: true)
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
