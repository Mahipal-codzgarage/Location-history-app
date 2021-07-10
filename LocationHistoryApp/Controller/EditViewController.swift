//
//  EditViewController.swift
//  LocationHistoryApp
//
//  Created by Mahipal sinh on 10/07/21.
//

import UIKit

class EditViewController: UIViewController {
    
    var markModelObj: MarkerModel?
    
    @IBOutlet weak var txtNotes: UITextView!
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - SetupUI
    func setupUI() {
        
        DispatchQueue.main.async {
            self.title = "Notes"
            
            let btnSave = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(self.saveNote))
            self.navigationItem.rightBarButtonItem  = btnSave
            
            self.txtNotes.text = self.markModelObj?.note ?? ""
            self.txtNotes.layer.borderWidth = 1
            self.txtNotes.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    
    // MARK: - Save new note
    @objc func saveNote() {
        
        DatabaseManager.shared.updateNote(getNote: txtNotes.text ?? "", placeId: markModelObj?.place_id ?? "")
        self.navigationController?.popViewController(animated: true)
    }
}
