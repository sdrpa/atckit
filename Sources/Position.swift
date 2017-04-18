/**
 Created by Sinisa Drpa on 2/6/17.

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
import Measure

public struct Position: Hashable {

    public let coordinate: Coordinate
    public let altitude: Feet

    public init(coordinate: Coordinate, altitude: Feet) {
        self.coordinate = coordinate
        self.altitude = altitude
    }

    public var hashValue: Int {
        return self.coordinate.hashValue + self.altitude.hashValue
    }

    public static func ==(lhs: Position, rhs: Position) -> Bool {
        return (lhs.coordinate == rhs.coordinate) && (lhs.altitude == rhs.altitude)
    }
}
