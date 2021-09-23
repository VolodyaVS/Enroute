//
//  FlightSearch.swift
//  Enroute
//
//  Created by Vladimir Stepanchikov on 23.09.2021.
//  Copyright © 2021 Stanford University. All rights reserved.
//

import CoreData

struct FlightSearch {
    var destination: Airport
    var origin: Airport?
    var airline: Airline?
    var inTheAir: Bool = true
}

extension FlightSearch {
    var predicate: NSPredicate {
        var format = "destination_ = %@"
        var args: [NSManagedObject] = [destination]

        if origin != nil {
            format += " and origin_ = %@"
            args.append(origin!)
        }

        if airline != nil {
            format += " and airline_ = %@"
            args.append(airline!)
        }

        if inTheAir { format += " and departure != nil" }
        return NSPredicate(format: format, argumentArray: args)
    }
}
