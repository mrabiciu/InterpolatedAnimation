//
//  ViewController.swift
//  Animation
//
//  Created by Max on 3/5/17.
//  Copyright © 2017 Maxim Rabiciuc. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell()
    cell.accessoryType = .disclosureIndicator
    cell.textLabel?.font = UIFont.systemFont(ofSize: 18)
    switch indexPath.row {
    case 0:
      cell.textLabel?.text = "Simple example"
      return cell
    case 1:
      cell.textLabel?.text = "Simple example ObjC"
      return cell
    case 2:
      cell.textLabel?.text = "Autolayout gesture example"
      return cell
    case 3:
      cell.textLabel?.text = "Production example"
      return cell
    default:
      return cell
    }
  }

  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 4
  }

  let tableView = UITableView()
  override func loadView() {
    title = "Examples"
    view = tableView
    tableView.dataSource = self
    tableView.delegate = self
    tableView.reloadData()
  }
  
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    switch indexPath.row {
    case 0: navigationController?.pushViewController(BoxController(), animated: true)
    case 1: navigationController?.pushViewController(ObjCBoxController(), animated: true)
    case 2: navigationController?.pushViewController(StackController(), animated: true)
    case 3: navigationController?.pushViewController(NooberViewController(), animated: true)
    default: break
    }
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 80
  }
}
