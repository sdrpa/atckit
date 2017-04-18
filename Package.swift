/**
 Created by Sinisa Drpa on 4/11/17.

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

import PackageDescription

let package = Package(
    name: "ATCKit",
    dependencies: [
        .Package(url: "https://github.com/sdrpa/aircraftkit.git", versions: Version(0, 0, 0)..<Version(1, 0, 0)),
        .Package(url: "https://github.com/sdrpa/foundationkit.git", versions: Version(0, 0, 0)..<Version(1, 0, 0)),
        .Package(url: "https://github.com/sdrpa/measure.git", versions: Version(0, 0, 0)..<Version(1, 0, 0))
    ]
)

products.append(
    Product(name: "ATCKit", type: .Library(.Dynamic), modules: "ATCKit")
)
