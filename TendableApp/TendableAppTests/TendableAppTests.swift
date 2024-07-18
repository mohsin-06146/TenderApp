//
//  TendableAppTests.swift
//  TendableAppTests
//
//  Created by Menti on 15/07/24.
//

import XCTest
@testable import TendableApp

final class TendableAppTests: XCTestCase {

    var sutLogin: LoginViewModel!
    var sutRegister: RegisterViewModel!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sutLogin = LoginViewModel()
        sutRegister = RegisterViewModel()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sutLogin = nil
        sutRegister = nil
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    
    func testLoginEmailValidation() throws {
        let email = "abc@gmail.com"
        
        let isValidEmail = sutLogin.isValidEmail(email: email)
        
        XCTAssert(isValidEmail, "Email is not valid")
    }
    
    func testLoginPasswordValidation() throws {
        let password = "12345678"
        
        let isValidPassword = sutLogin.isValidPassword(password: password)
        
        XCTAssert(isValidPassword, "Password is not valid")
    }
    
    func testRegistermailValidation() throws {
        let email = "abc@gmail.com"
        
        let isValidEmail = sutRegister.isValidEmail(email: email)
        
        XCTAssert(isValidEmail, "Email is not valid")
    }
    
    func testRegisterPasswordValidation() throws {
        let password = "12345678"
        
        let isValidPassword = sutRegister.isValidPassword(password: password)
        
        XCTAssert(isValidPassword, "Password is not valid")
    }
    

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
