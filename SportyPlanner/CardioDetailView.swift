// SportyPlanner/CardioDetailView.swift

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
            // Die Map-Ansicht bleibt unverändert
            if !session.locations.isEmpty {
                Map(position: $position) {
                    MapPolyline(coordinates: routeCoordinates)
                        .stroke(.blue, lineWidth: 5)
                    Marker("Start", coordinate: routeCoordinates.first!)
                    Marker("Ende", coordinate: routeCoordinates.last!)
                }
            } else {
                ContentUnavailableView(
                    "Keine Route aufgezeichnet",
                    systemImage: "map.circle",
                    description: Text("Für diese Einheit wurden keine Standortdaten gespeichert.")
                )
            }
            
            // --- BEGINN DER ÄNDERUNGEN ---
            // Detailinformationen unter der Karte
            VStack(alignment: .leading, spacing: 15) {
                // Header-Information
                HStack(spacing: 15) {
                    Image(systemName: session.type == .running ? "figure.run" : "bicycle")
                        .font(.largeTitle)
                        .foregroundColor(.accentColor)
                    
                    VStack(alignment: .leading) {
                        Text(session.type.rawValue.capitalized)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Text(session.date, format: .dateTime.day().month(.wide).year())
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                
                Divider()
                
                // Grid-Layout für eine saubere und adaptive Darstellung
                Grid(alignment: .leading, horizontalSpacing: 20, verticalSpacing: 10) {
                    GridRow {
                        Text("Dauer")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Text(formattedDuration(session.duration))
                            .font(.title3)
                            .fontWeight(.semibold)
                            .gridCellAnchor(.leading)
                    }
                    // Hier könnten weitere Details hinzugefügt werden (z.B. Distanz, Kalorien)
                    // GridRow {
                    //     Text("Distanz")
                    //         .font(.headline)
                    //         .foregroundColor(.secondary)
                    //     Text("5.2 km")
                    //         .font(.title3)
                    //         .fontWeight(.semibold)
                    //         .gridCellAnchor(.leading)
                    // }
                }
            }
            .padding()
            .background(.thinMaterial)
            // --- ENDE DER ÄNDERUNGEN ---
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
