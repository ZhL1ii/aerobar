import Foundation

final class SpacesRefreshScheduler {
    typealias SnapshotLoader = () -> [AnySpace]
    typealias PublishHandler = ([AnySpace]) -> Void

    private let debounceInterval: TimeInterval
    private let stateQueue = DispatchQueue(
        label: "moe.ciel.CielBar.spaces-refresh-scheduler")
    private let refreshQueue = DispatchQueue(
        label: "moe.ciel.CielBar.spaces-refresh-loader",
        qos: .background)
    private let snapshotLoader: SnapshotLoader
    private let publishHandler: PublishHandler

    private var scheduledRefresh: DispatchWorkItem?
    private var refreshRequestID = 0
    private var isRunning = false
    private var needsFollowUpRefresh = false
    private var isStopped = false
    private var lastPublishedSpaces: [AnySpace] = []

    init(
        debounceInterval: TimeInterval = 0.1,
        snapshotLoader: @escaping SnapshotLoader,
        publishHandler: @escaping PublishHandler
    ) {
        self.debounceInterval = debounceInterval
        self.snapshotLoader = snapshotLoader
        self.publishHandler = publishHandler
    }

    func requestRefresh(reason: String) {
        stateQueue.async { [weak self] in
            guard let self, !self.isStopped else { return }
            self.scheduleRefreshLocked(reason: reason)
        }
    }

    func stop() {
        stateQueue.async { [weak self] in
            guard let self else { return }
            self.isStopped = true
            self.scheduledRefresh?.cancel()
            self.scheduledRefresh = nil
            self.refreshRequestID += 1
            self.needsFollowUpRefresh = false
        }
    }

    private func scheduleRefreshLocked(reason: String) {
        if isRunning {
            needsFollowUpRefresh = true
            return
        }

        scheduledRefresh?.cancel()
        refreshRequestID += 1
        let requestID = refreshRequestID
        let workItem = DispatchWorkItem { [weak self] in
            self?.startRefreshLocked(requestID: requestID, reason: reason)
        }
        scheduledRefresh = workItem
        stateQueue.asyncAfter(
            deadline: .now() + debounceInterval,
            execute: workItem)
    }

    private func startRefreshLocked(requestID: Int, reason: String) {
        guard !isStopped, requestID == refreshRequestID else { return }
        scheduledRefresh = nil

        if isRunning {
            needsFollowUpRefresh = true
            return
        }

        isRunning = true
        refreshQueue.async { [weak self] in
            guard let self else { return }
            let spaces = self.snapshotLoader()
            self.finishRefresh(spaces: spaces, reason: reason)
        }
    }

    private func finishRefresh(spaces: [AnySpace], reason: String) {
        stateQueue.async { [weak self] in
            guard let self else { return }

            self.isRunning = false
            guard !self.isStopped else { return }

            let shouldPublish = spaces != self.lastPublishedSpaces
            if shouldPublish {
                self.lastPublishedSpaces = spaces
            }

            let shouldRunFollowUp = self.needsFollowUpRefresh
            self.needsFollowUpRefresh = false

            if shouldPublish {
                DispatchQueue.main.async { [publishHandler] in
                    publishHandler(spaces)
                }
            }

            if shouldRunFollowUp {
                self.scheduleRefreshLocked(reason: reason)
            }
        }
    }
}
