import SwiftUI
import SwiftData

struct CardioListView: View {
    @Query private var sessions: [CardioSession]

    var body: some View {
        NavigationStack {
            List {
                ForEach(sessions) { session in
                    Text(session.type.rawValue.capitalized)
                }
            }
            .navigationTitle("Cardio")
        }
    }
}
