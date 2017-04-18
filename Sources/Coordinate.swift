/**
 Created by Sinisa Drpa on 1/19/17.

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

/**
 * Latitude measures angular distance from the equator to a point north or south of the equator
 * Longitude is an angular measure of east/west from the Prime Meridian.
 *
 * Latitude values increase or decrease along the vertical axis, the Y axis
 * Longitude changes value along the horizontal access, the X axis.
 *
 * X = Longitude, Y = Latitude
 */
public struct Coordinate: Hashable {

    public let latitude: Degree
    public let longitude: Degree

    public init() {
        self.init(latitude: 0.0, longitude: 0.0)
    }

    public init(latitude: Degree, longitude: Degree) {
        self.latitude = latitude
        self.longitude = longitude
    }

    public var hashValue: Int {
        return self.latitude.hashValue + self.longitude.hashValue
    }

    public static func ==(lhs: Coordinate, rhs: Coordinate) -> Bool {
        return (lhs.latitude == rhs.latitude) && (lhs.longitude == rhs.longitude)
    }
}

extension Coordinate: CustomStringConvertible {

    public var description: String {
        return ("\(self.latitude), \(self.longitude)")
    }

    public var longDescription: String {
        let latitude = self.latitude.toDMS() + (self.latitude >= 0 ? "N" : "S")
        let longitude = self.longitude.toDMS() + (self.longitude >= 0 ? "E" : "W")
        return latitude + " " + longitude
    }
}
