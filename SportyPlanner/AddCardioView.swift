import SwiftUI
import SwiftData

struct AddCardioView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var type: CardioSession.ActivityType = .running
    @State private var date: Date = .now
    @State private var durationHours: Int = 0
    @State private var durationMinutes: Int = 30

    private var duration: TimeInterval {
        return TimeInterval((durationHours * 60 + durationMinutes) * 60)
    }

    var body: some View {
        NavigationStack {
            Form {
                Picker("Typ", selection: $type) {
                    Text("Laufen").tag(CardioSession.ActivityType.running)
                    Text("Radfahren").tag(CardioSession.ActivityType.cycling)
                }
                .pickerStyle(.segmented)
                
                DatePicker("Datum", selection: $date, displayedComponents: .date)
                
                Section("Dauer") {
                    Stepper("\(durationHours) Stunden", value: $durationHours, in: 0...23)
                    Stepper("\(durationMinutes) Minuten", value: $durationMinutes, in: 0...59, step: 5)
                }
            }
            .navigationTitle("Neue Kardio-Einheit")
            .formStyle(.grouped)
            .scrollContentBackground(.hidden)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Abbrechen") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Speichern") {
                        saveSession()
                        dismiss()
                    }
                }
            }
        }
    }

    private func saveSession() {
        let newSession = CardioSession(type: type, date: date, duration: duration, locations: [])
        modelContext.insert(newSession)
        // In HealthKit speichern
        HealthKitManager.shared.saveCardioSession(newSession)
    }
}

