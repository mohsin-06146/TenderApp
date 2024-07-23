//
//  InspectionVC.swift
//  TendableApp
//
//  Created by Menti on 16/07/24.
//

import UIKit

class InspectionVC: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var lblInspactionName: UILabel!
    @IBOutlet weak var lblAreaName: UILabel!
    @IBOutlet weak var tblView: UITableView!
    
    //MARK: - Variables and Constants
    let viewModel = InspectionViewModel()
    var inspection = Inspection()
    var isFromStart: Bool = true
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if isFromStart{
            self.getInspections()
        }else{
            self.reloadTable()
        }
        
        self.tblView.register(UINib(nibName: "InspectionCell", bundle: nil), forCellReuseIdentifier: "InspectionCell")
    }
    
    //MARK: - Button Actions
    @IBAction func btnSubmitTapped(_ sender: UIButton){
        viewModel.networkCallForSubmitInspections(inspection: self.inspection) { success in
            if success{
                var user = Constants.shared.currentUser
                user.isInDraft = false
                Constants.shared.currentUser = user
                Constants.shared.setUserDetails(user: user)
                DispatchQueue.main.async {
                    let fileName = "\"inspection\(self.inspection.inspection.id).json\""
                    let alert = UIAlertController(title: Constants.appName, message:  "\(fileName) \(Messages.inspectionSubmit)", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: Messages.ok, style: .default, handler: { action in
                        self.viewModel.saveIntoHistory(self.inspection)
                        self.navigationController?.popViewController(animated: true)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    @IBAction func btnDraftTapped(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Custom Functions
    func getInspections(){
        viewModel.networkCallForGetInspections { inspection in
            self.inspection = inspection
            self.setData()
        }
    }
    
    func setData(){
        DispatchQueue.main.async {
            self.lblInspactionName.text = self.inspection.inspection.inspectionType.name
            self.lblAreaName.text = self.inspection.inspection.area.name
            self.tblView.reloadData()
        }
    }
    
    func reloadTable(){
        self.inspection = viewModel.fetchData()
        self.setData()
    }
}

extension InspectionVC: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.inspection.inspection.survey.categories.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let category = self.inspection.inspection.survey.categories[section]
        return category.questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InspectionCell", for: indexPath) as? InspectionCell
        
        let category = self.inspection.inspection.survey.categories[indexPath.section]
        let question = category.questions[indexPath.row]
        cell?.lblQuesion.text = question.name
        
        let answers = question.answerChoices
        if let selectedAnswer = answers.filter({ $0.id == question.selectedAnswerChoiceId }).first{
            cell?.lblAnswer.text = selectedAnswer.name
        }else{
            cell?.lblAnswer.text = Messages.selectAnswer
        }
        
        var actions = [UIAction]()
        for answer in answers{
            let action = UIAction(title: answer.name) { action in
                self.viewModel.updateData(questionId: question.id, categoryId: category.id, selectedAnswerChoiceId: answer.id)
                self.reloadTable()
            }
            actions.append(action)
        }
        let menu = UIMenu(title: Messages.options, children: actions)
        cell?.btnOptions.menu = menu
        cell?.btnOptions.showsMenuAsPrimaryAction = true
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let category = self.inspection.inspection.survey.categories[section]
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 60))
        
        let label = UILabel()
        label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
        label.text = category.name
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        
        headerView.addSubview(label)
        
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
}
