//
//  FlightList.swift
//  Enroute
//
//  Created by Vladimir Stepanchikov on 23.09.2021.
//  Copyright © 2021 Stanford University. All rights reserved.
//

import SwiftUI

struct FlightList: View {
    @FetchRequest var flights: FetchedResults<Flight>

    private var title: String {
        let title = "Flights"
        if let destination = flights.first?.destination.icao {
            return title + " to \(destination)"
        } else {
            return title
        }
    }

    init(_ flightSearch: FlightSearch) {
        let predicate = flightSearch.predicate
        let request = Flight.fetchRequest(predicate)
        _flights = FetchRequest(fetchRequest: request)
    }

    var body: some View {
        List {
            ForEach(flights, id: \.ident) { flight in
                FlightListEntry(flight: flight)
            }
        }
        .navigationBarTitle(title)
    }
}
