////
////  sleeptracker.swift
////  vitalio_native
////
////  Created by HID-18 on 04/08/25.
////
//import SwiftUI
//import Charts
//
//struct SleepTrackerView: View {
//    var body: some View {
//        ZStack {
//            RoundedRectangle(cornerRadius: 20)
//                .fill(Color(.systemPurple).opacity(0.1))
//                .frame(height: 160)
//
//            HStack {
//                VStack(alignment: .leading, spacing: 12) {
//                    HStack(spacing: 8) {
//                        Image(systemName: "bed.double.fill")
//                            .foregroundColor(.indigo)
//                        Text("Sleep Tracker")
//                            .font(.headline)
//                            .foregroundColor(.black)
//                    }
//
//                    HStack(alignment: .lastTextBaseline, spacing: 4) {
//                        Image(systemName: "moon.zzz.fill")
//                            .foregroundColor(.indigo)
//                        Text("06h")
//                            .font(.system(size: 36, weight: .bold))
//                            .foregroundColor(.black)
//                        Text("41m")
//                            .font(.system(size: 28, weight: .medium))
//                            .foregroundColor(.black)
//                    }
//
//                    HStack(spacing: 4) {
//                        Image(systemName: "arrow.up.right")
//                            .font(.caption)
//                            .foregroundColor(.gray)
//                        Text("21min more than yesterday")
//                            .font(.footnote)
//                            .foregroundColor(.gray)
//                    }
//                }
//                .padding()
//
//                Spacer()
//
//                SleepGraphView()
//                    .frame(width: 130, height: 100)
//                    .padding(.trailing)
//            }
//        }
//        .padding()
//    }
//}
//
//struct SleepDataPoint: Identifiable {
//    let id = UUID()
//    let hour: Int
//    let stage: Double
//}
//
//struct SleepGraphView: View {
//    let data: [SleepDataPoint] = [
//        .init(hour: 0, stage: 2),
//        .init(hour: 1, stage: 1),
//        .init(hour: 2, stage: 2.5),
//        .init(hour: 3, stage: 1.2),
//        .init(hour: 4, stage: 2.8),
//        .init(hour: 5, stage: 1.5),
//        .init(hour: 6, stage: 2.1),
//        .init(hour: 7, stage: 1.3),
//        .init(hour: 8, stage: 3)
//    ]
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 4) {
//            HStack(spacing: 12) {
//                Text("Awake")
//                    .font(.caption2)
//                    .foregroundColor(.gray)
//                Text("Light")
//                    .font(.caption2)
//                    .foregroundColor(.gray)
//                Text("Deep")
//                    .font(.caption2)
//                    .foregroundColor(.gray)
//            }
//
//            Chart(data) {
//                LineMark(
//                    x: .value("Hour", $0.hour),
//                    y: .value("Stage", $0.stage)
//                )
//                .interpolationMethod(.catmullRom)
//                .foregroundStyle(.indigo)
//                .lineStyle(StrokeStyle(lineWidth: 2))
//            }
//            .chartYAxis(.hidden)
//            .chartXAxis(.hidden)
//        }
//    }
//}
//
//#Preview{
//    SleepTrackerView()
//}
