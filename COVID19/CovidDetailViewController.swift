//
//  CovidDetailViewController.swift
//  COVID19
//
//  Created by Terry on 2022/01/07.
//

import UIKit

class CovidDetailViewController: UITableViewController {
    //MARK: - Properties
    @IBOutlet var newCaseCell: UITableViewCell!
    @IBOutlet var totalCaseCell: UITableViewCell!
    @IBOutlet var recoveredCell: UITableViewCell!
    @IBOutlet var deathCell: UITableViewCell!
    @IBOutlet var percentageCell: UITableViewCell!
    @IBOutlet var overseasInflowCell: UITableViewCell!
    @IBOutlet var regionalOutbreakCell: UITableViewCell!
    
    var covidOverView: CovidOverView?
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    //MARK: - Function
    func configureView(){
        guard let covidOverView = covidOverView else { return }

        title = covidOverView.countryName
        newCaseCell.detailTextLabel?.text = "\(covidOverView.newCase) 명"
        totalCaseCell.detailTextLabel?.text = "\(covidOverView.totalCase) 명"
        recoveredCell.detailTextLabel?.text = "\(covidOverView.recovered) 명"
        deathCell.detailTextLabel?.text = "\(covidOverView.death) 명"
        percentageCell.detailTextLabel?.text = "\(covidOverView.percentage) %"
        overseasInflowCell.detailTextLabel?.text = "\(covidOverView.newFcase) 명"
        regionalOutbreakCell.detailTextLabel?.text = "\(covidOverView.newCcase) 명"
    }
}
