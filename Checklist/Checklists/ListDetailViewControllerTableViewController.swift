//
//  ListDetailViewControllerTableViewController.swift
//  Checklists
//
//  Created by Norman Lopez on 5/1/17.
//  Copyright © 2017 Razeware. All rights reserved.
//

import UIKit

//
//  ItemDetailViewController.swift
//  Checklists
//
//  Created by Norman Lopez on 4/26/17.
//  Copyright © 2017 Razeware. All rights reserved.
//

import Foundation
import UIKit

protocol ListDetailViewViewControllerDelegate: class {
  func listDetailViewControllerDidCancel(_ controller: ListDetailViewController)
  func listDetailViewController(_ controller: ListDetailViewController,
                                didFinishAdding checklist: Checklist)
  func listDetailViewController(_ controller: ListDetailViewController,
                                didFinishEditing checklist: Checklist)
}

class ListDetailViewController : UITableViewController, UITextFieldDelegate, IconPickerViewControllerDelegate {
  
  weak var delegate: ListDetailViewViewControllerDelegate?
  var iconName = "Folder"
  
  @IBOutlet weak var iconImageView: UIImageView!
  var checklistToEdit: Checklist?
  
  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var doneBarButton: UIBarButtonItem!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let checklist = checklistToEdit {
      title = "Edit Checklist"
      doneBarButton.isEnabled = true
      textField.text = checklist.name
      iconName = checklist.iconName
    }
    iconImageView.image = UIImage(named: iconName)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    textField.becomeFirstResponder()
  }
  
  @IBAction func cancel() {
    delegate?.listDetailViewControllerDidCancel(self)
  }
  
  @IBAction func done() {
    if let checklist = checklistToEdit {
      checklist.name = textField.text!
      checklist.iconName = iconName
      delegate?.listDetailViewController(self,
                                         didFinishEditing: checklist)
    } else {
      let checklist = Checklist(name: textField.text!)
      checklist.iconName = iconName 
      delegate?.listDetailViewController(self,
                                         didFinishAdding: checklist)
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "PickIcon" {
      let controller = segue.destination as! IconPickerViewController
      controller.delegate = self
    }
  }
  
  override func tableView(_ tableView: UITableView,
                          willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    if indexPath.section == 1 {
      return indexPath
    } else {
      return nil
    }
  }
  
  func textField(_ textField: UITextField,
                 shouldChangeCharactersIn range: NSRange,
                 replacementString string: String) -> Bool {
    let oldText = textField.text! as NSString
    let newText = oldText.replacingCharacters(in: range, with: string) as NSString
    if newText.length > 0 {
      doneBarButton.isEnabled = true
    } else {
      doneBarButton.isEnabled = false
    }
    return true
  }
  
  func iconPicker(_ picker: IconPickerViewController,
                  didPick iconName: String) {
    self.iconName = iconName
    iconImageView.image = UIImage(named: iconName)
    let _ = navigationController?.popViewController(animated: true)
  }
}
