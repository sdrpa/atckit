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

public protocol NavigationPoint {

    var title: String { get }
    var coordinate: Coordinate { get }
}

public struct AnyNavigationPoint: NavigationPoint, Equatable {
    
    public let title: String
    public let coordinate: Coordinate

    public init(_ navigationPoint: NavigationPoint) {
        self.title = navigationPoint.title
        self.coordinate = navigationPoint.coordinate
    }

    public static func ==(lhs: AnyNavigationPoint, rhs: AnyNavigationPoint) -> Bool {
        return (lhs.title == rhs.title) && (lhs.coordinate == rhs.coordinate)
    }

    // Since we can't compare AnyNavigationPoint to NavigationPoint without AnyNavigationPoint == AnyNavigationPoint(NavigationPoint)
    public func isEqual(to rhs: NavigationPoint) -> Bool {
        return (self.title == rhs.title) && (self.coordinate == rhs.coordinate)
    }
}
