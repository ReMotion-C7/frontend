//
//  ProgressCalendar.swift
//  ReMotion-FrontEnd
//
//  Created by Gabriela on 14/11/25.
//

import SwiftUI

struct ProgressCalendar: View {
    @State private var currentMonth = Date()
    
    let sessionDates: Set<Date>
    
    let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 7)
    let daysOfWeek = ["Sen", "Sel", "Rab", "Kam", "Jum", "Sab", "Min"]
    
    
    private var daysInMonth: [Date?] {
        let calendar = Calendar.current
        guard let interval = calendar.dateInterval(of: .month, for: currentMonth) else { return [] }
        
        let firstWeekday = calendar.component(.weekday, from: interval.start)
        let adjustedFirstWeekday = (firstWeekday == 1) ? 6 : (firstWeekday - 2)
        
        var days: [Date?] = Array(repeating: nil, count: adjustedFirstWeekday)
        
        var date = interval.start
        while date < interval.end {
            days.append(date)
            date = calendar.date(byAdding: .day, value: 1, to: date)!
        }
        
        return days
    }
    
    var body: some View {
        VStack(spacing: 0) {
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
                ForEach(0..<daysInMonth.count, id: \.self) { index in
                    let date = daysInMonth[index]
                    
                    if let validDate = date {
                        DayCell(
                            date: validDate,
                            hasSession: hasSession(validDate),
                            isToday: Calendar.current.isDateInToday(validDate),
                            isFuture: validDate > Date()
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
    
    func hasSession(_ date: Date) -> Bool {
        sessionDates.contains { Calendar.current.isDate($0, inSameDayAs: date) }
    }
    
    func completedDaysInMonth() -> Int {
        let calendar = Calendar.current
        return sessionDates.filter { calendar.isDate($0, equalTo: currentMonth, toGranularity: .month) }.count
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
        DateComponents(year: 2025, month: 11, day: 3),
        DateComponents(year: 2025, month: 11, day: 4),
        DateComponents(year: 2025, month: 11, day: 5),
    ]
    for dayComponent in sessionDays {
        if let date = calendar.date(from: dayComponent) {
            dates.insert(calendar.startOfDay(for: date))
        }
    }
    return dates
}

#Preview {
    ProgressCalendar(sessionDates: getHardcodedSessionDates())
}
