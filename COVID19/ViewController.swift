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
    @IBOutlet var labelStackView: UIStackView!
    @IBOutlet var indicatorView: UIActivityIndicatorView!
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //데이터 세팅 전 indicator 실행
        indicatorView.startAnimating()

        // Alamofire를 통해서 COVID19 API 호출하여 화면에 세팅
        fetchCovidOverView(completionHandler: { [weak self] result in
            //self 참조
            guard let self = self else { return }

            self.indicatorView.stopAnimating()
            self.indicatorView.isHidden = true
            self.labelStackView.isHidden = false
            self.pieChartView.isHidden = false
            
            switch result {
            case let .success(result) :
                self.configureStackView(koreaCovidOverView: result.korea)
                let covidOverViewList = self.makeCovidOverViewList(cityCovidOverView: result)
                // 차트 구성
                self.configureChartView(covidOverViewList: covidOverViewList)
            case let .failure(error):
                debugPrint("error : \(error )")
            }
        })
    }

    //MARK: - function
                                                //@escaping Escaping 클로저는 클로저가 함수의 인자로 전달됐을 때, 함수의 실행이 종료된 후 실행되는 클로저 
    func fetchCovidOverView(completionHandler: @escaping (Result<CityCovidOverView, Error>) -> Void){
        let url = "https://api.corona-19.kr/korea/country/new/"
        let param = [
            "serviceKey" : "Hxvb51O8IgnKJiU4fRAcLmjoBswCh97da"
        ]
        //Alamofire를 활용하여 COVID19 API 통신 
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
    
    func configureStackView(koreaCovidOverView: CovidOverView){
        totalCaseLabel.text = "\(koreaCovidOverView.totalCase) 명"
        newCaseLabel.text = "\(koreaCovidOverView.newCase) 명"
    }
    // 차트에 사용될 COVID List 세팅
    func makeCovidOverViewList(cityCovidOverView: CityCovidOverView) -> [CovidOverView] {
        return [
            cityCovidOverView.seoul,
            cityCovidOverView.busan,
            cityCovidOverView.daegu,
            cityCovidOverView.incheon,
            cityCovidOverView.gwangju,
            cityCovidOverView.daegu,
            cityCovidOverView.daejeon,
            cityCovidOverView.ulsan,
            cityCovidOverView.sejong,
            cityCovidOverView.gyeonggi,
            cityCovidOverView.chungbuk,
            cityCovidOverView.chungnam,
            cityCovidOverView.gyeongbuk,
            cityCovidOverView.gyeongnam,
            cityCovidOverView.jeju,
        ]
    }

    //차트 구성
    func configureChartView(covidOverViewList: [CovidOverView]){
        pieChartView.delegate = self
        
        let entries = covidOverViewList.compactMap { [weak self] overview -> PieChartDataEntry? in
            guard let self = self else { return nil }
            return PieChartDataEntry(value: self.removeformatString(string: overview.newCase),
                                     label: overview.countryName,
                                     data: overview)
        }
        let dataSet = PieChartDataSet(entries: entries, label: "코로나 발생 현황")
        
        dataSet.sliceSpace = 1
        dataSet.entryLabelColor = .black
        dataSet.valueTextColor = .black
        dataSet.xValuePosition = .outsideSlice
        dataSet.valueLinePart1OffsetPercentage = 0.8
        dataSet.valueLinePart1Length = 0.2
        dataSet.valueLinePart2Length = 0.3
        
        dataSet.colors = ChartColorTemplates.vordiplom() +
        ChartColorTemplates.joyful() +
        ChartColorTemplates.liberty() +
        ChartColorTemplates.pastel() +
        ChartColorTemplates.material()
        
        self.pieChartView.data = PieChartData(dataSet: dataSet)
        
        self.pieChartView.spin(duration: 0.3, fromAngle: self.pieChartView.rotationAngle, toAngle: self.pieChartView.rotationAngle + 80)
    }
    
    func removeformatString(string: String) -> Double {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.number(from: string)?.doubleValue ?? 0
    }
}
// Chart Delegate를 채택
extension ViewController: ChartViewDelegate {
    //차트 선택시 디테일 뷰로 이동할 수 있도록 설정
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        guard let covidDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "CovidDetailViewController") as? CovidDetailViewController else { return }
        guard let covidOverView = entry.data as? CovidOverView else { return }
        covidDetailViewController.covidOverView = covidOverView
        navigationController?.pushViewController(covidDetailViewController, animated: true)
    }
}
