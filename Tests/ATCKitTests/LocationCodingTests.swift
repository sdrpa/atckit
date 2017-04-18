/**
 Created by Sinisa Drpa on 4/11/17.

 ATCKit is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or any later version.

 ATCKit is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with ATCKit.  If not, see <http://www.gnu.org/licenses/>
 */

import XCTest
@testable import ATCKit

class LocationCodingTests: XCTestCase {

    func testCoding() {
        let coordinate = Coordinate(latitude: 44.7866, longitude: 20.4489)
        let position = Position(coordinate: coordinate, altitude: 12000)
        let location = Location(position: position, timestamp: 12345)
        let value = location
        guard let encoded = value.toJSON() else {
            XCTFail(); return
        }
        XCTAssertTrue(JSONSerialization.isValidJSONObject(encoded))
        let decoded = Location(json: encoded)
        XCTAssertEqual(value, decoded)
    }

    static var allTests : [(String, (LocationCodingTests) -> () throws -> Void)] {
        return [
            ("testCoding", testCoding)
        ]
    }
}
