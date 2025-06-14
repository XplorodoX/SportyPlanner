import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var isImporting = false

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Datenmanagement"), footer: Text("Importiere abgeschlossene Workouts und Cardio-Einheiten aus Apple Health.")) {
                    Button(action: importHealthData) {
                        if isImporting {
                            HStack {
                                Text("Importiere...")
                                Spacer()
                                ProgressView()
                            }
                        } else {
                            Label("Aus Health importieren", systemImage: "heart.text.square")
                        }
                    }
                    .disabled(isImporting)
                }
            }
            .navigationTitle("Einstellungen")
            .alert(isPresented: $showingAlert) {
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }

    private func importHealthData() {
        isImporting = true
        HealthKitManager.shared.requestAuthorization { [self] success, error in
            if success {
                HealthKitManager.shared.importWorkoutsFromHealthKit { importedCount, importError in
                    DispatchQueue.main.async {
                        self.isImporting = false
                        if let importError = importError {
                            self.alertTitle = "Importfehler"
                            self.alertMessage = "Beim Importieren der Daten ist ein Fehler aufgetreten: \(importError.localizedDescription)"
                        } else {
                            self.alertTitle = "Import erfolgreich"
                            self.alertMessage = "\(importedCount) Aktivitäten wurden erfolgreich importiert."
                            // Hier könnten die importierten Daten in SwiftData gespeichert werden
                            // In diesem Beispiel geben wir nur eine Erfolgsmeldung aus.
                        }
                        self.showingAlert = true
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.isImporting = false
                    self.alertTitle = "Zugriff verweigert"
                    self.alertMessage = "Der Zugriff auf HealthKit wurde verweigert. Bitte ändere die Berechtigungen in den Einstellungen."
                    self.showingAlert = true
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}
