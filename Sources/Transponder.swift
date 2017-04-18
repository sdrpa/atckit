/**
 Created by Sinisa Drpa on 4/8/17.

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

public struct Transponder {

    public struct modeSEHS {

        public let callsign: String
        public let squawk: Squawk
        public let position: Position
        public let mach: Mach
        public let heading: Degree

        public init(callsign: String, squawk: Squawk = 2000, position: Position, mach: Mach, heading: Degree) {
            self.callsign = callsign
            self.squawk = squawk
            self.position = position
            self.mach = mach
            self.heading = heading
        }
    }
}
