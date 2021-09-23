//
//  FlightListEntry.swift
//  Enroute
//
//  Created by Vladimir Stepanchikov on 23.09.2021.
//  Copyright © 2021 Stanford University. All rights reserved.
//

import SwiftUI

struct FlightListEntry: View {
    @ObservedObject var flight: Flight

    var name: String {
        return "\(flight.airline.friendlyName) \(flight.number)"
    }

    var arrives: String {
        let time = DateFormatter.stringRelativeToToday(Date.currentFlightTime, from: flight.arrival)

        if flight.departure == nil {
            return "scheduled to arrive \(time) (not departed)"
        } else if flight.arrival < Date.currentFlightTime {
            return "arrived \(time)"
        } else {
            return "arrives \(time)"
        }
    }

    var origin: String {
        return "from " + (flight.origin.friendlyName)
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text(name)
            Text(arrives).font(.caption)
            Text(origin).font(.caption)
        }
        .lineLimit(1)
    }
}
