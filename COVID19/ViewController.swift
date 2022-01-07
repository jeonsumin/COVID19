//
//  ViewController.swift
//  COVID19
//
//  Created by Terry on 2022/01/07.
//

import UIKit

import Alamofire
import Charts

class ViewController: UIViewController {

    //MARK: - Properties
    @IBOutlet var totalCaseLabel: UILabel!
    @IBOutlet var newCaseLabel: UILabel!
    @IBOutlet var pieChartView: PieChartView!
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCovidOverView(completionHandler: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(result) :
                debugPrint("success : \(result)")
            case let .failure(error):
                debugPrint("error : \(error )")
            }
        })
    }

    //MARK: - function
    func fetchCovidOverView(completionHandler: @escaping (Result<CityCovidOverView, Error>) -> Void){
        let url = "https://api.corona-19.kr/korea/country/new/"
        let param = [
            "serviceKey" : "Hxvb51O8IgnKJiU4fRAcLmjoBswCh97da"
        ]
        
        AF.request(url, method: .get, parameters: param)
            .responseData(completionHandler: { response in
                switch response.result {
                case let .success(data) :
                    do {
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(CityCovidOverView.self, from: data)
                        completionHandler(.success(result))
                    }catch {
                        completionHandler(.failure(error))
                    }
                case let .failure(error):
                    completionHandler(.failure(error))
                }
            })
        
    }

}

