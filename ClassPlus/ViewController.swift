//
//  ViewController.swift
//  ClassPlus
//
//  Created by Hitendra Dubey on 17/06/18.
//  Copyright © 2018 Hitendra Dubey. All rights reserved.
//

import UIKit
import FSCalendar
import Alamofire

class ViewController: UIViewController,FSCalendarDelegate,FSCalendarDataSource,UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource,FSCalendarDelegateAppearance {
    
//fileprivate weak var calendar: FSCalendar!

    @IBOutlet weak var calendarHeightConstraint : NSLayoutConstraint?
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var toggle: UIButton!
    
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    fileprivate lazy var scopeGesture: UIPanGestureRecognizer = {
        [unowned self] in
        let panGesture = UIPanGestureRecognizer(target: self.calendar, action: #selector(self.calendar.handleScopeGesture(_:)))
        panGesture.delegate = self
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 2
        return panGesture
        }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //let calendar = FSCalendar(frame: CGRect(x: 5, y: 30, width: view.frame.width-5, height: 100))
        calendar.dataSource = self
        calendar.delegate = self
        //calendar.scope = FSCalendarScope.week
        //view.addSubview(calendar)
        //self.calendar = calendar

        
        //////
        
        if UIDevice.current.model.hasPrefix("iPad") {
            self.calendarHeightConstraint?.constant = 400
        }
        
        self.calendar.select(Date())
        
        self.view.addGestureRecognizer(self.scopeGesture)
        self.tableView.panGestureRecognizer.require(toFail: self.scopeGesture)
        self.calendar.scope = .week
        
        // For UITest
        self.calendar.accessibilityIdentifier = "calendar"

        
        
        
    }
    
    deinit {
        print("\(#function)")
    }
    
    
    ///
    
    // MARK:- UIGestureRecognizerDelegate
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let shouldBegin = self.tableView.contentOffset.y <= -self.tableView.contentInset.top
        if shouldBegin {
            let velocity = self.scopeGesture.velocity(in: self.view)
            switch self.calendar.scope {
            case .month:
                return velocity.y < 0
            case .week:
                return velocity.y > 0
            }
        }
        return shouldBegin
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint?.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("did select date \(self.dateFormatter.string(from: date))")
        let selectedDates = calendar.selectedDates.map({self.dateFormatter.string(from: $0)})
        print("selected dates is \(selectedDates)")
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print("\(self.dateFormatter.string(from: calendar.currentPage))")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderDefaultColorFor date: Date) -> UIColor? {
//
//        return calendar.gregorian.component(.weekday, from: date) == 4 ? UIColor.green : UIColor.gray
//
//    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, selectionColorFor date: Date) -> UIColor? {
        return calendar.gregorian.component(.weekday, from: date) == 4 ? UIColor.green : UIColor.gray
    }
    
    
    ////
    
    
    // MARK:- UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return [2,20][section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let identifier = ["cell_month", "cell_week"][indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier)!
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
            return cell
        }
    }
    
    
    // MARK:- UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            let scope: FSCalendarScope = (indexPath.row == 0) ? .month : .week
            //self.calendar.setScope(scope, animated: self.animationSwitch.isOn)
            self.calendar.setScope(scope, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    // MARK:- Target actions
    

    @IBAction func toggleClicked(_ sender: Any) {
        
        if self.calendar.scope == .month {
            //self.calendar.setScope(.week, animated: self.animationSwitch.isOn)
            self.calendar.setScope(.week, animated: true)
        } else {
            //self.calendar.setScope(.month, animated: self.animationSwitch.isOn)
            self.calendar.setScope(.month, animated: true)
        }
        
    }
    

}

