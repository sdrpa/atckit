/**
 Created by Sinisa Drpa on 1/20/17.

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

public struct VOR: NavigationPoint, Equatable {

    public let title: String
    public let coordinate: Coordinate
    public let frequency: Double // KHz

    public init(_ vor: VOR) {
        self.init(title: vor.title, coordinate: vor.coordinate, frequency: vor.frequency)
    }

    public init(title: String, coordinate: Coordinate, frequency: Double) {
        self.title = title
        self.coordinate = coordinate
        self.frequency = frequency
    }

    public static func ==(lhs: VOR, rhs: VOR) -> Bool {
        return (lhs.title == rhs.title) && (lhs.coordinate == rhs.coordinate)
    }
}
