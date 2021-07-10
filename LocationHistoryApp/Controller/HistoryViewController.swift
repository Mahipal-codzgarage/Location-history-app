//
//  HistoryViewController.swift
//  LocationHistoryApp
//
//  Created by Mahipal sinh on 10/07/21.
//

import UIKit

class HistoryViewController: UIViewController {
    
    var filterDate = ""
    var arrayHistory = [MarkerModel]()
    var datePickerView = UIDatePicker()
    
    @IBOutlet weak var tblHistory: UITableView!
    @IBOutlet weak var lblNoRecord: UILabel!
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchLocationFromDB(query: "SELECT *from History")
    }
    
    //MARK: - Fetch location history from database
    func fetchLocationFromDB(query: String) {
        
        arrayHistory.removeAll()
        
        let getAddresses = DatabaseManager.shared.fetchLocationRecord(query: query)
        for data in getAddresses {
            if let getData = data as? [String: Any] {
                let markerObj = MarkerModel()
                markerObj.setMarkerDataDict(fromDictionary: getData)
                arrayHistory.append(markerObj)
            }
        }
        
        if arrayHistory.count > 0 {
            DispatchQueue.main.async {
                self.tblHistory.isHidden = false
                self.lblNoRecord.isHidden = true
                self.tblHistory.reloadData()
            }
        } else {
            DispatchQueue.main.async {
                self.tblHistory.isHidden = true
                self.lblNoRecord.isHidden = false
                self.lblNoRecord.text = "No visited places at \(self.filterDate)"
            }
        }
    }
    
    //MARK: - SetupUI
    func setupUI() {
        
        DispatchQueue.main.async {
            self.title = "History"
        }
        
        tblHistory.delegate = self
        tblHistory.dataSource = self
        tblHistory.rowHeight = UITableView.automaticDimension
        tblHistory.tableFooterView = UIView()
        
        filterDate = Date().getCurrentDateTime().0
        
        datePickerView.maximumDate = Date()
        datePickerView.datePickerMode = .date
        datePickerView.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
    }
    
    // MARK: - Datepicker Value changed
    @objc func dateChanged(_ sender: UIDatePicker) {
        
        filterDate = datePickerView.date.getCurrentDateTime().0
    }
    
    // MARK: - Filter history
    @IBAction func filterAction(_ sender: Any) {
        
        if #available(iOS 14.0, *) {
            datePickerView.preferredDatePickerStyle = .wheels
        }
        
        datePickerView.frame = CGRect(x: 20, y: datePickerView.frame.origin.y, width: datePickerView.frame.width, height: datePickerView.frame.height)
        
        DispatchQueue.main.async {
            
            let alertController = UIAlertController(title: "\t\t\t\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)
            alertController.view.addSubview(self.datePickerView)
            
            let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
                self.fetchLocationFromDB(query: "SELECT *from History where date = '\(self.filterDate)'")
            })
            let resetAction = UIAlertAction(title: "Reset", style: UIAlertAction.Style.destructive, handler:  { _ in
                self.filterDate = ""
                self.fetchLocationFromDB(query: "SELECT *from History")
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler:  { _ in
                self.filterDate = ""
            })
            alertController.addAction(okAction)
            alertController.addAction(resetAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion:{})
        }
    }
}

//MARK: - UITableView Delegate & DataSource
extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell: HistoryCell = tableView.dequeueReusableCell(withIdentifier: "history", for: indexPath) as? HistoryCell else { return UITableViewCell() }
        
        cell.selectionStyle = .none
        
        let addressObj = arrayHistory[indexPath.row]
        
        cell.lblDate.text = addressObj.date ?? ""
        cell.lblAddress.text = addressObj.address ?? ""
        cell.lblNote.text = addressObj.note !=  "" ? addressObj.note : "N/A"
        
        return cell
    }
    
    // Swipe to Delete location / Edit notes.
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        // Edit Note
        let editAction = UITableViewRowAction(style: .default, title: "Edit", handler: { (action, indexPath) in
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let editHistoryObj = storyBoard.instantiateViewController(withIdentifier: "EditViewController") as! EditViewController
            editHistoryObj.markModelObj = self.arrayHistory[indexPath.row]
            Shared.shared.pushviewController(editHistoryObj, inNavigationViewController: (UIApplication.topViewController()?.navigationController)!, animated: true)
        })
        editAction.backgroundColor = UIColor.blue
        
        // Delete location
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath) in
            
            let placeID = self.arrayHistory[indexPath.row].place_id ?? ""
            DatabaseManager.shared.deleteLocation(getPlaceId: placeID)
            self.arrayHistory.remove(at: indexPath.row)
            
            if self.arrayHistory.count == 0 {
                DispatchQueue.main.async {
                    self.tblHistory.isHidden = true
                    self.lblNoRecord.isHidden = false
                    self.lblNoRecord.text = "No visited places at \(self.filterDate)"
                }
            } else {
                DispatchQueue.main.async {
                    self.tblHistory.deleteRows(at: [indexPath], with: .automatic)
                }
            }
        })
        
        deleteAction.backgroundColor = UIColor.red
        
        return [editAction, deleteAction]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
}
