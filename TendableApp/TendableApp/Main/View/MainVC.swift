//
//  MainVC.swift
//  TendableApp
//
//  Created by Menti on 16/07/24.
//

import UIKit

class MainVC: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var btnResume: UIButton!
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if Constants.shared.currentUser.isInDraft{
            self.btnResume.isHidden = false
        }else{
            self.btnResume.isHidden = true
        }
    }
    
    //MARK: - Button Actions
    @IBAction func btnStartTapped(_ sender: UIButton){
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "InspectionVC") as! InspectionVC
        vc.isFromStart = true
        var user = Constants.shared.currentUser
        user.isInDraft = true
        Constants.shared.currentUser = user
        Constants.shared.setUserDetails(user: user)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnResumeTapped(_ sender: UIButton){
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "InspectionVC") as! InspectionVC
        vc.isFromStart = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnHistoryTapped(_ sender: UIButton){
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "HistoryVC") as! HistoryVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
