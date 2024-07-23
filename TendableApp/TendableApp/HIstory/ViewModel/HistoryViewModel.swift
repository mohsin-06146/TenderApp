//
//  HistoryViewModel.swift
//  TendableApp
//
//  Created by Menti on 23/07/24.
//

import Foundation

class HistoryViewModel{
 
    let dataManager = CoreDataManager()
    
    func getInspectionsData() -> [HistoryDB]{
        let history = dataManager.fetchAllData(entityName: "HistoryDB", parameter: HistoryDB.self)
        return history
    }
    
    func getQuestionsForInspection(inspectionId: Int) -> [HistoryQuestionsDB]{
        let questions = dataManager.fetchAllDataForInspection(inspectionId: inspectionId, entityName: "HistoryQuestionsDB", parameter: HistoryQuestionsDB.self)
        return questions
    }
}
