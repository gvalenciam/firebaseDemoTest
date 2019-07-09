//
//  baseViewControllerTests.swift
//  firebaseDemoTests
//
//  Created by Gerardo Valencia on 7/9/19.
//  Copyright © 2019 Gerardo Valencia. All rights reserved.


import XCTest
@testable import firebaseDemo

class baseViewControllerTests: XCTestCase {
    
    var testBaseViewController: BaseViewController!
    
    override func setUp() {
        super .setUp()
        testBaseViewController = BaseViewController.init()
    }
    
    func testValidName(){
        
        var testString = "Gerardo"
        XCTAssertTrue(testBaseViewController.isValidName(text: testString))
        
        testString = "Gerardo Valencia"
        XCTAssertTrue(testBaseViewController.isValidName(text: testString))
        
        testString = "12345"
        XCTAssertFalse(testBaseViewController.isValidName(text: testString))
        
        testString = "Gerardo12345"
        XCTAssertFalse(testBaseViewController.isValidName(text: testString))
        
        testString = "Gerardo 12345"
        XCTAssertFalse(testBaseViewController.isValidName(text: testString))
        
        testString = "Gerardo Valencia 12345"
        XCTAssertFalse(testBaseViewController.isValidName(text: testString))
        
        testString = "'/.;][.,"
        XCTAssertFalse(testBaseViewController.isValidName(text: testString))
        
        testString = "Gerardo[]';.,/"
        XCTAssertFalse(testBaseViewController.isValidName(text: testString))
        
        testString = "Gerardo []';.,/"
        XCTAssertFalse(testBaseViewController.isValidName(text: testString))
        
    }
    
    func testValidAge(){
        
        var testString = "24"
        XCTAssertTrue(testBaseViewController.isValidAge(text: testString))
        
        testString = "Gerardo24"
        XCTAssertFalse(testBaseViewController.isValidAge(text: testString))
        
        testString = "24 Gerardo"
        XCTAssertFalse(testBaseViewController.isValidAge(text: testString))
        
        testString = "24 24Gerardo"
        XCTAssertFalse(testBaseViewController.isValidAge(text: testString))
        
        testString = "24 25"
        XCTAssertFalse(testBaseViewController.isValidAge(text: testString))
        
        testString = "[]';/.,"
        XCTAssertFalse(testBaseViewController.isValidAge(text: testString))
        
        testString = "24[]';/.,"
        XCTAssertFalse(testBaseViewController.isValidAge(text: testString))
        
        testString = "24 []';/.,"
        XCTAssertFalse(testBaseViewController.isValidAge(text: testString))
        
        testString = "24 Gerardo []';/.,"
        XCTAssertFalse(testBaseViewController.isValidAge(text: testString))
        
    }
    
}
