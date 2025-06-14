import SwiftUI

struct WeekCalendarView: View {
    private var weekDates: [Date] {
        Calendar.current.datesOfWeek(containing: Date())
    }

    var body: some View {
        VStack {
            HStack {
                ForEach(weekDates, id: \.self) { date in
                    VStack {
                        Text(date, format: .dateTime.weekday(.narrow))
                            .font(.caption)
                        Text(date, format: .dateTime.day())
                            .fontWeight(Calendar.current.isDateInToday(date) ? .bold : .regular)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(Calendar.current.isDateInToday(date) ? Color.accentColor.opacity(0.2) : Color(.secondarySystemBackground))
                    .cornerRadius(8)
                }
            }
            .padding()
            Spacer()
        }
        .navigationTitle("Week")
    }
}

extension Calendar {
    func datesOfWeek(containing date: Date) -> [Date] {
        guard let weekInterval = dateInterval(of: .weekOfYear, for: date) else { return [] }
        return (0..<7).compactMap { day in
            self.date(byAdding: .day, value: day, to: weekInterval.start)
        }
    }
}

#Preview {
    WeekCalendarView()
}
