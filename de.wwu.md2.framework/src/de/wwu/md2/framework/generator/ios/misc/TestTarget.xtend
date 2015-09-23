package de.wwu.md2.framework.generator.ios.misc

import de.wwu.md2.framework.generator.ios.Settings
import de.wwu.md2.framework.generator.ios.util.IOSGeneratorUtil
import java.lang.invoke.MethodHandles

class TestTarget {
	
	static var className = ""
	
	def static generateClass() {
		className = Settings.XCODE_TARGET_TEST
		
		// Currently dummy implementation 
		generateClassContent()
	} 
	
	def static generateClassContent() '''
«IOSGeneratorUtil.generateClassHeaderComment(className, MethodHandles.lookup.lookupClass)»

import UIKit
import XCTest

class «className»: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
	'''
	
}