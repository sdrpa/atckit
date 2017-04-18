/**
 Created by Sinisa Drpa on 2/13/17.

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

// Latitude/longitude spherical tools (c) Chris Veness 2002-2016. MIT Licence
// http://www.movable-type.co.uk/scripts/latlong.html
// http://www.movable-type.co.uk/scripts/geodesy/docs/module-latlon-spherical.html

fileprivate let π = Radian(Double.pi)

public extension Coordinate {

    /**
     Returns the distance from this coordinate to destination coordinate (using haversine formula)

     - parameters:
     - coordinate: Destination coordinate
     - radius: (Mean) radius of earth (defaults to radius in metres)
     - returns: Distance between this coordinate and destination coordinate, in same units as radius
     */
    public func distance(to coordinate: Coordinate, radius: Meter = 6371e3) -> Meter {
        let R = Double(radius)
        let φ1 = Radian(self.latitude), λ1 = Radian(self.longitude)
        let φ2 = Radian(coordinate.latitude), λ2 = Radian(coordinate.longitude)
        let Δφ = φ2 - φ1
        let Δλ = λ2 - λ1

        // Expression for 'a' was too complex to be solved in reasonable time; consider breaking up the expression into distinct sub-expressions
        let x = sin(Δφ/2) * sin(Δφ/2)
        let y = cos(φ1) * cos(φ2)
        let z = sin(Δλ/2) * sin(Δλ/2)
        let a = x + y * z

        let c = 2 * atan2(sqrt(a), sqrt(1-a))
        let d = R * Double(c)

        return Meter(d)
    }

    /**
     Returns the (initial) bearing from this coordinate to destination coordinate

     - parameters:
     - coordinate: Destination coordinate
     - returns: Initial bearing in degrees from north
     */
    public func bearing(to coordinate: Coordinate) -> Degree {
        let φ1 = Radian(self.latitude), φ2 = Radian(coordinate.latitude)
        let Δλ = Radian(coordinate.longitude - self.longitude)

        // See http://mathforum.org/library/drmath/view/55417.html
        let y = sin(Δλ) * cos(φ2)
        let x = cos(φ1) * sin(φ2) -
            sin(φ1) * cos(φ2) * cos(Δλ)
        let θ = atan2(y, x)

        return Degree(θ).wrapping(lowerBound: 0.0, upperBound: 360.0)
    }

    /**
     Returns final bearing arriving at destination coordinate from this coordinate;
     the final bearing will differ from the initial bearing by varying degrees according to distance and latitude

     - parameters:
     - coordinate: Destination coordinate
     - returns: Final bearing in degrees from north
     */
    public func finalBearing(to coordinate: Coordinate) -> Degree {
        // Get initial bearing from destination coordinate to this coordinate and reverse it by adding 180°
        let bearing = coordinate.bearing(to: self) + 180
        return bearing.wrapping(lowerBound: 0.0, upperBound: 360.0)
    }

    /**
     Returns the midpoint between ‘this’ coordinate and the supplied coordinate.

     - parameters:
     - coordinate: Destination coordinate
     - returns: Midpoint between this coordinate and the supplied coordinate
     */
    public func midpoint(to coordinate: Coordinate) -> Coordinate {
        // φm = atan2( sinφ1 + sinφ2, √( (cosφ1 + cosφ2⋅cosΔλ) ⋅ (cosφ1 + cosφ2⋅cosΔλ) ) + cos²φ2⋅sin²Δλ )
        // λm = λ1 + atan2(cosφ2⋅sinΔλ, cosφ1 + cosφ2⋅cosΔλ)
        // See http://mathforum.org/library/drmath/view/51822.html for derivation

        let φ1 = Radian(self.latitude), λ1 = Radian(self.longitude)
        let φ2 = Radian(coordinate.latitude)
        let Δλ = Radian(coordinate.longitude - self.longitude)

        let Bx = cos(φ2) * cos(Δλ)
        let By = cos(φ2) * sin(Δλ)

        let x = sqrt((cos(φ1) + Bx) * (cos(φ1) + Bx) + By * By)
        let y = sin(φ1) + sin(φ2)
        let φ3 = atan2(y, x)

        let λ3 = λ1 + atan2(By, cos(φ1) + Bx)

        return Coordinate(latitude: Degree(φ3), longitude: Degree(λ3).wrapping(lowerBound: -180.0, upperBound: 180.0))
    }

    /**
     Returns the coordinate from this coordinate having travelled the given distance on the given initial bearing (bearing normally varies around path followed)

     - parameters:
     - distance: Distance travelled, in same units as earth radius (default: metres)
     - bearing: Initial bearing in degrees from north
     - radius: (Mean) radius of earth (defaults to radius in metres)
     - returns: Destination coordinate
     */
    public func coordinate(at distance: Meter, bearing: Degree, radius: Meter = 6371e3) -> Coordinate {
        // φ2 = asin( sinφ1⋅cosδ + cosφ1⋅sinδ⋅cosθ )
        // λ2 = λ1 + atan2( sinθ⋅sinδ⋅cosφ1, cosδ − sinφ1⋅sinφ2 )
        // See http://williams.best.vwh.net/avform.htm#LL

        let δ = Radian(Double(distance / radius)) // Angular distance in radians
        let θ = Radian(bearing)

        let φ1 = Radian(self.latitude)
        let λ1 = Radian(self.longitude)

        let φ2 = asin(sin(φ1)*cos(δ) + cos(φ1)*sin(δ)*cos(θ))
        let x = cos(δ) - sin(φ1) * sin(φ2)
        let y = sin(θ) * sin(δ) * cos(φ1)
        let λ2 = λ1 + atan2(y, x)

        return Coordinate(latitude: Degree(φ2), longitude: Degree(λ2).wrapping(lowerBound: -180.0, upperBound: 180.0))
    }

    /**
     Returns the coordinate of intersection of two paths defined by coordinate and bearing.

     - parameters:
     - p1: First coordinate
     - brng1: Initial bearing from first coordinate
     - p2: Second coordinate
     - brng2: Initial bearing from second coordinate
     - returns: Destination coordinate or nil if no unique intersection defined
     */
    public static func intersection(between p1: Coordinate, bearing1: Degree, and p2: Coordinate, bearing2: Degree) -> Coordinate? {
        // see http://williams.best.vwh.net/avform.htm#Intersection

        let φ1 = Radian(p1.latitude), λ1 = Radian(p1.longitude)
        let φ2 = Radian(p2.latitude), λ2 = Radian(p2.longitude)
        let θ13 = Radian(bearing1), θ23 = Radian(bearing2)
        let Δφ = φ2-φ1, Δλ = λ2-λ1

        let a = sin(Δφ/2) * sin(Δφ/2)
        let b = cos(φ1) * cos(φ2) * sin(Δλ/2) * sin(Δλ/2)
        let c = sqrt(a + b)
        let δ12 = 2*asin(c)
        if δ12 == 0 {
            return nil
        }

        // Initial/final bearings between coordinates
        var θ1 = acos((sin(φ2) - sin(φ1)*cos(δ12)) / (sin(δ12)*cos(φ1)))
        if θ1.isNaN {
            θ1 = 0 // Protect against rounding
        }
        let θ2 = acos((sin(φ1) - sin(φ2)*cos(δ12)) / (sin(δ12)*cos(φ2)))

        let θ12 = sin(λ2-λ1)>0 ? θ1 : 2*π-θ1;
        let θ21 = sin(λ2-λ1)>0 ? 2*π-θ2 : θ2;

        let α1 = (θ13 - θ12 + π).truncatingRemainder(dividingBy: (2*π)) - π // Angle 2-1-3
        let α2 = (θ21 - θ23 + π).truncatingRemainder(dividingBy: (2*π)) - π // Angle 1-2-3

        if sin(α1) == 0 && sin(α2) == 0 {
            return nil // Infinite intersections
        }
        if sin(α1)*sin(α2) < 0 {
            return nil // Ambiguous intersection
        }

        // α1 = abs(α1);
        // α2 = abs(α2);
        // ... Ed Williams takes abs of α1/α2, but seems to break calculation?

        let α3 = -cos(α1)*cos(α2)
        let α4 = sin(α1)*sin(α2)*cos(δ12)
        let α5 = acos(α3 + α4)
        let δ13 = atan2(sin(δ12)*sin(α1)*sin(α2), cos(α2)+cos(α1)*cos(α5))
        let φ3 = asin(sin(φ1)*cos(δ13) + cos(φ1)*sin(δ13)*cos(θ13))
        let Δλ13 = atan2(sin(θ13)*sin(δ13)*cos(φ1), cos(δ13)-sin(φ1)*sin(φ3))
        let λ3 = λ1 + Δλ13

        return Coordinate(latitude: Degree(φ3), longitude: Degree(λ3).wrapping(lowerBound: -180.0, upperBound: 180.0))
    }

    /**
     Returns (signed) distance from this coordinate to great circle defined by start-coordinate and end-coordinate.

     - parameters:
     - start: Start coordinate of great circle path
     - end: End coordinate of great circle path
     - radius: (Mean) radius of earth (defaults to radius in metres)
     - returns: Distance to great circle (-ve if to left, +ve if to right of path)
     */
    public func crossTrackDistance(from start: Coordinate, end: Coordinate, radius: Meter = 6371e3) -> Meter {
        let δ13 = Radian(start.distance(to: self, radius: radius) / radius)
        let θ13 = Radian(start.bearing(to: self))
        let θ12 = Radian(start.bearing(to: end))

        let dxt = asin(sin(δ13) * sin(θ13-θ12)) * Radian(radius)

        return Meter(Double(dxt))
    }

    /**
     Returns maximum latitude reached when travelling on a great circle on given bearing from this coordinate ('Clairaut's formula').  Negate the result for the minimum latitude (in the Southern hemisphere)
     The maximum latitude is independent of longitude; it will be the same for all coordinates on a given latitude

     - parameters:
     - bearing: Initial bearing
     - returns: Starting latitude
     */
    public func maxLatitude(bearing: Degree) -> Degree {
        let θ = Radian(bearing)
        let φ = Radian(self.latitude)
        let φMax = acos(abs(sin(θ)*cos(φ)))
        return Degree(φMax)
    }

    /**
     Returns the pair of meridians at which a great circle defined by two coordinates crosses the given latitude.  If the great circle doesn't reach the given latitude, nil is returned

     - parameters:
     - coordinate1: First coordinate defining great circle
     - coordinate2: Second coordinate defining great circle
     - latitude: Latitude crossings are to be determined for
     - returns: Tuple containing (longitude1, longitude2) or nil if given latitude not reached
     */
    public static func crossingParallels(coordinate1: Coordinate, coordinate2: Coordinate, latitude: Degree) -> (longitude1: Degree, longitude2: Degree)? {
        let φ = Radian(latitude)

        let φ1 = Radian(coordinate1.latitude)
        let λ1 = Radian(coordinate1.longitude)
        let φ2 = Radian(coordinate2.latitude)
        let λ2 = Radian(coordinate2.longitude)

        let Δλ = λ2 - λ1

        let x = sin(φ1) * cos(φ2) * cos(φ) * sin(Δλ)
        let y0 = sin(φ1) * cos(φ2) * cos(φ) * cos(Δλ)
        let y1 = cos(φ1) * sin(φ2) * cos(φ)
        let y = y0 - y1
        let z = cos(φ1) * cos(φ2) * sin(φ) * sin(Δλ)

        if z*z > x*x + y*y {
            return nil // Great circle doesn't reach latitude
        }

        let λm = atan2(-y, x) // Longitude at max latitude
        let Δλi = acos(z / sqrt(x*x+y*y)) // Δλ from λm to intersection coordinates

        let λi1 = λ1 + λm - Δλi
        let λi2 = λ1 + λm + Δλi

        return (longitude1: Degree(λi1).wrapping(lowerBound: -180.0, upperBound: 180.0),
                longitude2: Degree(λi2).wrapping(lowerBound: -180.0, upperBound: 180.0))
    }

    // MARK: Rhumb

    /**
     Returns the distance travelling from ‘this’ coordinate to destination coordinate along a rhumb line.

     - parameters:
     - coordinate: Destination coordinate
     - radius: (Mean) radius of earth (defaults to radius in metres)
     - returns: Distance between this coordinate and destination coordinate (same units as radius)
     */
    public func rhumbDistance(to coordinate: Coordinate, radius: Meter = 6371e3) -> Meter {
        // See http://williams.best.vwh.net/avform.htm#Rhumb
        let R = radius
        let φ1 = Radian(self.latitude), φ2 = Radian(coordinate.latitude)
        let Δφ = φ2 - φ1
        var Δλ = Radian(abs(coordinate.longitude - self.longitude))
        // If dLon over 180° take shorter rhumb line across the anti-meridian:
        if abs(Δλ) > π {
            Δλ = Δλ>0 ? -(2*π-Δλ) : (2*π+Δλ)
        }

        // On Mercator projection, longitude distances shrink by latitude; q is the 'stretch factor' q becomes ill-conditioned along E-W line (0/0); use empirical tolerance to avoid it
        let a = tan(φ2/2+π/4)
        let b = tan(φ1/2+π/4)
        let Δψ = log(a/b)
        let q = abs(Δψ) > 10e-12 ? Δφ/Δψ : cos(φ1)
        
        // Distance is pythagoras on 'stretched' Mercator projection
        let δ = sqrt(Δφ*Δφ + q*q*Δλ*Δλ) // Angular distance in radians
        let dist = Meter(δ) * R
        
        return dist
    }
}
