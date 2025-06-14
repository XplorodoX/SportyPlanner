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
                    VStack(alignment: .leading) {
                        Text("\(session.type.rawValue.capitalized) am \(session.date, format: .dateTime.day().month())")
                            .font(.headline)
                        Text("Dauer: \(formattedDuration(session.duration))")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .onDelete(perform: deleteSessions)
            }
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
