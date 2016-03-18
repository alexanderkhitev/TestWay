//
//  DataManager.swift
//  TestWay
//
//  Created by Alexsander  on 3/18/16.
//  Copyright © 2016 Alexsander Khitev. All rights reserved.
//

import UIKit
import Foundation
import DATAStack
import Sync
import MBProgressHUD

public class DataManager {
    
    // MARK: - var and let
    private let bundle = NSBundle.mainBundle()
    private let appDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
    private var dataStack: DATAStack! {
        return appDelegate.dataStack
    }
    
    public func saveData(view: UIView?) {
        if let _view = view {
            let progress = MBProgressHUD.showHUDAddedTo(_view, animated: true)
            progress.mode = .Indeterminate
            progress.removeFromSuperViewOnHide = true
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                self.save()
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    progress.hide(true)
                })
            })
        }
    }
    
    private func save() {
        guard let jsonPath = bundle.pathForResource("allStations", ofType: "json") else { return }
        guard let jsonData = NSData(contentsOfFile: jsonPath) else { return }
        
        let json = try! NSJSONSerialization.JSONObjectWithData(jsonData, options: .AllowFragments) as! [String : AnyObject]
        
        if let departureCity = json["citiesFrom"] as? [[String: AnyObject]] {
            let key = departureCity.first!.keys
            print(key)
            Sync.changes(departureCity, inEntityNamed: "DepartureCity", dataStack: dataStack) { (error) -> Void in
                if error != nil {
                    print(error?.localizedDescription)
                }
            }
        } else {
            print("there is an error in departureCity")
        }
        
        if let hostCity = json["citiesTo"] as? [[String : AnyObject]] {
            Sync.changes(hostCity, inEntityNamed: "HostCity", dataStack: dataStack) { (error) -> Void in
                if error != nil {
                    print(error?.localizedDescription)
                }
            }
        } else {
            print("there is an error in host city")
        }
    }
}