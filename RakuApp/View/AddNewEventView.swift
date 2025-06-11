//
//  AddNewEventView.swift
//  RakuApp
//
//  Created by Surya on 28/05/25.
//

import SwiftUI
struct AddNewEventView: View {

    @State private var showDatePicker = false
    @State private var showTimePicker = false

    // binder
    @Binding var isAddEvent: Bool

    // state variables
    @State var name: String = ""
    @State var description: String = ""
    @State var date: Date = Date()
    @State var courtCost: Double = 43000
    @State var isChooseFriend: Bool = false

    // Computed property to validate form
    var isFormValid: Bool {
        !name.isEmpty && !description.isEmpty && courtCost > 0
    }

    var body: some View {
        VStack {
            ProgressView(value: 0.33)
                .tint(Color(hex: "1F41BA"))

            // Name
            HStack {
                Text("Name your event")
                    .font(.headline)
                Spacer()
            }
            .padding(.top, 12)

            TextField("Enter Name of event", text: $name)
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(hex: "D1D1D1"), lineWidth: 1)
                )

            // Description
            HStack {
                Text("Describe your event")
                    .font(.headline)
                Spacer()
            }
            .padding(.top, 20)

            TextField("Enter Description of event", text: $description)
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(hex: "D1D1D1"), lineWidth: 1)
                )

            // Date of Event
            HStack {
                Text("Date of event")
                    .font(.headline)
                Spacer()
            }
            .padding(.top, 20)

            HStack {
                Button(action: {
                    date = Date()
                    showDatePicker = false
                }) {
                    Text("Today")
                        .foregroundColor(Color(hex: "253366"))
                        .padding(.horizontal, 32)
                        .padding(.vertical, 8)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                }

                Spacer()

                Button(action: {
                    date = Date(timeIntervalSinceNow: 86400)
                    showDatePicker = false
                }) {
                    Text("Tomorrow")
                        .foregroundColor(Color(hex: "253366"))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                }

                Spacer()

                Button(action: {
                    showDatePicker.toggle()
                }) {
                    Text("Choose Date")
                        .foregroundColor(Color(hex: "253366"))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                }
            }

            if showDatePicker {
                DatePicker(
                    "Select Date", selection: $date, displayedComponents: .date
                )
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                .padding(.top, 12)
            }

            // Time Picker
            HStack {
                Text("Choose your time")
                    .font(.headline)
                Spacer()

                Button(action: {
                    withAnimation {
                        showTimePicker.toggle()
                        showDatePicker = false
                    }
                }) {
                    Text("Choose Time")
                        .foregroundColor(Color(hex: "253366"))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                }
            }
            .padding(.top, 12)

            if showTimePicker {
                DatePicker(
                    "",
                    selection: $date,
                    displayedComponents: [.hourAndMinute]
                )
                .datePickerStyle(WheelDatePickerStyle())
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                .padding(.top, 12)
            }

            Text(
                "Selected: \(date.formatted(date: .abbreviated, time: .shortened))"
            )
            .font(.subheadline)
            .foregroundColor(.gray)
            .padding(.top, 8)

            // Court Cost
            HStack {
                Text("Cost of Court")
                    .font(.headline)
                Spacer()
            }
            .padding(.top, 20)

            TextField(
                "Enter Cost of Court",
                value: $courtCost,
                formatter: NumberFormatter.decimal
            )
            .keyboardType(.decimalPad)
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(hex: "D1D1D1"), lineWidth: 1)
            )

            Spacer()

            // Save Detail button (only enabled when valid)
            Button(action: {
                isChooseFriend = true
            }) {
                Text("Save Detail")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(isFormValid ? Color(hex: "1F41BA") : Color.gray)
                    .cornerRadius(10)
                    .font(.headline)
            }
            .frame(width: 361, height: 50)
            .padding(.bottom, 8)
            .disabled(!isFormValid)
        }
        .padding(.horizontal, 12)
        .background(Color(hex: "F7F7F7"))
        .navigationTitle("Add Event")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $isChooseFriend) {
            NavigationStack {
                AddFriendView(
                    isAddEvent: $isAddEvent,
                    isChooseFriend: $isChooseFriend,
                    name: $name,
                    description: $description,
                    date: $date,
                    courtCost: $courtCost
                )
            }
        }
    }
}
