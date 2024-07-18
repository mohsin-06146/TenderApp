//
//  InspectionModel.swift
//  TendableApp
//
//  Created by Menti on 16/07/24.
//

import Foundation

struct Inspection: Codable{
    var inspection: InspectionModel
    
    init() {
        self.inspection = InspectionModel()
    }
}

struct InspectionModel: Codable{
    var id: Int
    var inspectionType: InspectionTypeModel
    var area: AreaModel
    var survey: SurveyModel
    
    init() {
        self.id = -100
        self.inspectionType = InspectionTypeModel(id: -100, name: "", access: "")
        self.area = AreaModel(id: -100, name: "")
        self.survey = SurveyModel(id: -100, categories: [])
    }
}

struct InspectionTypeModel: Codable{
    var id: Int
    var name: String
    var access: String
}

struct AreaModel: Codable{
    var id: Int
    var name: String
}

struct SurveyModel: Codable{
    var id: Int
    var categories: [CategoryModel]
}

struct CategoryModel: Codable{
    var id: Int
    var name: String
    var questions: [QuestionModel]
}

struct QuestionModel: Codable{
    var id: Int
    var name: String
    var answerChoices: [AnswerChoiceModel]
    var selectedAnswerChoiceId: Int?
}

struct AnswerChoiceModel: Codable{
    var id: Int
    var name: String
    var score: Double
}
