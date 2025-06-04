//
//  ActivityView.swift
//  RakuApp
//
//  Created by Surya on 22/05/25.
//

import SwiftUI

struct ActivityView: View {
    @EnvironmentObject var activityVM: ActivityViewModel
    
    var body: some View {
        VStack{
            HStack{
                Text("Last Workout Summary 📊")
                    .font(.headline)
                Spacer()
                
            }.padding()
            
            HStack{
                VStack{
                    Text("Total energy burned")
                        .font(.caption)
                        .foregroundColor(Color.gray)
                    
                    Text("\(formattedCalories())")
                        .multilineTextAlignment(.leading)
                        .fontWeight(.bold)
                }
                Spacer()
                VStack{
                    Text("Total standing time")
                        .font(.caption)
                        .foregroundColor(Color.gray)
                    
                    Text("\(formattedStandingMinutes())")
                        .multilineTextAlignment(.leading)
                        .fontWeight(.bold)
                }
                
                Spacer()
                
                VStack{
                    Text("Exercise Time Total")
                        .font(.caption)
                        .foregroundColor(Color.gray)
                    
                    Text("\(formattedExerciseMinutes())")
                        .multilineTextAlignment(.leading)
                        .fontWeight(.bold)
                }
            }.padding(12)
                
            
            Button(
                action: {
                    activityVM.triggerWorkout()
                }
            ) {
                Text(activityVM.isTracking ? "Stop Playing" : "I'm Playing!")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(activityVM.isTracking ? Color.red : Color(hex: "1F41BA"))
                    .cornerRadius(10)
                    .font(.headline)
            }
            .frame(width: 361, height: 50)
            .padding(.top, 30)
            
            
            Button(
                action: {
                    activityVM.fetchLatestActivity()
                }
            ) {
                Text("Refresh Activity")
                    .foregroundColor(Color(hex: "1F41BA"))
                    .fontWeight(.medium)
            }

            
            Spacer()
        }.navigationTitle("Activity")
           
    }
    
    private func formattedCalories() -> String {
        guard let activity = activityVM.latestActivity else { return "-- Kcal" }
        return String(format: "%.0f Kcal", activity.calories)
    }

    private func formattedStandingMinutes() -> String {
        guard let activity = activityVM.latestActivity else { return "-- Minutes" }
        return String(format: "%.0f Minutes", activity.standingMinutes)
    }

    private func formattedExerciseMinutes() -> String {
        guard let activity = activityVM.latestActivity else { return "-- Minutes" }
        return String(format: "%.0f Minutes", activity.exerciseMinutes)
    }
}

#Preview {
    let userVM = UserViewModel()
    let activityVM = ActivityViewModel(userViewModel: userVM)
    
    return ActivityView()
        .environmentObject(activityVM)
}
