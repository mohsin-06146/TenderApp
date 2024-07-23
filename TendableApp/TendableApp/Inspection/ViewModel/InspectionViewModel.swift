//
//  InspectionViewModel.swift
//  TendableApp
//
//  Created by Menti on 16/07/24.
//

import Foundation

class InspectionViewModel{
    let dataManeger = CoreDataManager()
    
    func networkCallForGetInspections(callback: @escaping ((Inspection) -> Void)){
        let networkManager = NetworkManager()
        let url = Constants.endPoint + "inspections/start"
        networkManager.serverCallForInspectionGet(packet: NetworkPackets(method: "get", bodyParams: nil, url: url)) { error, message, response in
            DispatchQueue.main.async {
                self.deleteData()
                self.saveDataInCoreData(response: response ?? Inspection())
                let inspection = self.fetchData()
                callback(inspection)
            }
        }
    }
    
    func networkCallForSubmitInspections(inspection: Inspection, callback: @escaping ((Bool) -> Void)){
        let networkManager = NetworkManager()
        let url = Constants.endPoint + "inspections/submit"
        
        networkManager.serverCallForInspectionSubmit(packet: NetworkPacketsInspection(method: "post", inspection: inspection, url: url)) { error, message  in
            if error == .successUser{
                callback(true)
            }else{
                callback(false)
            }
        }
    }
    
    func saveIntoHistory(_ inspection: Inspection){
        let inspectionId = inspection.inspection.id
        
        //Store data in "HistoryQuestionsDB" table for all quesions result for that inspection
        var historyQuestionsDB : [String: Any] = [:]
        let categories = inspection.inspection.survey.categories
        var totalScore: Double = 0
        for category in categories {
            let categoryId = category.id
            let categoryName = category.name
            for question in category.questions {
                let questionId = question.id
                let questionName = question.name
                let answer = question.answerChoices.filter{ $0.id == question.selectedAnswerChoiceId }.first
                let resultAnswerScore = answer?.score
                let resultAnswerId = answer?.id
                let resultAnswerName = answer?.name
                totalScore = totalScore + (resultAnswerScore ?? 0.0)
                historyQuestionsDB["inspectionId"] = inspectionId
                historyQuestionsDB["categoryId"] = categoryId
                historyQuestionsDB["categoryName"] = categoryName
                historyQuestionsDB["questionId"] = questionId
                historyQuestionsDB["questionName"] = questionName
                historyQuestionsDB["resultAnswerScore"] = resultAnswerScore
                historyQuestionsDB["resultAnswerId"] = resultAnswerId
                historyQuestionsDB["resultAnswerName"] = resultAnswerName
                dataManeger.insert(entity: "HistoryQuestionsDB", objectToSave: historyQuestionsDB)
            }
        }
        
        //Store Data in "HistoryDB" table for one inspection
        var historyDB: [String: Any] = [:]
        let inspectionName = inspection.inspection.inspectionType.name
        let areaName = inspection.inspection.area.name
        let areaId = inspection.inspection.area.id
        historyDB["inspectionId"] = inspectionId
        historyDB["inspectionName"] = inspectionName
        historyDB["areaName"] = areaName
        historyDB["areaId"] = areaId
        historyDB["totalScore"] = totalScore
        dataManeger.insert(entity: "HistoryDB", objectToSave: historyDB)
    }
    
    func saveDataInCoreData(response: Inspection){
        let inspection = response.inspection
        
        //Inspection DB
        let inspectionDB: [String: Any] = [
            "inspectionId": inspection.id,
            "inspectionTypeId": inspection.inspectionType.id,
            "inspectionName": inspection.inspectionType.name,
            "inspectionAccess": inspection.inspectionType.access,
            "areaId": inspection.area.id,
            "areaName": inspection.area.name,
            "surveyId": inspection.survey.id
        ]
        dataManeger.insert(entity: "InspectionDB", objectToSave: inspectionDB)
        
        //Catagories DB
        for category in inspection.survey.categories{
            let categoryDB: [String: Any] = [
                "categoryId": category.id,
                "categoryName": category.name,
                "inspectionId": inspection.id
            ]
            dataManeger.insert(entity: "CategoriesDB", objectToSave: categoryDB)
            
            //Questions DB
            for question in category.questions{
                let questionsDB: [String: Any] = [
                    "questionId": question.id,
                    "questionName": question.name,
                    "selectedAnswerChoiceId": question.selectedAnswerChoiceId ?? -100,
                    "categoryId": category.id
                ]
                dataManeger.insert(entity: "QuestionsDB", objectToSave: questionsDB)
                
                //Answers DB
                for answer in question.answerChoices{
                    let answersDB: [String: Any] = [
                        "answerId": answer.id,
                        "answerName": answer.name,
                        "answerScore": answer.score,
                        "questionId": question.id
                    ]
                    dataManeger.insert(entity: "AnswersDB", objectToSave: answersDB)
                }
            }
        }
    }
    
    func fetchData() -> Inspection{
        let inspectionDB = dataManeger.fetchAllData(entityName: "InspectionDB", parameter: InspectionDB.self).first
        let categoryDB = dataManeger.fetchAllData(entityName: "CategoriesDB", parameter: CategoriesDB.self)
        let questionsDB = dataManeger.fetchAllData(entityName: "QuestionsDB", parameter: QuestionsDB.self)
        let answersDB = dataManeger.fetchAllData(entityName: "AnswersDB", parameter: AnswersDB.self)
        var inspection = Inspection()
        var inspectionModel = InspectionModel()
        inspectionModel.id = Int(inspectionDB?.inspectionId ?? -100)
        let inspectionType = InspectionTypeModel(id: Int(inspectionDB?.inspectionTypeId ?? -100), name: inspectionDB?.inspectionName ?? "", access: inspectionDB?.inspectionAccess ?? "")
        inspectionModel.inspectionType = inspectionType
        let area = AreaModel(id: Int(inspectionDB?.areaId ?? -100), name: inspectionDB?.areaName ?? "")
        inspectionModel.area = area
        var survey = SurveyModel(id: Int(inspectionDB?.surveyId ?? -100), categories: [])
        var categories = [CategoryModel]()
        for category in categoryDB.filter({ $0.inspectionId == inspectionDB?.inspectionId }){
            var categoryModel = CategoryModel(id: Int(category.categoryId), name: category.categoryName ?? "", questions: [])
            var questions = [QuestionModel]()
            for question in questionsDB.filter({ $0.categoryId == category.categoryId }){
                var questionModel = QuestionModel(id: Int(question.questionId), name: question.questionName ?? "", answerChoices: [], selectedAnswerChoiceId: Int(question.selectedAnswerChoiceId))
                var answers = [AnswerChoiceModel]()
                for answer in answersDB.filter({ $0.questionId == question.questionId }){
                    let answerChoices = AnswerChoiceModel(id: Int(answer.answerId), name: answer.answerName ?? "", score: answer.answerScore)
                    answers.append(answerChoices)
                }
                questionModel.answerChoices = answers
                questions.append(questionModel)
            }
            categoryModel.questions = questions
            categories.append(categoryModel)
        }
        survey.categories = categories
        inspectionModel.survey = survey
        inspection.inspection = inspectionModel
        return inspection
    }
    
    func deleteData(){
        dataManeger.deleteRecordFromDatabase(entityName: "InspectionDB")
        dataManeger.deleteRecordFromDatabase(entityName: "CategoriesDB")
        dataManeger.deleteRecordFromDatabase(entityName: "QuestionsDB")
        dataManeger.deleteRecordFromDatabase(entityName: "AnswersDB")
    }
    
    func updateData(questionId: Int, categoryId: Int, selectedAnswerChoiceId: Int){
        dataManeger.updateAnswers(questionId: questionId, categoryId: categoryId, selectedAnswerChoiceId: selectedAnswerChoiceId)
    }
}
