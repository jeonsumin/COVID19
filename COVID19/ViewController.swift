//
//  ViewController.swift
//  COVID19
//
//  Created by Terry on 2022/01/07.
//

import UIKit
import Charts

class ViewController: UIViewController {

    //MARK: - Properties
    @IBOutlet var totalCaseLabel: UILabel!
    @IBOutlet var newCaseLabel: UILabel!
    @IBOutlet var pieChartView: PieChartView!
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

