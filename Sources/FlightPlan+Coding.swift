/**
 Created by Sinisa Drpa on 3/31/17.

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
import JSON
import Measure

extension FlightPlan: Coding {

    public init?(json: JSON) {
        guard let callsign: String = "callsign" <| json,
            let squawk: Squawk = "squawk" <| json,
            let aircraft: Aircraft = "aircraft" <| json,
            let ADEP: String = "ADEP" <| json,
            let ADES: String = "ADES" <| json,
            let RFL: FL = "RFL" <| json,
            let route: Route = "route" <| json else {
                return nil
        }
        self.callsign = callsign
        self.squawk = squawk
        self.aircraft = aircraft
        self.ADEP = ADEP
        self.ADES = ADES
        self.RFL = RFL
        self.route = route
    }

    public func toJSON() -> JSON? {
        return jsonify([
            "callsign" |> self.callsign,
            "squawk" |> self.squawk,
            "aircraft" |> self.aircraft,
            "ADEP" |> self.ADEP,
            "ADES" |> self.ADES,
            "RFL" |> self.RFL,
            "route" |> self.route
            ])
    }
}
