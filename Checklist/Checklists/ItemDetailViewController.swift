//
//  ItemDetailViewController.swift
//  Checklists
//
//  Created by Norman Lopez on 4/26/17.
//  Copyright © 2017 Razeware. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

protocol itemDetailViewControllerDelegate: class {
  func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController)
  func itemDetailViewController(_ controller: ItemDetailViewController,
                             didFinishAdding item: ChecklistItem)
  func itemDetailViewController(_ controller: ItemDetailViewController,
                            didFinishEditing item: ChecklistItem)
}

class ItemDetailViewController : UITableViewController, UITextFieldDelegate {
  
  weak var delegate: itemDetailViewControllerDelegate?
  
  var itemToEdit: ChecklistItem?
  
  var dueDate = Date()
  var datePickerVisible = false
  
  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var doneBarButton: UIBarButtonItem!
  @IBOutlet weak var shouldRemindSwitch: UISwitch!
  @IBOutlet weak var dueDateLabel: UILabel!
  
  @IBOutlet weak var datePickerCell: UITableViewCell!
  @IBOutlet weak var datePicker: UIDatePicker!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if let item = itemToEdit {
      title = "Edit Item"
      textField.text = item.text
      doneBarButton.isEnabled = true
      shouldRemindSwitch.isOn = item.shouldRemind
      dueDate = item.dueDate
    }
    
    updateDueDateLabel()
  }
  
  func updateDueDateLabel() {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    dueDateLabel.text = formatter.string(from: dueDate)
  }
  
  func showDatePicker() {
    datePickerVisible = true
    let indexPathDateRow = IndexPath(row: 1, section: 1)
    let indexPathDatePicker = IndexPath(row: 2, section: 1)
    if let dateCell = tableView.cellForRow(at: indexPathDateRow) {
      dateCell.detailTextLabel!.textColor = dateCell.detailTextLabel!.tintColor
    }
    tableView.beginUpdates()
    tableView.insertRows(at: [indexPathDatePicker], with: .fade)
    tableView.reloadRows(at: [indexPathDateRow], with: .none)
    tableView.endUpdates()
    datePicker.setDate(dueDate, animated: false)
  }
  
  func hideDatePicker() {
    if datePickerVisible {
      datePickerVisible = false
      let indexPathDateRow = IndexPath(row: 1, section: 1)
      let indexPathDatePicker = IndexPath(row: 2, section: 1)
      if let cell = tableView.cellForRow(at: indexPathDateRow) {
        cell.detailTextLabel!.textColor = UIColor(white: 0, alpha: 0.5)
      }
      tableView.beginUpdates()
      tableView.reloadRows(at: [indexPathDateRow], with: .none)
      tableView.deleteRows(at: [indexPathDatePicker], with: .fade)
      tableView.endUpdates()
    }
  }
  
  override func tableView(_ tableView: UITableView,
                          didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    textField.resignFirstResponder()
    if indexPath.section == 1 && indexPath.row == 1 {
      if !datePickerVisible {
        showDatePicker()
      } else {
        hideDatePicker()
      }
    }
  }

  @IBAction func cancel() {
    delegate?.itemDetailViewControllerDidCancel(self)
  }
  
  @IBAction func done() {
    if let item = itemToEdit {
      item.text = textField.text!
      item.shouldRemind = shouldRemindSwitch.isOn            // add this
      item.dueDate = dueDate
      item.scheduleNotification()
      delegate?.itemDetailViewController(self, didFinishEditing: item)
    } else {
      let item = ChecklistItem()
      item.text = (textField.text)!
      item.checked = false
      item.shouldRemind = shouldRemindSwitch.isOn            // add this
      item.dueDate = dueDate
      delegate?.itemDetailViewController(self, didFinishAdding: item)
    }
  }
  
  override func tableView(_ tableView: UITableView,
                          cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.section == 1 && indexPath.row == 2 {
      return datePickerCell
    } else {
      return super.tableView(tableView, cellForRowAt: indexPath)
    }
  }
  
  override func tableView(_ tableView: UITableView,
                          numberOfRowsInSection section: Int) -> Int {
    if section == 1 && datePickerVisible {
      return 3
    } else {
      return super.tableView(tableView, numberOfRowsInSection: section)
    }
  }
  
  //Now the Due Date row responds to taps, but the other rows don’t
  override func tableView(_ tableView: UITableView,
                          willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    if indexPath.section == 1 && indexPath.row == 1 {
      return indexPath
    } else {
      return nil
    }
  }
  
  override func tableView(_ tableView: UITableView,
                          indentationLevelForRowAt indexPath: IndexPath) -> Int {
    var newIndexPath = indexPath
    if indexPath.section == 1 && indexPath.row == 2 {
      newIndexPath = IndexPath(row: 0, section: indexPath.section)
    }
    return super.tableView(tableView,
                           indentationLevelForRowAt: newIndexPath)
  }
  
  override func tableView(_ tableView: UITableView,
                          heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.section == 1 && indexPath.row == 2 {
      return 217
    } else {
      return super.tableView(tableView, heightForRowAt: indexPath)
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    textField.becomeFirstResponder()
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
  
  @IBAction func dateChanged(_ datePicker: UIDatePicker) {
    dueDate = datePicker.date
    updateDueDateLabel()
  }
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    hideDatePicker()
  }
  
  @IBAction func shouldRemindToggled(_ switchControl: UISwitch) {
    textField.resignFirstResponder()
    if switchControl.isOn {
      let center = UNUserNotificationCenter.current()
      center.requestAuthorization(options: [.alert, .sound]) {
        granted, error in /* do nothing */
      }
    }
  }
  
}
