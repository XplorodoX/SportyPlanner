// SportyPlanner/SettingsView.swift

import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var isImporting = false
    
    // --- BEGINN DER ÄNDERUNGEN ---
    @State private var showingDeleteConfirmation = false
    // --- ENDE DER ÄNDERUNGEN ---

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Datenmanagement")) {
                    // Import-Button bleibt erhalten
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
                    
                    // --- BEGINN DER ÄNDERUNGEN ---
                    // Button zum Löschen aller Daten
                    Button(role: .destructive, action: {
                        showingDeleteConfirmation = true
                    }) {
                        Label("Alle Daten löschen", systemImage: "trash.fill")
                    }
                    // --- ENDE DER ÄNDERUNGEN ---
                }
                
                // --- BEGINN DER ÄNDERUNGEN ---
                Section(header: Text("Über die App")) {
                    HStack {
                        Text("Version")
                        Spacer()
                        // Holt die App-Version dynamisch aus dem Info.plist
                        Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0")
                            .foregroundColor(.secondary)
                    }
                }
                // --- ENDE DER ÄNDERUNGEN ---
            }
            .navigationTitle("Einstellungen")
            .formStyle(.grouped)
            .scrollContentBackground(.hidden)
            .alert(isPresented: $showingAlert) {
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            // --- BEGINN DER ÄNDERUNGEN ---
            // Bestätigungsdialog für das Löschen
            .alert("Bist du sicher?", isPresented: $showingDeleteConfirmation) {
                Button("Alle Daten löschen", role: .destructive, action: deleteAllData)
                Button("Abbrechen", role: .cancel) {}
            } message: {
                Text("Diese Aktion kann nicht rückgängig gemacht werden. Alle Workouts und Cardio-Einheiten werden dauerhaft entfernt.")
            }
            // --- ENDE DER ÄNDERUNGEN ---
        }
    }

    private func importHealthData() {
        // ... (unveränderter Code)
        isImporting = true
        HealthKitManager.shared.requestAuthorization { [self] success, error in
            if success {
                HealthKitManager.shared.importWorkoutsFromHealthKit(modelContext: modelContext) { importedCount, importError in
                    DispatchQueue.main.async {
                        self.isImporting = false
                        if let importError = importError {
                            self.alertTitle = "Importfehler"
                            self.alertMessage = "Beim Importieren der Daten ist ein Fehler aufgetreten: \(importError.localizedDescription)"
                        } else {
                            self.alertTitle = "Import erfolgreich"
                            self.alertMessage = "\(importedCount) Aktivitäten wurden erfolgreich importiert."
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
    
    // --- BEGINN DER ÄNDERUNGEN ---
    /// Löscht alle Workout- und Cardio-Daten aus SwiftData.
    private func deleteAllData() {
        do {
            try modelContext.delete(model: Workout.self)
            try modelContext.delete(model: CardioSession.self)
            
            alertTitle = "Erfolgreich gelöscht"
            alertMessage = "Alle Daten wurden entfernt."
            showingAlert = true
            
        } catch {
            alertTitle = "Fehler beim Löschen"
            alertMessage = "Die Daten konnten nicht vollständig gelöscht werden: \(error.localizedDescription)"
            showingAlert = true
        }
    }
    // --- ENDE DER ÄNDERUNGEN ---
}
