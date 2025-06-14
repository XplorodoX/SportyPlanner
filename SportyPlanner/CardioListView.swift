// SportyPlanner/CardioListView.swift

import SwiftUI
import SwiftData

struct CardioListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \CardioSession.date, order: .reverse) private var sessions: [CardioSession]
    @State private var isAddingSession = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(sessions) { session in
                    NavigationLink(destination: CardioDetailView(session: session)) {
                        HStack(spacing: 15) {
                            // --- BEGINN DER ÄNDERUNGEN ---
                            // Icon bleibt unverändert
                            Image(systemName: session.type == .running ? "figure.run" : "bicycle")
                                .font(.title)
                                .foregroundColor(.white)
                                .frame(width: 50, height: 50)
                                .background(Color.accentColor.gradient)
                                .clipShape(Circle())
                            
                            // Flexible Anordnung für Titel und Datum
                            VStack(alignment: .leading, spacing: 4) {
                                Text(session.type.rawValue.capitalized)
                                    .font(.headline)
                                    .lineLimit(1) // Verhindert Umbruch bei sehr langen Namen
                                Text(session.date, format: .dateTime.day().month().year())
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer() // Sorgt für flexible Breite
                            
                            // Dauer wird rechtsbündig angezeigt
                            Text(formattedDuration(session.duration))
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.secondary)
                            // --- ENDE DER ÄNDERUNGEN ---
                        }
                        .padding(.vertical, 8)
                    }
                }
                .onDelete(perform: deleteSessions)
            }
            .listStyle(.plain)
            .navigationTitle("Cardio")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { isAddingSession = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $isAddingSession) {
                AddCardioView()
            }
        }
    }

    private func deleteSessions(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(sessions[index])
        }
    }

    private func formattedDuration(_ duration: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: duration) ?? ""
    }
}
