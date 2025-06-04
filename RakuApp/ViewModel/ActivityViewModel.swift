//
//  ActivityViewModel.swift
//  RakuApp
//
//  Created by student on 03/06/25.
//

import Foundation
import HealthKit

@MainActor
class ActivityViewModel: ObservableObject {
    private let healthKitManager = HealthKitManager()
    private let authViewModel: AuthViewModel
    
    @Published var calories: Double = 0.0
    @Published var standingTime: Double = 0.0
    @Published var exerciseTime: Double = 0.0
    @Published var userName: String = ""
    @Published var userExperience: String = ""


    init(authViewModel: AuthViewModel) {
        self.authViewModel = authViewModel
    }

    func fetchData() async {
        guard authViewModel.isSignedIn else { return }

        self.calories = await healthKitManager.fetchTodayCalories()
        self.standingTime = await healthKitManager.fetchStandingTime()
        self.exerciseTime = await healthKitManager.fetchTodayExerciseTime()
//        self.userName = authViewModel.userViewModel.myUserData.name
//        self.userExperience = authViewModel.userViewModel.myUserData.experience
    }


    //reformat the decimals
    func formattedCalories(_ calories: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1
        return formatter.string(from: NSNumber(value: calories)) ?? "\(calories)"
    }
    
    
    func requestHealthAuthorizationIfNeeded() async {
        guard authViewModel.isSignedIn else {
            print("User not signed in; skipping HealthKit auth.")
            return
        }

        do {
            let success = try await healthKitManager.requestAuthorization()
            if success {
                await fetchData()
            } else {
                print("HealthKit authorization denied.")
            }
        } catch {
            print("HealthKit authorization error: \(error.localizedDescription)")
        }
    }


}
