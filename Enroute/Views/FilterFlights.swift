//
//  FilterFlights.swift
//  Enroute
//
//  Created by Vladimir Stepanchikov on 20.09.2021.
//  Copyright © 2021 Stanford University. All rights reserved.
//

import SwiftUI
import MapKit

struct FilterFlights: View {
    @FetchRequest(fetchRequest: Airport.fetchRequest(.all)) var airports: FetchedResults<Airport>
    @FetchRequest(fetchRequest: Airline.fetchRequest(.all)) var airlines: FetchedResults<Airline>

    @Binding var flightSearch: FlightSearch
    @Binding var isPresented: Bool

    var destination: Binding<MKAnnotation?> {
        return Binding<MKAnnotation?>(
            get: { return draft.destination },
            set: { annotation in
                if let airport = annotation as? Airport {
                    self.draft.destination = airport
                }
            }
        )
    }

    @State private var draft: FlightSearch

    init(flightSearch: Binding<FlightSearch>, isPresented: Binding<Bool>) {
        _flightSearch = flightSearch
        _isPresented = isPresented
        _draft = State(wrappedValue: flightSearch.wrappedValue)
    }

    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Destination", selection: $draft.destination) {
                        ForEach(airports.sorted(), id: \.self) { airport in
                            Text("\(airport.friendlyName)").tag(airport)
                        }
                    }
                    MapView(annotatios: airports.sorted(), selection: destination)
                        .frame(minHeight: 400)
                }
                Section {
                    Picker("Origin", selection: $draft.origin) {
                        Text("Any").tag(Airport?.none)
                        ForEach(airports.sorted(), id: \.self) { (airport: Airport?) in
                            Text("\(airport?.friendlyName ?? "Any")").tag(airport)
                        }
                    }
                    Picker("Airline", selection: $draft.airline) {
                        Text("Any").tag(Airline?.none)
                        ForEach(airlines.sorted(), id: \.self) { (airline: Airline?) in
                            Text("\(airline?.friendlyName ?? "Any")").tag(airline)
                        }
                    }
                    Toggle(isOn: $draft.inTheAir) { Text("Enroute only") }
                }
            }
            .navigationBarTitle("Filter flights")
            .navigationBarItems(leading: cancel, trailing: done)
        }
    }

    var cancel: some View {
        Button("Cancel") {
            isPresented = false
        }
    }

    var done: some View {
        Button("Done") {
            if draft.destination != flightSearch.destination {
                draft.destination.fetchIncomingFlights()
            }
            flightSearch = draft
            isPresented = false
        }
    }
}
