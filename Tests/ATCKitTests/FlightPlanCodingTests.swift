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

import AircraftKit
import Measure
import XCTest
@testable import ATCKit

class FlightPlanCodingTests: XCTestCase {

    func testCoding() {
        // Aircraft
        let takeOff = Performance.TakeOff(v2: 140, distance: 1600, mtow: 56470)
        let climb1 = Performance.Climb(from: 0, to: 5000, ias: 165, rate: 2500)
        let climb2 = Performance.Climb(from: 5000, to: 15000, ias: 270, rate: 2000)
        let cruise = Performance.Cruise(tas: 429, mach: Mach(0.745), ceiling: 370, range: 1600)
        let descent1 = Performance.Descent(from: 660, to: 24000, mach: Mach(0.7), rate: 800)
        let descent2 = Performance.Descent(from: 24000, to: 10000, ias: 270, rate: 3500)
        let approach = Performance.Approach(v: 130, distance: 1400, apc: "C")
        let performance = Performance(takeOff: takeOff, climb: [climb1, climb2], cruise: cruise, descent: [descent1, descent2], approach: approach)
        let aircraft = Aircraft(code: .B733, name: "737-300", manufacturer: "BOEING", typeCode: "L2J", wtc: .medium, performance: performance)
        // Route
        let coordinate = Coordinate(latitude: 44.7866, longitude: 20.4489)
        let vor1 = VOR(title: "XX1", coordinate: coordinate, frequency: 121.5)
        let vor2 = VOR(title: "XX2", coordinate: coordinate, frequency: 121.5)
        let route = Route(navigationPoints: [AnyNavigationPoint(vor1), AnyNavigationPoint(vor2)])

        let flightPlan = FlightPlan(callsign: "ASL123", squawk: 2000, aircraft: aircraft, ADEP: "LYBE", ADES: "LWSK", RFL: 270, route: route)

        let value = flightPlan
        guard let encoded = value.toJSON() else {
            XCTFail(); return
        }
        XCTAssertTrue(JSONSerialization.isValidJSONObject(encoded))
        let decoded = FlightPlan(json: encoded)
        XCTAssertEqual(value, decoded)
    }

    static var allTests : [(String, (FlightPlanCodingTests) -> () throws -> Void)] {
        return [
            ("testCoding", testCoding),
        ]
    }
}
