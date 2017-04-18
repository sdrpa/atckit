/**
 Created by Sinisa Drpa on 4/9/17.

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

extension Location: Coding {

    public init?(json: JSON) {
        guard let position: Position = "position" <| json,
            let timestamp: TimeInterval = "timestamp" <| json else {
                return nil
        }
        self.position = position
        self.timestamp = timestamp
    }

    public func toJSON() -> JSON? {
        return jsonify([
            "position" |> self.position,
            "timestamp" |> self.timestamp
            ])
    }
}
