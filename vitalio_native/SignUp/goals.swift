//
//  goals.swift
//  vitalio_native
//
//  Created by HID-18 on 25/08/25.
//

import SwiftUI

struct Goal: Identifiable {
    var id = UUID()
    var vmId: Int
    var targetValue: Double
    var unit: String
}

struct ActivityItem: View {
    var imageName: String
    var title: String
    var value: String
    var action: () -> Void
    
    var body: some View {
        VStack(spacing: 8) {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .foregroundColor(.blue)
            
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.black.opacity(0.7))
            
            // ✅ Show the current selected value
            Text(value)
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(.gray)
        }
        .frame(width: 90, height: 90)
        .onTapGesture {
            action()
        }
    }
}

struct ActivityGrid: View {
    @State private var selectedGoal: Goal? = nil
    @State private var showSheet = false
    @State private var goals: [String: Goal] = [
        "Steps": Goal(vmId: 234, targetValue: 7000, unit: "steps/day"),
        "Calories": Goal(vmId: 244, targetValue: 2000, unit: "kcal/day"),
        "Water": Goal(vmId: 245, targetValue: 2.5, unit: "liters/day"),
        "Sleep": Goal(vmId: 243, targetValue: 7.5, unit: "hours/night")
    ]
    
    let items = [
        ("steps_icon", "Steps"),
        ("calories_icon", "Calories"),
        ("water_icon", "Water"),
        ("sleep_icon", "Sleep")
    ]
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 30) {
            ForEach(items, id: \.1) { item in
                let goal = goals[item.1]
                ActivityItem(
                    imageName: item.0,
                    title: item.1,
                    value: goal != nil ? String(format: "%.1f %@", goal!.targetValue, goal!.unit) : "--"
                ) {
                    if let goal = goal {
                        selectedGoal = goal
                        showSheet = true
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 20)
        .sheet(isPresented: $showSheet) {
            if let goal = selectedGoal {
                GoalBottomSheet(goal: goal) { updatedGoal in
                    // ✅ Update dictionary
                    if let key = goals.first(where: { $0.value.vmId == updatedGoal.vmId })?.key {
                        goals[key] = updatedGoal
                    }
                    selectedGoal = updatedGoal

                    // ✅ Print updated array of goals
                    let goalsArray = goals.values.map { g in
                        [
                            "vmId": g.vmId,
                            "targetValue": g.targetValue,
                            "unit": g.unit
                        ] as [String : Any]
                    }
                    print(goalsArray)
                }
            } else {
                Text("No Goal Selected")
            }
        }

    }
}

struct GoalBottomSheet: View {
    @State var goal: Goal
    var onSave: (Goal) -> Void
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Button("Cancel") {
                    dismiss()
                }
                Spacer()
            }
            
            Image(systemName: "figure.walk")
                .font(.system(size: 36))
                .foregroundColor(.blue)
            
            Text("Daily \(goal.unit.contains("steps") ? "Move Goal" : "Goal")")
                .font(.title3).bold()
            
            Text("Set a goal based on how active you are, or how active you’d like to be, each day.")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            HStack {
                Button(action: {
                    goal.targetValue = max(0, goal.targetValue - stepValue())
                }) {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 40, height: 40)
                        .overlay(Text("-").foregroundColor(.white).font(.title2))
                }
                
                Text("\(goal.targetValue, specifier: "%.1f")")
                    .font(.system(size: 40, weight: .bold))
                    .frame(width: 120)
                
                Button(action: {
                    goal.targetValue += stepValue()
                }) {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 40, height: 40)
                        .overlay(Text("+").foregroundColor(.white).font(.title2))
                }
            }
            
            Text(goal.unit.uppercased())
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Spacer()
            
            Button(action: {
                onSave(goal)
                dismiss()
            }) {
                Text("Set Goal")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(12)
            }
        }
        .padding()
    }
    
    private func stepValue() -> Double {
        switch goal.unit {
        case "steps/day": return 500
        case "kcal/day": return 50
        case "liters/day": return 0.1
        case "hours/night": return 0.5
        default: return 1
        }
    }
}
