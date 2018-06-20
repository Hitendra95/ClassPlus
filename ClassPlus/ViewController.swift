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
import FlickrKit
import SwiftyJSON

class ViewController: UIViewController,FSCalendarDelegate,FSCalendarDataSource,UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource,FSCalendarDelegateAppearance {
    
//fileprivate weak var calendar: FSCalendar!

    let baseUrl = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=04dd791b6393b0ab32b7105586cbf3bc&content_type=1&per_page=3&format=json&nojsoncallback=1&tags="
    
    var studentImage = ["http://farm2.staticflickr.com/1764/42857137572_7e31065226_s.jpg","http://farm2.staticflickr.com/1764/42857137572_7e31065226_s.jpg","http://farm2.staticflickr.com/1731/41081933130_092662d181_s.jpg"]

    
    let daysName = [1:"Sunday",2:"Monday",3:"Tueday",4:"Wednesday",5:"Thursday",6:"Friday",7:"Saturday"]
    let dayNumber = ["Sunday":1,"Monday":2,"Tuesday":3,"Wednesdy":4,"Thursday":5,"Friday":6,"Saturday":7]
    var noOfDaysSelected = 0
    @IBOutlet weak var calendarHeightConstraint : NSLayoutConstraint?
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var tableView: UITableView!
    
    var day = ""
    var finalStudentData = [Data]()
    
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
     
        calendar.dataSource = self
        calendar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
//
//        for i in 0...2
//        {
//            let url = NSURL(string: studentImage[i])
//            if let imageData = NSData(contentsOf: url! as URL)
//            {
//                finalStudentData[i] = imageData as Data
//
//            }
//            else
//            {
//                print("unable to get image")
//            }
//
//        }
        tableView.reloadData()
        //let url1 = NSURL(string: studentImage[0])
//()
        //////
        
//        if UIDevice.current.model.hasPrefix("iPad") {
//            self.calendarHeightConstraint?.constant = 400
//        }
//
//        self.calendar.select(Date())
//
//        self.view.addGestureRecognizer(self.scopeGesture)
//    //    self.tableView.panGestureRecognizer.require(toFail: self.scopeGesture)
        self.calendar.scope = .week
//
//        // For UITest
//        self.calendar.accessibilityIdentifier = "calendar"

        
        //calendar.contentView.sizeThatFits(calendar.frame.size)
        
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
       
       // self.calendar.frame.size.height = bounds.height
        self.calendarHeightConstraint?.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("did select date \(self.dateFormatter.string(from: date))")
       // print()
        
        //print("day of did select date \(daysName[calendar.gregorian.component(.weekday, from: date)])")
        day = daysName[calendar.gregorian.component(.weekday, from: date)]!
        print(baseUrl+day)
        
        //fetchImagesFromApiServer(dayName: day)
        fetchImagesFromApiServer(url: baseUrl, dayName: day)
        
        let  selectedDates = calendar.selectedDates.map({self.dateFormatter.string(from: $0)})
        print("selected dates is \(selectedDates)")
        noOfDaysSelected = selectedDates.count
        tableView.reloadData()
        
        //print()
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
    //MARK:  Fetch data from the Flicker Api server
    
    func fetchImagesFromApiServer(url: String,dayName:String)
    {
        print(baseUrl+dayName)
        Alamofire.request(baseUrl+dayName, method: .get).responseJSON{
            response in
            
            if response.result.isSuccess
            {
                print("response is : \(String(describing: response.result.value))")
                if(response.data != nil){
                    
                    for i in 0...2
                    {
                        var json:JSON = JSON(response.data!)
                        var innerJson:JSON = JSON(response.data!)
                    
                        var farm:String = innerJson["photos"]["photo"][i]["farm"].stringValue
                        var server:String = innerJson["photos"]["photo"][i]["server"].stringValue
                        var photoID:String = innerJson["photos"]["photo"][i]["id"].stringValue
                    
                        var secret:String = innerJson["photos"]["photo"][i]["secret"].stringValue
                    
                        var imageString = "http://farm\(farm).staticflickr.com/\(server)/\(photoID)_\(secret)_s.jpg"
                    //self.urlToImageView(imageString)
                    print(imageString)
                    //self.studentImage.va = imageString[i]
                        self.studentImage[i] = imageString
                    
                    }
                
            }
            else
            {
                print("error is : \(String(describing: response.result.error))")
            }
    }

    }
}
    
//    func fetchImage(imageStringUrl : String)
//    {
//        Alamofire.request(imageStringUrl, method: .get).responseJSON{
//            response in
//
//
//
//
//        }
//
//
//    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        return calendar.gregorian.component(.weekday, from: date) == 4 ? UIColor.green : UIColor.white
    }
    
    
    // MARK:- UITableViewDataSource
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 2
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if noOfDaysSelected == 0
        {
            return 1
        }
        else
        {
            return noOfDaysSelected + 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
          let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCellOfData
        cell.subjectName.text = "Chemistry Batch-02"
        cell.totalNumberOfClassCompleted.text = "Chemistry -07"
        
        
        //MARK: for Default wednesday selected day
        if noOfDaysSelected == 0
        {
            let url = URL(string: studentImage[0])
            if let imageData = try? Data(contentsOf: url!)
            {
                if let image = UIImage(data: imageData)
                {
                    //DispatchQueue.main.async
                    //{
                    cell.firstStudentImage.image = image
                    cell.secondStudentImage.image = image
                    cell.thirdStudentImage.image = image
                    
                    cell.firstStudentImage.isHidden = false
                        
                    //}
                }
                
            }
        }
        //MARK: For selected date
        
        
        
       // }
//            print("getimage Data")
//
//            if imageData != nil
//            {
//                cell.firstStudentImage.image = UIImage(data: imageData! as Data)
//                cell.secondStudentImage.image = UIImage(data: imageData! as Data)
//                cell.thirdStudentImage.image = UIImage(data: imageData! as Data)
//            }
//
//            else
//            {
//                print("unable to fetch image")
//            }
//
   
        
        //let url = NSURL(string: studentImage[0])
       // let imageData = NSData(contentsOf: url! as URL)
//        if finalStudentData[0] != nil
//        {
//           cell.firstStudentImage.image = UIImage(data: finalStudentData[0])
//        }
        //cell.secondStudentImage.image = UIImage(data: finalStudentData[1])
        //cell.thirdStudentImage.image = UIImage(data: finalStudentData[2])
        
        
        
        
        //tableView.reloadData()
//        cell.secondStudentImage.image = UIImage(named: studentImage[1])
//        cell.thirdStudentImage.image = UIImage(named: studentImage[2])
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    // MARK:- UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        if indexPath.section == 0 {
//            let scope: FSCalendarScope = (indexPath.row == 0) ? .month : .week
//            //self.calendar.setScope(scope, animated: self.animationSwitch.isOn)
//            self.calendar.setScope(scope, animated: true)
//        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    

}


