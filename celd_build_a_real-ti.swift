import Foundation
import SwiftUI

// Real-time DevOps Pipeline Tracker

struct Pipeline: Identifiable {
    let id = UUID()
    var name: String
    var stages: [Stage]
}

struct Stage: Identifiable {
    let id = UUID()
    var name: String
    var status: Status
}

enum Status: String {
    case pending, inProgress, success, failed
}

class PipelineTracker: ObservableObject {
    @Published var pipelines: [Pipeline] = []

    func updateStage(pipeline: Pipeline, stage: Stage, status: Status) {
        if let index = pipelines.firstIndex(where: { $0.id == pipeline.id }) {
            if let stageIndex = pipelines[index].stages.firstIndex(where: { $0.id == stage.id }) {
                pipelines[index].stages[stageIndex].status = status
            }
        }
    }
}

struct PipelineTrackerView: View {
    @StateObject var tracker = PipelineTracker()

    var body: some View {
        NavigationView {
            List(tracker.pipelines) { pipeline in
                NavigationLink(destination: StageListView(pipeline: pipeline)) {
                    VStack(alignment: .leading) {
                        Text(pipeline.name)
                            .font(.headline)
                        Text("Stages: \(pipeline.stages.count)")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Pipelines")
        }
    }
}

struct StageListView: View {
    let pipeline: Pipeline

    var body: some View {
        List(pipeline.stages) { stage in
            VStack(alignment: .leading) {
                Text(stage.name)
                    .font(.headline)
                Text("Status: \(stage.status.rawValue)")
                    .foregroundColor(stage.status == .success ? .green : (stage.status == .failed ? .red : .secondary))
            }
        }
        .navigationTitle(pipeline.name)
    }
}

@main
struct PipelineTrackerApp: App {
    @StateObject var tracker = PipelineTracker()

    var body: some Scene {
        WindowGroup {
            PipelineTrackerView()
                .environmentObject(tracker)
        }
    }
}