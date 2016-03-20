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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        setLabels()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - functions
    private func setLabels() {
        guard let stationTitle = station.stationTitle else { return }
        stationTitleLabel.text = "Станция: \(stationTitle)"
        stationTitleLabel.adjustsFontSizeToFitWidth = true
        guard let districtTitle = station.districtTitle else { return }
        districtTitleLabel.text = "Район: \(districtTitle)"
        districtTitleLabel.adjustsFontSizeToFitWidth = true
        guard let regionTitle = station.regionTitle else { return }
        regionTitleLabel.text = "Регион: \(regionTitle)"
        regionTitleLabel.adjustsFontSizeToFitWidth = true
        guard let cityTitle = station.cityTitle else { return }
        cityTitleLabel.text = "Город: \(cityTitle)"
        cityTitleLabel.adjustsFontSizeToFitWidth = true
        guard let countryTitle = station.countryTitle else { return }
        countryTitleLabel.text = "Страна: \(countryTitle)"
        countryTitleLabel.adjustsFontSizeToFitWidth = true
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
