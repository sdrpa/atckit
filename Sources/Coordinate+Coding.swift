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

import JSON
import Measure

extension Coordinate: Coding {

    public init?(json: JSON) {
        guard let latitude: Degree = "latitude" <| json,
            let longitude: Degree = "longitude" <| json else {
                return nil
        }
        self.latitude = latitude
        self.longitude = longitude
    }

    public func toJSON() -> JSON? {
        return jsonify([
            "latitude" |> self.latitude,
            "longitude" |> self.longitude
            ])
    }
}
