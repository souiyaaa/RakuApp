//
//  ActivityViewModel.swift
//  RakuApp
//
//  Created by Surya on 03/06/25.
//

import FirebaseDatabase
import Foundation
import HealthKit

class ActivityViewModel: ObservableObject {

    let healthStore = HKHealthStore()
    private var ref: DatabaseReference
    @Published var activities = [Activity]()
    @Published var userViewModel: UserViewModel
    @Published var isTracking: Bool = false

    @Published var latestActivity: Activity?

    
    private var startDate: Date?
    private var endDate: Date?

    @Published var isTrackingWorkout = false

    init(userViewModel: UserViewModel) {
        self.userViewModel = userViewModel
        self.ref = Database.database().reference().child("activities")

        let energy = HKQuantityType(.activeEnergyBurned)
        let exerciseTime = HKQuantityType(.appleExerciseTime)
        let standingTime = HKQuantityType(.appleStandTime)

        let healthTypes: Set = [energy, exerciseTime, standingTime]

        Task {
            do {
                try await healthStore.requestAuthorization(
                    toShare: [], read: healthTypes)
            } catch {
                print("HealthKit auth error: \(error)")
            }
        }
    }

    func triggerWorkout() {
        isTracking.toggle()

        if isTracking {
            startWorkout()
        } else {
            endWorkout()
        }
    }

    private func startWorkout() {
        startDate = Date()
        isTrackingWorkout = true
    }
    
   //fetchlatestactivity disini
    func fetchLatestActivity() {
        let currentUserId = userViewModel.myUserData.id
        let userActivityRef = ref.child(currentUserId)

        userActivityRef.observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value as? [String: Any] else {
                print("No activity data found.")
                return
            }

            // Convert to [Activity] first
            let allActivities = value.compactMap { (key, activityData) -> Activity? in
                guard let activityDict = activityData as? [String: Any],
                      let jsonData = try? JSONSerialization.data(withJSONObject: activityDict),
                      let activity = try? JSONDecoder().decode(Activity.self, from: jsonData)
                else {
                    return nil
                }
                return activity
            }

            // Sort by date descending and get the latest one
            let latestActivity = allActivities.sorted(by: { $0.date > $1.date }).first

            DispatchQueue.main.async {
                if let latest = latestActivity {
                    self.activities = [latest]
                } else {
                    self.activities = []
                }
            }
        }
    }



    private func endWorkout() {
        guard let start = startDate else { return }
        endDate = Date()
        isTrackingWorkout = false

        fetchCombinedActivityData()
    }
    
    private func workoutDuration() -> TimeInterval? {
        guard let start = startDate, let end = endDate else { return nil }
        return end.timeIntervalSince(start)
    }
    
    
    //fetching all datas needed
    func fetchCombinedActivityData() {
        
        print("masuk ke fetchcombined")
        guard let start = startDate, let end = endDate else {
            print("Invalid start or end date")
            return
        }
        print(start, "start")
        print(end, "end")
        let caloriesType = HKQuantityType(.activeEnergyBurned)
        let exerciseType = HKQuantityType(.appleExerciseTime)
        let standingType = HKQuantityType(.appleStandTime)

        let predicate = HKQuery.predicateForSamples(withStart: start, end: end)

        let dispatchGroup = DispatchGroup()

        var calories: Double?
        var exerciseMinutes: Double?
        var standingMinutes: Double?

        // Calories Query
        dispatchGroup.enter()
        let caloriesQuery = HKStatisticsQuery(quantityType: caloriesType, quantitySamplePredicate: predicate) {
            _, result, error in
            if let quantity = result?.sumQuantity(), error == nil {
                calories = quantity.doubleValue(for: .kilocalorie())
            } else {
                print("Error fetching calories:", error?.localizedDescription ?? "Unknown")
            }
            dispatchGroup.leave()
        }

        // Exercise Time Query
        dispatchGroup.enter()
        let exerciseQuery = HKStatisticsQuery(quantityType: exerciseType, quantitySamplePredicate: predicate) {
            _, result, error in
            if let quantity = result?.sumQuantity(), error == nil {
                exerciseMinutes = quantity.doubleValue(for: .minute())
            } else {
                print("Error fetching exercise time:", error?.localizedDescription ?? "Unknown")
            }
            dispatchGroup.leave()
        }

        // Standing Time Query
        dispatchGroup.enter()
        let standingQuery = HKStatisticsQuery(quantityType: standingType, quantitySamplePredicate: predicate) {
            _, result, error in
            if let quantity = result?.sumQuantity(), error == nil {
                standingMinutes = quantity.doubleValue(for: .minute())
            } else {
                print("Error fetching standing time:", error?.localizedDescription ?? "Unknown")
            }
            dispatchGroup.leave()
        }

        // Execute queries
        healthStore.execute(caloriesQuery)
        healthStore.execute(exerciseQuery)
        healthStore.execute(standingQuery)

        // When all queries complete
        dispatchGroup.notify(queue: .main) {
            guard let calories = calories,
                  let exerciseMinutes = exerciseMinutes,
                  let standingMinutes = standingMinutes else {
                print("One or more data points were not fetched.")
                return
            }

            let activity = Activity(
                userId: self.userViewModel.myUserData.id,
                calories: calories,
                exerciseMinutes: exerciseMinutes,
                standingMinutes: standingMinutes,
                date: start
            )

            guard let jsonData = try? JSONEncoder().encode(activity),
                  let json = try? JSONSerialization.jsonObject(with: jsonData) as? [String: Any] else {
                print("Error converting activity to JSON")
                return
            }

            self.ref.child(activity.id).setValue(json)
            print("Activity successfully written to Firebase")
        }
    }



    func fetchStandTime() {
        let standingTime = HKQuantityType(.appleStandTime)
        let predicate = HKQuery.predicateForSamples(
            withStart: startDate, end: endDate)
        let query = HKStatisticsQuery(
            quantityType: standingTime, quantitySamplePredicate: predicate
        ) {
            _, result, error in
            guard let quantity = result?.sumQuantity(), error == nil else {
                print("error fetching standing time")
                return
            }
            let standingMinutes = quantity.doubleValue(for: .minute())
            //            print(quantity.doubleValue(for: .count()))

            let activity = Activity(
                userId: self.userViewModel.myUserData.id, calories: 100.1,
                exerciseMinutes: 100, standingMinutes: standingMinutes,
                date: self.startDate ?? Date())

            //save to firebase model
            guard let jsonData = try? JSONEncoder().encode(activity),
                let json = try? JSONSerialization.jsonObject(with: jsonData)
                    as? [String: Any]
            else {
                return print("error converting to JSON")
            }

            self.ref
                .child(activity.userId)
                .child(activity.id)
                .setValue(json)
            return print("successful converting to JSON")
        }

        healthStore.execute(query)
    }

    func fetchTodayEnergyBurn() {
        let calories = HKQuantityType(.activeEnergyBurned)
        let predicate = HKQuery.predicateForSamples(
            withStart: startDate, end: endDate)
        let query = HKStatisticsQuery(
            quantityType: calories, quantitySamplePredicate: predicate
        ) {
            _, result, error in
            guard let quantity = result?.sumQuantity(), error == nil else {
                print("error fetching calories")
                return
            }

            let caloriesKcal = quantity.doubleValue(for: .count())

            let activity = Activity(
                userId: self.userViewModel.myUserData.id, calories: caloriesKcal,
                exerciseMinutes: 100, standingMinutes: 12, date: self.startDate ?? Date())

            //save to firebase model
            guard let jsonData = try? JSONEncoder().encode(activity),
                let json = try? JSONSerialization.jsonObject(with: jsonData)
                    as? [String: Any]
            else {
                return print("error converting to JSON")
            }

            self.ref
                .child(activity.userId)
                .child(activity.id)
                .setValue(json)
            return print("successful converting to JSON")

        }
        healthStore.execute(query)
    }
    
    func fetchExerciseTime(){
        let exerciseTime = HKQuantityType(.appleExerciseTime)
        let predicate = HKQuery.predicateForSamples(
            withStart: startDate, end: endDate)
        let query = HKStatisticsQuery(
            quantityType: exerciseTime, quantitySamplePredicate: predicate
        ) {
            _, result, error in guard let quantity = result?.sumQuantity(), error == nil else {
                print("error fetching exercise time because of ", error)
                return
            }
            
            let exerciseMinute = quantity.doubleValue(for: .minute())
            
            let activity = Activity(
                userId: self.userViewModel.myUserData.id, calories: 123,
                exerciseMinutes: exerciseMinute, standingMinutes: 12, date: self.startDate ?? Date())

            //save to firebase model
            guard let jsonData = try? JSONEncoder().encode(activity),
                let json = try? JSONSerialization.jsonObject(with: jsonData)
                    as? [String: Any]
            else {
                return print("error converting to JSON")
            }

            self.ref
                .child(activity.userId)
                .child(activity.id)
                .setValue(json)
            return print("successful converting to JSON")
            
        }
        healthStore.execute(query)
    }
}
