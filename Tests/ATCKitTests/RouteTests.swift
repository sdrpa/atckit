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

class RouteTests: XCTestCase {

    func testEquality() {
        let vor1 = VOR(title: "XX1",
                       coordinate: Coordinate(latitude: 44.7866, longitude: 20.4489),
                       frequency: 121.5)
        let vor2 = VOR(title: "XX2",
                       coordinate: Coordinate(latitude: 44.7866, longitude: 20.4489),
                       frequency: 121.5)
        let vor3 = VOR(title: "XX3",
                       coordinate: Coordinate(latitude: 44.7866, longitude: 20.4489),
                       frequency: 121.5)
        let route1 = Route(navigationPoints: [vor1, vor2])
        let route2 = Route(navigationPoints: [vor1, vor2])
        let route3 = Route(navigationPoints: [vor1, vor3])

        XCTAssertEqual(route1, route2)
        XCTAssertNotEqual(route1, route3)
    }

    func testNearestNextPoint() {
        let point1 = Point(title: "VAL", coordinate: Coordinate(latitude: 44.300, longitude: 19.9))
        let point2 = Point(title: "KOSIV", coordinate: Coordinate(latitude: 44.0, longitude: 19.8))
        let point3 = Point(title: "TORTO", coordinate: Coordinate(latitude: 43.7, longitude: 19.7))
        let point4 = Point(title: "GENLU", coordinate: Coordinate(latitude: 43.4, longitude: 19.4))
        let point5 = Point(title: "BUNEX", coordinate: Coordinate(latitude: 43.2, longitude: 19.3))

        let route = Route(navigationPoints: [point1, point2, point3, point4, point5])
        guard let nearest1 = route.nearestPointOnRoute(from: Coordinate(latitude: 43.5, longitude: 19.5)) else { XCTFail(); return }
        XCTAssertEqual(AnyNavigationPoint(point4), AnyNavigationPoint(nearest1))

        guard let nearest2 = route.nearestPointOnRoute(from: Coordinate(latitude: 43.8, longitude: 19.8)) else { XCTFail(); return }
        XCTAssertEqual(AnyNavigationPoint(point3), AnyNavigationPoint(nearest2))
    }

    func testTimestepForNavigationPoint() {
        let point1 = Point(title: "VAL", coordinate: Coordinate(latitude: 44.300, longitude: 19.9))
        let point2 = Point(title: "KOSIV", coordinate: Coordinate(latitude: 44.0, longitude: 19.8))
        let point3 = Point(title: "TORTO", coordinate: Coordinate(latitude: 43.7, longitude: 19.7))

        let route = Route(navigationPoints: [point1, point2, point3], timestamps: [1000, 2000, 3000])
        XCTAssertEqual(2000, route.timestamp(for: point2))
    }

    static var allTests : [(String, (RouteTests) -> () throws -> Void)] {
        return [
            ("testEquality", testEquality),
            ("testNearestNextPoint", testNearestNextPoint)
        ]
    }
}
