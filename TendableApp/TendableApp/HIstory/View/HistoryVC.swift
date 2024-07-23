//
//  HistoryVC.swift
//  TendableApp
//
//  Created by Menti on 23/07/24.
//

import UIKit

class HistoryVC: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var tblView: UITableView!
    
    //MARK: - Variables & Constants
    var viewModel: HistoryViewModel = HistoryViewModel()
    var historyDB: [HistoryDB] = []
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.historyDB = self.viewModel.getInspectionsData()
        self.tblView.register(UINib(nibName: "HistoryHeaderCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "HistoryHeaderCell")
        self.tblView.register(UINib(nibName: "HistoryCell", bundle: nil), forCellReuseIdentifier: "HistoryCell")
        DispatchQueue.main.async {
            self.tblView.reloadData()
        }
    }
}

extension HistoryVC: UITableViewDelegate, UITableViewDataSource{
    public func numberOfSections(in tableView: UITableView) -> Int {
        return self.historyDB.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HistoryHeaderCell") as? HistoryHeaderCell
        let history = self.historyDB[section]
        header?.lblInspectionId.text = "\(history.inspectionId)"
        header?.lblInspectionTypeName.text = history.inspectionName
        header?.lblAreaName.text = history.areaName
        header?.lblTotalScore.text = "\(history.totalScore)"
        return header
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let history = historyDB[section]
        let questions = viewModel.getQuestionsForInspection(inspectionId: Int(history.inspectionId))
        return questions.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as? HistoryCell
        let history = historyDB[indexPath.section]
        let questions = viewModel.getQuestionsForInspection(inspectionId: Int(history.inspectionId))
        let question = questions[indexPath.row]
        cell?.lblCategory.text = question.categoryName
        cell?.lblScore.text = "\(question.resultAnswerScore)"
        cell?.lblQuestion.text = question.questionName
        cell?.lblAnswer.text = question.resultAnswerName
        return cell ?? UITableViewCell()
    }
}
