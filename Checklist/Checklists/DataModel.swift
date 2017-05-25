//
//  DataModel.swift
//  Checklists
//
//  Created by Norman Lopez on 5/3/17.
//  Copyright © 2017 Razeware. All rights reserved.
//

import UIKit
import Foundation

class DataModel {
    var lists = [Checklist]()
  
  init() {
    loadChecklists()
    registerDefaults()
    handleFirstTime()
  }
  
  var indexOfSelectedChecklist: Int {
    get {
      return UserDefaults.standard.integer(forKey: "ChecklistIndex")
    }
    set {
      UserDefaults.standard.set(newValue, forKey: "ChecklistIndex")
    }
  }
  
  
  func documentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory,
                                         in: .userDomainMask)
    return paths[0]
  }
  
  func dataFilePath() -> URL {
    return documentsDirectory().appendingPathComponent("Checklists.plist")
  }
  // this method is now called saveChecklists()
  func saveChecklists() {
    let data = NSMutableData()
    let archiver = NSKeyedArchiver(forWritingWith: data)
    // this line is different from before
    archiver.encode(lists, forKey: "Checklists")
    archiver.finishEncoding()
    data.write(to: dataFilePath(), atomically: true)
  }
  // this method is now called loadChecklists()
  func loadChecklists() {
    let path = dataFilePath()
    if let data = try? Data(contentsOf: path) {
      let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
      // this line is different from before
      lists = unarchiver.decodeObject(forKey: "Checklists") as! [Checklist]
      unarchiver.finishDecoding()
      sortChecklists()
    }
  }
  
  func registerDefaults() {
    let dictionary: [String: Any] = [ "ChecklistIndex": -1,
                                      "FirstTime": true,
                                      "ChecklistItemID": 0 ]
    UserDefaults.standard.register(defaults: dictionary)
  }
  
  func handleFirstTime() {
    let userDefaults = UserDefaults.standard
    let firstTime = userDefaults.bool(forKey: "FirstTime")
    if firstTime {
      let checklist = Checklist(name: "List")
      lists.append(checklist)
      indexOfSelectedChecklist = 0
      userDefaults.set(false, forKey: "FirstTime")
      userDefaults.synchronize()
    }
  }
  
  func sortChecklists() {
    lists.sort(by: { checklist1, checklist2 in
      return checklist1.name.localizedStandardCompare(checklist2.name) ==
        .orderedAscending })
  }
  
  class func nextChecklistItemID() -> Int {
    let userDefaults = UserDefaults.standard
    let itemID = userDefaults.integer(forKey: "ChecklistItemID")
    userDefaults.set(itemID + 1, forKey: "ChecklistItemID")
    userDefaults.synchronize()
    return itemID
  }
}
