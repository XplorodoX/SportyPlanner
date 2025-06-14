//
//  CardioDetailView.swift
//  SportyPlanner
//
//  Created by Florian Merlau on 15.06.25.
//

import SwiftUI
import MapKit

struct CardioDetailView: View {
    let session: CardioSession
    
    @State private var position: MapCameraPosition = .automatic

    private var routeCoordinates: [CLLocationCoordinate2D] {
        session.locations.map { $0.location.coordinate }
    }

    var body: some View {
        VStack(spacing: 0) {
            if !session.locations.isEmpty {
                Map(position: $position) {
                    MapPolyline(coordinates: routeCoordinates)
                        .stroke(.blue, lineWidth: 5)
                    Marker("Start", coordinate: routeCoordinates.first!)
                    Marker("Ende", coordinate: routeCoordinates.last!)
                }
                .onAppear {
                    // Kamera auf die Route zentrieren
                    let mapRect = routeCoordinates.reduce(MKMapRect.null) { rect, coordinate in
                        let point = MKMapPoint(coordinate)
                        return rect.union(MKMapRect(x: point.x, y: point.y, width: 0, height: 0))
                    }
                    position = .rect(mapRect.insetBy(dx: -1000, dy: -1000))
                }
            } else {
                ContentUnavailableView(
                    "Keine Route aufgezeichnet",
                    systemImage: "map.circle",
                    description: Text("Für diese Einheit wurden keine Standortdaten gespeichert.")
                )
            }
            
            // Detailinformationen unter der Karte
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Image(systemName: session.type == .running ? "figure.run" : "bicycle")
                        .font(.largeTitle)
                        .foregroundColor(.accentColor)
                    
                    VStack(alignment: .leading) {
                        Text(session.type.rawValue.capitalized)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Text(session.date, format: .dateTime.day().month().year())
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                
                Divider()
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Dauer")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(formattedDuration(session.duration))
                            .font(.title2)
                            .fontWeight(.semibold)
                    }
                    Spacer()
                }
            }
            .padding()
            .background(.thinMaterial)
        }
        .navigationTitle("Cardio-Details")
        .ignoresSafeArea(edges: .top)
    }
    
    private func formattedDuration(_ duration: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .full
        return formatter.string(from: duration) ?? ""
    }
}

// Hilfserweiterung, um die Map-Region zu berechnen
extension Array where Element == CLLocationCoordinate2D {
    var rect: MKMapRect {
        self.reduce(MKMapRect.null) { mapRect, coordinate in
            let point = MKMapPoint(coordinate)
            return mapRect.union(MKMapRect(x: point.x, y: point.y, width: 0, height: 0))
        }
    }
}
