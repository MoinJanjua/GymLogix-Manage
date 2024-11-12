//
//  DashboardViewController.swift
//  GymLogix Manage
//
//  Created by Farrukh on 03/11/2024.
//

import UIKit

class DashboardViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
   
    
    @IBOutlet weak var CollectionView: UICollectionView!
    @IBOutlet weak var todayssalelbl: UILabel!
    @IBOutlet weak var currentmonthsalelbl: UILabel!
    @IBOutlet weak var todaysadmissionlbl: UILabel!
    @IBOutlet weak var totalmembers: UILabel!
    @IBOutlet weak var currentmonthsaleamountlbl: UILabel!
    @IBOutlet weak var todaysaleamountlbl: UILabel!
    
    @IBOutlet weak var curntmsview: UIView!
    @IBOutlet weak var todaysview: UIView!
    var totalAmount = 0
    var today_totalAmount = 0
    let imagesList = ["img1","img2","img3","img4","img5","img6","img7"]
    
    let titleList = [
        "Manage Members",
        "Member Records",
        "Manage Gym Expenses",
        "Gym Expense Records",
        "Sell Products",
        "Products Record",
        "Settings"
    ]

    
    override func viewDidLoad() {
        super.viewDidLoad()

        CollectionView.delegate = self
        CollectionView.dataSource = self
        CollectionView.collectionViewLayout = UICollectionViewFlowLayout()
        // Do any additional setup after loading the view.
     
        // Set today's admission count
        let todaysCount = getTodaysAdmissionsCount()
        todaysadmissionlbl.text = "Today's Admissions: \(todaysCount)"
        let currentMonthSales = getCurrentMonthSaleAmount()
        currentmonthsaleamountlbl.text = String(format: "%.2f", currentMonthSales)
        
        // Assuming `yourView` is the view you want to add a shadow to.
        curntmsview.layer.shadowColor = UIColor.black.cgColor
        curntmsview.layer.shadowOpacity = 0.5
        curntmsview.layer.shadowOffset = CGSize(width: 0, height: 2)
        curntmsview.layer.shadowRadius = 4
        curntmsview.layer.masksToBounds = false
        
        todaysview.layer.shadowColor = UIColor.black.cgColor
        todaysview.layer.shadowOpacity = 0.5
        todaysview.layer.shadowOffset = CGSize(width: 0, height: 2)
        todaysview.layer.shadowRadius = 4
        todaysview.layer.masksToBounds = false
        loadExpenseAmount()
    }
    
    
    func isToday(date: Date) -> Bool {
        let calendar = Calendar.current
        let localDate = date.convertToLocalTime()
        return calendar.isDateInToday(localDate)
    }
    
    func loadExpenseAmount() {
        if let data = UserDefaults.standard.data(forKey: "gymExpenses"),
           let decodedProfiles = try? JSONDecoder().decode([Profiles].self, from: data) {
            print(decodedProfiles)
            
            // Reset totalAmount for all-time total
            totalAmount = 0
            
            // Reset today_totalAmount for today's sales
            today_totalAmount = 0
            
            for profile in decodedProfiles {
                // Convert the date string to a Date object
              
                let profileDate = profile.date
                    // Add to totalAmount for all-time total
                    totalAmount += Int(profile.paidamount) ?? 0
                    
                    // Check if the date is today
                    if isToday(date: profileDate) {
                        today_totalAmount += Int(profile.paidamount) ?? 0
                    }
            }
            
            
        } else {
            print("No gym expenses data found.")
        }
        
        loadGymExpenses()
    }
    
    
    
    private func loadGymExpenses() 
    {
        if let data = UserDefaults.standard.data(forKey: "shogymExpenses"),
           let expenses = try? JSONDecoder().decode([gymexpense].self, from: data) {
            
            for profile in expenses {
                // Convert the date string to a Date object
                
                let profileDate = profile.date
                // Add to totalAmount for all-time total
                totalAmount += Int(profile.equipmentandmaintenance) ?? 0
                
                // Check if the date is today
                if isToday(date: profileDate) {
                    today_totalAmount += Int(profile.equipmentandmaintenance) ?? 0
                }
                
            }
            
        } else {
            
        }
        
        getSavedProducts()
        
    }
    
    private func getSavedProducts() 
    {
        if let data = UserDefaults.standard.data(forKey: "soldProducts"),
           let products = try? JSONDecoder().decode([sellproduct].self, from: data) {
            
            for profile in products {
                // Convert the date string to a Date object
              
                let profileDate = profile.date
                    // Add to totalAmount for all-time total
                    totalAmount += Int(profile.amount) ?? 0
                    
                    // Check if the date is today
                    if isToday(date: profileDate) {
                        today_totalAmount += Int(profile.amount) ?? 0
                    }
                
            }

        }
        displayTotalMembersCount()
        displayTodaysSaleAmount()
    }


    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        displayTotalMembersCount()
        displayTodaysSaleAmount()
        updateCurrentMonthSaleLabel() 

    }
    
    func getTodaysAdmissionsCount() -> Int {
        // Retrieve the saved profiles from UserDefaults
        guard let data = UserDefaults.standard.data(forKey: "gymExpenses"),
              let profiles = try? JSONDecoder().decode([Profiles].self, from: data) else {
            return 0 // No data found, return 0
        }
        
        // Get today's date without time components
        let today = Calendar.current.startOfDay(for: Date())
        
        // Count profiles added today
        let todaysCount = profiles.filter { Calendar.current.isDate($0.date, inSameDayAs: today) }.count
        
        return todaysCount
    }


    func displayTotalMembersCount() {
            let totalCount = getProfileCount()
            totalmembers.text = "Total Members: \(totalCount)"
        }
    func getProfileCount() -> Int {
            // Load profiles from UserDefaults
            if let data = UserDefaults.standard.data(forKey: "gymExpenses"),
               let profiles = try? JSONDecoder().decode([Profiles].self, from: data) {
                return profiles.count
            }
            return 0
        }

       func getTodaysSalesCount() -> Int {
           guard let data = UserDefaults.standard.data(forKey: "soldProducts"),
                 let products = try? JSONDecoder().decode([sellproduct].self, from: data) else {
               return 0
           }
           
           let today = Calendar.current.startOfDay(for: Date())
           return products.filter { Calendar.current.isDate($0.date, inSameDayAs: today) }.count
       }


    func getCurrentMonthSalesCount() -> Int {
        guard let data = UserDefaults.standard.data(forKey: "soldProducts"),
              let soldProducts = try? JSONDecoder().decode([sellproduct].self, from: data) else {
            return 0
        }
        
        let currentMonth = Calendar.current.component(.month, from: Date())
        let currentYear = Calendar.current.component(.year, from: Date())
        
        // Filter products by the current month and year
        let currentMonthSales = soldProducts.filter {
            let productMonth = Calendar.current.component(.month, from: $0.date)
            let productYear = Calendar.current.component(.year, from: $0.date)
            return productMonth == currentMonth && productYear == currentYear
        }
        
        return currentMonthSales.count
    }
    // Function to display today's sale amount
    func displayTodaysSaleAmount() {
        
        let formattedAmount = Double(today_totalAmount)
        todaysaleamountlbl.text = "$" + String(format: "%.2f", formattedAmount)
    }

    func getTodaysSaleAmount() -> Double 
    {
        guard let data = UserDefaults.standard.data(forKey: "soldProducts"),
              let soldProducts = try? JSONDecoder().decode([sellproduct].self, from: data) else {
            return 0.0
        }
        
        let today = Calendar.current.startOfDay(for: Date())
        
        // Filter products by today's date and sum their amounts
        let todaysSalesAmount = soldProducts
            .filter { Calendar.current.isDate($0.date, inSameDayAs: today) }
            .reduce(0.0) { total, product in
                total + (Double(product.amount) ?? 0.0)
            }
        
        return todaysSalesAmount
    }
    
    
    func getCurrentMonthSaleAmount() -> Double {
        guard let data = UserDefaults.standard.data(forKey: "soldProducts"),
              let soldProducts = try? JSONDecoder().decode([sellproduct].self, from: data) else {
            return 0.0
        }
        
        let currentDate = Date()
        let currentYear = Calendar.current.component(.year, from: currentDate)
        let currentMonth = Calendar.current.component(.month, from: currentDate)
        
        // Filter products by current month and sum their amounts
        let currentMonthSalesAmount = soldProducts
            .filter {
                let saleYear = Calendar.current.component(.year, from: $0.date)
                let saleMonth = Calendar.current.component(.month, from: $0.date)
                return saleYear == currentYear && saleMonth == currentMonth
            }
            .reduce(0.0) { total, product in
                total + (Double(product.amount) ?? 0.0)
            }
        
        return currentMonthSalesAmount
    }
    
    
    func updateCurrentMonthSaleLabel() 
    {
        let currentMonthSales = getCurrentMonthSaleAmount()
        let amount = totalAmount + Int(currentMonthSales)
        let formattedAmount = Double(amount)
        currentmonthsaleamountlbl.text = "$" + String(format: "%.2f", formattedAmount)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesList.count
    }
    
    @IBAction func expensebutton(_ sender: UIButton) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "ShowGymExpViewController") as! ShowGymExpViewController
        //newViewController.record = names[indexPath.row]
        newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        newViewController.modalTransitionStyle = .crossDissolve
        self.present(newViewController, animated: true, completion: nil)
    }
    
    @IBAction func seesellproduct(_ sender: UIButton) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "SeeDetailSellPViewController") as! SeeDetailSellPViewController
        //newViewController.record = names[indexPath.row]
        newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        newViewController.modalTransitionStyle = .crossDissolve
        self.present(newViewController, animated: true, completion: nil)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! DashboardCollectionViewCell
        
        cell.titlimg.image = UIImage(named: imagesList[indexPath.row])
        cell.titlelbl
            .text = titleList[indexPath.row]
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.layer.borderWidth = 1
        cell.contentView.layer.borderColor = UIColor.black.cgColor
        cell.contentView.clipsToBounds = true
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        if indexPath.item == 0
        {
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "GenderViewController") as! GenderViewController
            //newViewController.record = names[indexPath.row]
            newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            newViewController.modalTransitionStyle = .crossDissolve
            self.present(newViewController, animated: true, completion: nil)
        }
        if indexPath.item == 1
        {
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "HistoryViewController") as! HistoryViewController
            //newViewController.record = names[indexPath.row]
            newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            newViewController.modalTransitionStyle = .crossDissolve
            self.present(newViewController, animated: true, completion: nil)
        }
        if indexPath.item == 2
       {
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "GymExpenseViewController") as! GymExpenseViewController
            //newViewController.record = names[indexPath.row]
            newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            newViewController.modalTransitionStyle = .crossDissolve
            self.present(newViewController, animated: true, completion: nil)
       }
        if indexPath.item == 3
        {
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "ShowGymExpViewController") as! ShowGymExpViewController
            //newViewController.record = names[indexPath.row]
            newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            newViewController.modalTransitionStyle = .crossDissolve
            self.present(newViewController, animated: true, completion: nil)
        }
        if indexPath.item == 4
        {
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "SellProductViewController") as! SellProductViewController
            //newViewController.record = names[indexPath.row]
            newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            newViewController.modalTransitionStyle = .crossDissolve
            self.present(newViewController, animated: true, completion: nil)
        }
        if indexPath.item == 5
        {
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "SeeDetailSellPViewController") as! SeeDetailSellPViewController
            //newViewController.record = names[indexPath.row]
            newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            newViewController.modalTransitionStyle = .crossDissolve
            self.present(newViewController, animated: true, completion: nil)
        }
        if indexPath.item == 6
        {
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
            //newViewController.record = names[indexPath.row]
            newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            newViewController.modalTransitionStyle = .crossDissolve
            self.present(newViewController, animated: true, completion: nil)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.bounds.width
        let spacing: CGFloat = 10
        let availableWidth = collectionViewWidth - (spacing * 3)
        let width = availableWidth / 2
        return CGSize(width: width - 20, height: 130)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10 // Adjust as needed
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20) // Adjust as needed
    }

}


extension Date {
    func convertToLocalTime() -> Date {
        let timeZone = TimeZone.current
        let seconds = timeZone.secondsFromGMT(for: self)
        return self.addingTimeInterval(TimeInterval(seconds))
    }
}
