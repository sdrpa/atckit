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

import Foundation
import JSON
import Measure

extension Point: Coding {

    public init?(json: JSON) {
        guard let title: String = "title" <| json,
            let coordinate: Coordinate = "coordinate" <| json else {
                return nil
        }
        self.title = title
        self.coordinate = coordinate
    }

    public func toJSON() -> JSON? {
        return jsonify([
            "title" |> self.title,
            "coordinate" |> self.coordinate
            ])
    }
}
