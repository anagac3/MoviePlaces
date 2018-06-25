//
//  MovieParserTests.swift
//  MoviePlacesTests
//
//  Created by Andres Aguilar on 6/25/18.
//  Copyright © 2018 Andres Aguilar. All rights reserved.
//

import XCTest
@testable import MoviePlaces

class MovieParserTests: XCTestCase {
    
    var movieParser: MovieListParser!
    
    override func setUp() {
        super.setUp()
        movieParser = MovieListParser()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testWhitespaces() {
        //Movie title has an extra space on second entry
        let testData = [[ 20, "5E974F90-30D7-4331-9883-C40D9DAE9509", 20, 1509143469, "881420", 1509143469, "881420", nil, "A Smile Like Yours", "1997", "75 California Street", nil, "Paramount Pictures", "Paramount Pictures", "Keith Samples", "Keith Samples & Kevin Meyer", "Greg Kinnear", "Lauren Holly", nil ],
            [ 23, "046D247C-DDE6-46FD-AA33-1EE0433FC839", 23, 1509143469, "881420", 1509143469, "881420", nil, "A Smile Like Yours ", "1997", "San Francisco International Airport", "SFO has a museum dedicated to aviation history. ", "Paramount Pictures", "Paramount Pictures", "Keith Samples", "Keith Samples & Kevin Meyer", "Greg Kinnear", "Lauren Holly", nil ]]
        if let data = convertToData(array: testData) {
            let movies = movieParser.parseData(data)
            XCTAssertEqual(movies.count, 1, "Duplicated entries")
            if let first = movies.first {
                XCTAssertEqual(first.title, "A Smile Like Yours", "Wrong title")
                XCTAssertEqual(first.director, "Keith Samples", "Wrong director")
                XCTAssertEqual(first.productionCompany, "Paramount Pictures", "Wrong production company")
                XCTAssertEqual(first.releaseYear, "1997", "Wrong release year")
                XCTAssertEqual(first.locations.count, 2, "Locations parsed incorrectly")
            }
        }
    }
    
    func testSmallerArray() {
        let testData = [[ 20, "5E974F90-30D7-4331-9883-C40D9DAE9509", 20, 1509143469, "881420", 1509143469, "881420", nil, "A Smile Like Yours", "1997", "75 California Street"]]
        if let data = convertToData(array: testData) {
            let movies = movieParser.parseData(data)
            XCTAssertEqual(movies.count, 0)
        }
    }
    
    func testSupplyOtherData() {
        //Not passing Data
        let testData = [[ 20, "5E974F90-30D7-4331-9883-C40D9DAE9509", 20, 1509143469, "881420", 1509143469, "881420", nil, "A Smile Like Yours", "1997", "75 California Street", nil, "Paramount Pictures", "Paramount Pictures", "Keith Samples", "Keith Samples & Kevin Meyer", "Greg Kinnear", "Lauren Holly", nil ]]
        let movies = movieParser.parseData(testData)
        XCTAssertEqual(movies.count, 0)
    }
    
    func testInvalidTitle() {
        let testData = [[ 20, "5E974F90-30D7-4331-9883-C40D9DAE9509", 20, 1509143469, "881420", 1509143469, "881420", nil, nil, "1997", "75 California Street", nil, "Paramount Pictures", "Paramount Pictures", "Keith Samples", "Keith Samples & Kevin Meyer", "Greg Kinnear", "Lauren Holly", nil ]]
        if let data = convertToData(array: testData) {
            let movies = movieParser.parseData(data)
            XCTAssertEqual(movies.count, 0)
        }
    }
    
    func testInvalidPlace() {
        let testData = [[ 20, "5E974F90-30D7-4331-9883-C40D9DAE9509", 20, 1509143469, "881420", 1509143469, "881420", nil, "A Smile Like Yours", "1997", nil, nil, "Paramount Pictures", "Paramount Pictures", "Keith Samples", "Keith Samples & Kevin Meyer", "Greg Kinnear", "Lauren Holly", nil ]]
        if let data = convertToData(array: testData) {
            let movies = movieParser.parseData(data)
            XCTAssertEqual(movies.count, 0)
        }
    }
    
    func testEmptyFields() {
        let testData = [[ 20, "5E974F90-30D7-4331-9883-C40D9DAE9509", 20, 1509143469, "881420", 1509143469, "881420", nil, "A Smile Like Yours", nil, "75 California Street", nil, nil, "Paramount Pictures", nil, "Keith Samples & Kevin Meyer", "Greg Kinnear", "Lauren Holly", nil ]]
        if let data = convertToData(array: testData) {
            let movies = movieParser.parseData(data)
            XCTAssertEqual(movies.count, 1)
            if let first = movies.first {
                XCTAssertEqual(first.title, "A Smile Like Yours", "Wrong title")
                XCTAssertEqual(first.director, "", "Wrong director")
                XCTAssertEqual(first.productionCompany, "", "Wrong production company")
                XCTAssertEqual(first.releaseYear, "", "Wrong release year")
                XCTAssertEqual(first.locations.count, 1, "Locations parsed incorrectly")
            }
        }
    }
    
    func convertToData(array: Array<Any>) -> Data? {
        
        let dictionary: Dictionary<String, Any> = ["data":array]
        return try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        
    }
    
}
