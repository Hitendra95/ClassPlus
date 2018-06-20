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

class ViewController: UIViewController,FSCalendarDelegate,FSCalendarDataSource,UITableViewDelegate,UITableViewDataSource,FSCalendarDelegateAppearance {
    
    //MARK:Initilize required variable for code
    let baseUrl = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=04dd791b6393b0ab32b7105586cbf3bc&content_type=1&per_page=3&format=json&nojsoncallback=1&tags="
    
    let daysName = [1:"Sunday",2:"Monday",3:"Tuesday",4:"Wednesday",5:"Thursday",6:"Friday",7:"Saturday"]
    
    let dayNumber = ["Sunday":1,"Monday":2,"Tuesday":3,"Wednesdy":4,"Thursday":5,"Friday":6,"Saturday":7]
    
    var selectedDayUrlInner = ["http://farm2.staticflickr.com/1784/42925195191_07cd6b2506_s.jpg","http://farm2.staticflickr.com/1829/42015969435_f670a930b8_s.jpg","http://farm2.staticflickr.com/1731/41081933130_092662d181_s.jpg"]
    var day = ""
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    var selectedDayUrlOuter = [[String]()]
    var noOfDaysSelected = 0
    
    //MARK: Connect IBOutlet of ViewController view in This File
    @IBOutlet weak var calendarHeightConstraint : NSLayoutConstraint?
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: View Did Load Function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedDayUrlOuter[0] = selectedDayUrlInner
        
        calendar.dataSource = self
        calendar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        self.calendar.scope = .week
        tableView.reloadData()
        //print("today date is : \(calendar.today)")
        //print("today Date is \(self.dateFormatter.date(from: calendar.today))")

        
    }
    
    deinit {
        print("\(#function)")
    }
    
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
       
        self.calendarHeightConstraint?.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("did select date \(self.dateFormatter.string(from: date))")
       
        let  selectedDates = calendar.selectedDates.map({self.dateFormatter.string(from: $0)})
        print("selected dates is \(selectedDates)")
        noOfDaysSelected = selectedDates.count
        day = daysName[calendar.gregorian.component(.weekday, from: date)]!
        print(baseUrl+day)
        
        //fetchImagesFromApiServer
        fetchImagesFromApiServer(url: baseUrl, dayName: day)
        
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
                
                    //MARK: fetching 3 images of a particular day
                    for i in 0...2
                    {
                        let _:JSON = JSON(response.data!)
                        let innerJson:JSON = JSON(response.data!)
                        let farm:String = innerJson["photos"]["photo"][i]["farm"].stringValue
                        let server:String = innerJson["photos"]["photo"][i]["server"].stringValue
                        let photoID:String = innerJson["photos"]["photo"][i]["id"].stringValue
                        let secret:String = innerJson["photos"]["photo"][i]["secret"].stringValue
                        let imageString = "http://farm\(farm).staticflickr.com/\(server)/\(photoID)_\(secret)_s.jpg"
                    
                        //print(imageString)
                    self.selectedDayUrlInner[i] = imageString
                     }
                    self.selectedDayUrlOuter.append(self.selectedDayUrlInner)
                   self.tableView.reloadData()
                
            }
            else
            {
                print("error is : \(String(describing: response.result.error))")
            }
    }

    }
 }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        return calendar.gregorian.component(.weekday, from: date) == 4 ? UIColor.green : UIColor.white
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        //return self.dateFormatter.string(from: calendar.today!)
        let todaysDate = dateFormatter.string(from: calendar.today!)
        return dateFormatter.date(from: todaysDate)!
    }
        
   
    
     // MARK:- UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //Todo : to online print data of 15 days

        if selectedDayUrlOuter.count < 15
        {
            return selectedDayUrlOuter.count
        }
        else
        {
            return 15
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //MARK: Initilizing value of cell in a table view

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCellOfData
        cell.subjectName.text = "Chemistry Batch-02"
        cell.totalNumberOfClassCompleted.text = "Chemistry -07"
        //MARK: Making corner Radius circular
        cell.firstStudentImage.layer.cornerRadius = cell.firstStudentImage.frame.size.width/2
        cell.firstStudentImage.clipsToBounds = true
        cell.secondStudentImage.layer.cornerRadius = cell.secondStudentImage.frame.size.width/2
        cell.secondStudentImage.clipsToBounds = true
        cell.thirdStudentImage.layer.cornerRadius = cell.thirdStudentImage.frame.size.width/2
        cell.thirdStudentImage.clipsToBounds = true
        //
        print(selectedDayUrlOuter)
        let fetchArrayOuter = selectedDayUrlOuter[indexPath.row]
        //print("fetched Array outer\(fetchArrayOuter[0])")
        for i in 0...2
        {
            if let url = URL(string: String(fetchArrayOuter[i]))
            {
                if let imageData = try? Data(contentsOf: url)
                {
                    if let image = UIImage(data: imageData)
                    {
                        if i==0
                        {
                            cell.firstStudentImage.image = image
                        }
                        else if i==1
                        {
                            cell.secondStudentImage.image = image
                        }
                        else
                        {
                            cell.thirdStudentImage.image = image
                        }
                    }
                }
            }
            
        }
        

        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
   
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    

}


