//
//  StationViewController.swift
//  TestWay
//
//  Created by Alexsander  on 3/20/16.
//  Copyright © 2016 Alexsander Khitev. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class StationInfoViewController: UIViewController {

    // MARK: - var and let
    var station: DepartureStation!
    
    // MARK: - IBOutlet
    @IBOutlet weak var stationTitleLabel: UILabel!
    @IBOutlet weak var districtTitleLabel: UILabel!
    @IBOutlet weak var regionTitleLabel: UILabel!
    @IBOutlet weak var cityTitleLabel: UILabel!
    @IBOutlet weak var countryTitleLabel: UILabel!
    
    // MARK: - Lificycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.definesPresentationContext = true
        // Do any additional setup after loading the view.
    }
    
  

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
