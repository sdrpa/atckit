/**
 Created by Sinisa Drpa on 2/15/17.

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
import Foundation
import Measure

public typealias Squawk = UInt

public struct FlightPlan: Equatable {

    public let callsign: String
    public let squawk: Squawk
    public let aircraft: Aircraft

    public let ADEP: String
    public let ADES: String

    public let RFL: FL

    public let route: Route

    public init(callsign: String, squawk: Squawk, aircraft: Aircraft, ADEP: String, ADES: String, RFL: FL, route: Route) {
        self.callsign = callsign
        self.aircraft = aircraft
        self.squawk = squawk
        self.ADEP = ADEP
        self.ADES = ADES
        self.RFL = RFL
        self.route = route
    }

    public static func ==(lhs: FlightPlan, rhs: FlightPlan) -> Bool {
        return (lhs.callsign == rhs.callsign) &&
            (lhs.aircraft == rhs.aircraft) &&
            (lhs.squawk == rhs.squawk) &&
            (lhs.ADEP == rhs.ADEP) &&
            (lhs.ADES == rhs.ADES) &&
            (lhs.RFL == rhs.RFL) &&
            (lhs.route == rhs.route)
    }
}

public extension FlightPlan {

    /// Estimated En-Route Time
    public var EET: TimeInterval {
        guard let mach = aircraft.performance.cruise.mach else {
            return 0
        }
        let s = self.route.length
        let v = Kts(mach)
        let t = Double(s) / Double(v)
        return t
    }
}
