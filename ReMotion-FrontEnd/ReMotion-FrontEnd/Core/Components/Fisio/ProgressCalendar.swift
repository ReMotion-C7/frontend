//
//  ProgressCalendar.swift
//  ReMotion-FrontEnd
//
//  Created by Gabriela on 14/11/25.
//

import SwiftUI

struct ProgressCalendar: View {
    @State private var currentMonth = Date()
    @State private var sessionDates: Set<Date> = []
    
    let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 7)
    let daysOfWeek = ["Sen", "Sel", "Rab", "Kam", "Jum", "Sab", "Min"]
    
    init() {
        _sessionDates = State(initialValue: getHardcodedSessionDates())
    }
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Kalender Progress")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.primary)
                
                Text("Pantau sesi latihanmu.")
                    .font(.system(size: 15))
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 24)
            .padding(.top, 24)
            .padding(.bottom, 32)
            
            HStack(spacing: 20) {
                Button(action: previousMonth) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.primary)
                        .frame(width: 44, height: 44)
                        .background(Color.gray.opacity(0.1))
                        .clipShape(Circle())
                }
                
                VStack(spacing: 4) {
                    Text(monthYearString())
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.primary)
                    
                    Text("\(completedDaysInMonth()) sesi terselesaikan.")
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                
                Button(action: nextMonth) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.primary)
                        .frame(width: 44, height: 44)
                        .background(Color.gray.opacity(0.1))
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 32)
            
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(daysOfWeek, id: \.self) { day in
                    Text(day)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 16)
            
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(getDaysInMonth(), id: \.self) { date in
                    if let date = date {
                        DayCell(
                            date: date,
                            hasSession: hasSession(date),
                            isToday: Calendar.current.isDateInToday(date),
                            isFuture: date > Date()
                        )
                    } else {
                        Color.clear
                            .frame(height: 56)
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 32)
        
            
            Spacer()
        }
        .background(Color(UIColor.systemGroupedBackground))
    }

    
    func monthYearString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        formatter.locale = Locale(identifier: "id_ID")
        return formatter.string(from: currentMonth)
    }
    
    func previousMonth() {
        withAnimation(.easeInOut(duration: 0.3)) {
            currentMonth = Calendar.current.date(byAdding: .month, value: -1, to: currentMonth) ?? currentMonth
        }
    }
    
    func nextMonth() {
        withAnimation(.easeInOut(duration: 0.3)) {
            currentMonth = Calendar.current.date(byAdding: .month, value: 1, to: currentMonth) ?? currentMonth
        }
    }
    
    func getDaysInMonth() -> [Date?] {
        let calendar = Calendar.current
        let interval = calendar.dateInterval(of: .month, for: currentMonth)!
        let firstWeekday = calendar.component(.weekday, from: interval.start)
        let adjustedFirstWeekday = (firstWeekday + 5) % 7
        var days: [Date?] = Array(repeating: nil, count: adjustedFirstWeekday)

        var date = interval.start
        while date < interval.end {
            days.append(date)
            date = calendar.date(byAdding: .day, value: 1, to: date)!
        }
        
        return days
    }
    
    func hasSession(_ date: Date) -> Bool {
        sessionDates.contains { Calendar.current.isDate($0, inSameDayAs: date) }
    }
    
    func completedDaysInMonth() -> Int {
        let calendar = Calendar.current
        return sessionDates.filter { calendar.isDate($0, equalTo: currentMonth, toGranularity: .month) }.count
    }
    
    func getCurrentStreak() -> Int {
        let calendar = Calendar.current
        let sortedDates = sessionDates.sorted(by: >)
        var streak = 0
        var checkDate = calendar.startOfDay(for: Date())
        
        for date in sortedDates {
            if calendar.isDate(date, inSameDayAs: checkDate) {
                streak += 1
                checkDate = calendar.date(byAdding: .day, value: -1, to: checkDate)!
            } else if date < checkDate {
                break
            }
        }
        
        return streak
    }
}

struct DayCell: View {
    let date: Date
    let hasSession: Bool
    let isToday: Bool
    let isFuture: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(backgroundColor)
                .shadow(color: shadowColor, radius: hasSession ? 8 : 0, x: 0, y: 4)
            
            VStack(spacing: 4) {
                Text("\(Calendar.current.component(.day, from: date))")
                    .font(.system(size: 16, weight: isToday ? .bold : .medium))
                    .foregroundColor(textColor)
                
                if hasSession {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                }
            }
        }
        .frame(height: 56)
        .opacity(isFuture ? 0.3 : 1.0)
        .scaleEffect(hasSession ? 1.0 : 0.95)
    }
    
    var backgroundColor: Color {
        if hasSession {
            return Color.green
        } else if isToday {
            return Color.blue.opacity(0.15)
        } else {
            return Color(UIColor.secondarySystemGroupedBackground)
        }
    }
    
    var textColor: Color {
        if hasSession {
            return .white
        } else if isToday {
            return .blue
        } else {
            return .primary
        }
    }
    
    var shadowColor: Color {
        Color.green.opacity(0.3)
    }
}


func getHardcodedSessionDates() -> Set<Date> {
    let calendar = Calendar.current
    var dates = Set<Date>()
    
    let sessionDays = [

        DateComponents(year: 2025, month: 10, day: 27),
        DateComponents(year: 2025, month: 10, day: 28),
        DateComponents(year: 2025, month: 10, day: 29),
        DateComponents(year: 2025, month: 10, day: 30),
        DateComponents(year: 2025, month: 10, day: 31),
        DateComponents(year: 2025, month: 11, day: 1),
        DateComponents(year: 2025, month: 11, day: 2),
        DateComponents(year: 2025, month: 11, day: 3),
        DateComponents(year: 2025, month: 11, day: 4),
        DateComponents(year: 2025, month: 11, day: 8),
        DateComponents(year: 2025, month: 11, day: 9),
        DateComponents(year: 2025, month: 11, day: 10),
        DateComponents(year: 2025, month: 11, day: 11),
        DateComponents(year: 2025, month: 11, day: 12),
        DateComponents(year: 2025, month: 11, day: 13),
        DateComponents(year: 2025, month: 11, day: 14),
    ]
    
    for dayComponent in sessionDays {
        if let date = calendar.date(from: dayComponent) {
            dates.insert(calendar.startOfDay(for: date))
        }
    }
    
    return dates
}

#Preview {
    ProgressCalendar()
}
