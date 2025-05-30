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

    //binder
    @Binding var isAddEvent: Bool
    

    //state variable that will bind to other page
    @State var name: String = ""
    @State var description: String = ""
    @State var date: Date = Date()
    @State var courtCost: Double = 43000
    @State var isChooseFriend: Bool = false
    

    var body: some View {
        VStack {
            ProgressView(value: 0.33)

                .tint(Color(hex: "1F41BA"))

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
                .onChange(of: name) {
                    if !name.isEmpty && !description.isEmpty && courtCost <= 0 {
                        isChooseFriend = false
                    } else {
                      
                    }
                }

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
                .onChange(of: description) {
                    if !name.isEmpty && !description.isEmpty && courtCost <= 0 {
                        isChooseFriend = false
                    } else {
                       
                    }
                }

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
                    Text("Today ")
                        .foregroundColor(Color(hex: "253366"))
                        .padding(.horizontal, 32)
                        .padding(.vertical, 8)
                        .background(Color.white)
                        .cornerRadius(12)  // rounded corners
                        .shadow(
                            color: Color.black.opacity(0.1), radius: 4, x: 0,
                            y: 2)  // gentle shadow
                }

                Spacer()

                Button(action: {
                    date = Date(timeInterval: 86400, since: Date())
                    showDatePicker = false
                }) {
                    Text("Tomorrow ")
                        .foregroundColor(Color(hex: "253366"))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.white)
                        .cornerRadius(12)  // rounded corners
                        .shadow(
                            color: Color.black.opacity(0.1), radius: 4, x: 0,
                            y: 2)  // gentle shadow
                }

                Spacer()

                Button(action: {
                    showDatePicker.toggle()
                }) {
                    Text("Choose Date ")
                        .foregroundColor(Color(hex: "253366"))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.white)
                        .cornerRadius(12)  // rounded corners
                        .shadow(
                            color: Color.black.opacity(0.1), radius: 4, x: 0,
                            y: 2)  // gentle shadow
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

            //show time
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
                        .shadow(
                            color: Color.black.opacity(0.1), radius: 4, x: 0,
                            y: 2)
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

            // Show current date and time nicely formatted:
            Text(
                "Selected: \(date.formatted(date: .abbreviated, time: .shortened))"
            )
            .font(.subheadline)
            .foregroundColor(.gray)
            .padding(.top, 8)
            
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
            .onChange(of: courtCost) {
                if !name.isEmpty && !description.isEmpty && courtCost > 0 {
                    isChooseFriend = false
                } else {
                   
                }
            }
            
            Spacer()
            Button(
                action: {
                    isChooseFriend = true
                    }
            ) {
                Text("Save Detail")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(Color(hex: "1F41BA"))
                    .cornerRadius(10)
                    .font(.headline)
            }
            .frame(width: 361, height: 50)
            .padding(.bottom, 8)
            
            
        }
        .padding(.horizontal, 12)
        .background(Color(hex: "F7F7F7"))
        .navigationTitle("Add Event")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $isChooseFriend) {
            NavigationStack {
                AddFriendView(isAddEvent: $isAddEvent, isChooseFriend: $isChooseFriend, name:$name, description: $description, date: $date, courtCost: $courtCost)
            }
        }
    }
}

#Preview {
    AddNewEventView(isAddEvent: .constant(true))
}
