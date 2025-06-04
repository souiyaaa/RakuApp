import SwiftUI

struct CalendarView: View {
    @StateObject private var viewModel = CalendarViewModel()
    @State private var showCreateEventSheet = false
    @State var isAddEvent = false

    let months = Calendar.current.monthSymbols

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            HStack {
                Menu {
                    ForEach(1...12, id: \.self) { month in
                        Button {
                            viewModel.selectedMonth = month
                            viewModel.updateDays()
                        } label: {
                            Text(months[month - 1])
                        }
                    }
                } label: {
                    HStack(spacing: 6) {
                        Text(months[viewModel.selectedMonth - 1])
                        Image(systemName: "chevron.down")
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.2), radius: 2, x: 2, y: 2)
                    .foregroundColor(Color(hex: "253366"))
                }


                Spacer()

                Button("Add Event") {
                    isAddEvent = true
                }
                .sheet(isPresented: $isAddEvent) {
                    AddNewEventView(isAddEvent: $isAddEvent)
                        .presentationDragIndicator(.visible)                }

                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(Color.white)
                .cornerRadius(12)
                .foregroundColor(Color(hex: "253366"))
            }
            .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(viewModel.daysInMonth) { day in
                        VStack(spacing: 6) {
                            Text(day.dayName)
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(Color(hex: "253366"))

                            Text(day.dayNumber)
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(Color(hex: "253366"))
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal, 16)
                        .background(
                            Group {
                                if viewModel.selectedDay == day.date {
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color(hex: "253366"), lineWidth: 2)
                                        .background(Color(hex: "F1F4FF").cornerRadius(12))
                                } else {
                                    Color.clear
                                }
                            }
                                .padding(.top,5)
                                .padding(.bottom,5)
                            
                        )

                        .onTapGesture {
                            viewModel.selectedDay = day.date
                        }
                    }
                }
                .padding(.horizontal)
            
            }

            Spacer()
        }
        .onAppear {
            viewModel.updateDays()
        }
    }
}

#Preview {
    CalendarView()
}
