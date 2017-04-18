/**
 Created by Sinisa Drpa on 2/17/17.

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

public struct Route: Equatable {

    // In order to be able to use Coding, we need to erase NavigationPoint since Coding requires concreate type (homogeneous array)
    public let navigationPoints: [AnyNavigationPoint]
    public let timestamps: [TimeInterval]?

    public init(navigationPoints: [NavigationPoint], timestamps: [TimeInterval]? = nil) {
        self.navigationPoints = navigationPoints.map { AnyNavigationPoint($0) }
        self.timestamps = timestamps
    }

    public static func ==(lhs: Route, rhs: Route) -> Bool {
        return lhs.navigationPoints == rhs.navigationPoints
    }
}

public extension Route {

    public var length: Nm {
        let length = navigationPoints.reduce(Meter(0)) { acc, point in
            guard let next = nextPointOnRoute(after: point) else {
                return acc
            }
            let distance = point.coordinate.distance(to: next.coordinate)
            return acc + distance
        }
        return Nm(length)
    }

    public func nextPointOnRoute(after: NavigationPoint) -> NavigationPoint? {
        guard let index = navigationPoints.index(where: { $0.title == after.title }),
            let last = navigationPoints.last else {
                return nil
        }
        if navigationPoints[index].title == last.title {
            return nil
        }
        let next = self.navigationPoints.index(after: index)
        return navigationPoints[next]
    }

    public func nearestPointOnRoute(from coordinate: Coordinate) -> NavigationPoint? {
        guard let first = navigationPoints.first else {
            return nil
        }
        let nearest = navigationPoints.reduce(first) { acc, point in
            let previous = coordinate.distance(to: acc.coordinate)
            let current = coordinate.distance(to: point.coordinate)
            return (previous < current) ? acc : point
        }
        return nearest
    }

    public func timestamp(for navigationPoint: NavigationPoint) -> TimeInterval? {
        guard let index = navigationPoints.index(of: AnyNavigationPoint(navigationPoint)),
            let timestamps = self.timestamps, index < timestamps.count else {
                return nil
        }
        return timestamps[index]
    }
}
