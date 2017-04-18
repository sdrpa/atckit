/**
 Created by Sinisa Drpa on 2/13/17.

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

import Foundation

public struct Point: NavigationPoint, Equatable, CustomStringConvertible {

    public let title: String
    public let coordinate: Coordinate

    public init(point: Point) {
        self.init(title: point.title, coordinate: point.coordinate)
    }

    public init(title: String, coordinate: Coordinate) {
        self.title = title
        self.coordinate = coordinate
    }

    public var description: String {
        return "\(self.title)"
    }

    public static func ==(lhs: Point, rhs: Point) -> Bool {
        return (lhs.title == rhs.title) && (lhs.coordinate == rhs.coordinate)
    }
}

public extension Point {

    public init(vor: VOR) {
        self.init(title: vor.title, coordinate: vor.coordinate)
    }

    public init(ndb: NDB) {
        self.init(title: ndb.title, coordinate: ndb.coordinate)
    }
}

