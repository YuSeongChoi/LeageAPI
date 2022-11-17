//
//  NetworkAlertOperation.swift
//  LeageAPI
//
//  Created by YuSeongChoi on 2022/11/16.
//

import Foundation
import Dispatch
import UIKit

final class NetworkAlert: Operation {
    
    fileprivate enum RunningState {
        case Ready
        case Executing
        case Finished
    }
    
    private static let queue: OperationQueue = {
        let queue = OperationQueue()
        queue.name = "NetworkAlert Operation Queue"
        queue.maxConcurrentOperationCount = 1
        queue.underlyingQueue = .global(qos: .userInitiated)
        return queue
    }()
    
    let error: Error
    private var state = RunningState.Ready {
        willSet {
            guard state != newValue else { return }
            if state == .Ready || newValue == .Ready {
                willChangeValue(for: \.isReady)
            }
            if state == .Executing || newValue == .Executing {
                willChangeValue(for: \.isExecuting)
            }
            if state == .Finished || newValue == .Finished {
                willChangeValue(for: \.isFinished)
            }
        }
        didSet {
            guard oldValue != state else { return }
            if state == .Ready || oldValue == .Ready {
                didChangeValue(for: \.isReady)
            }
            if state == .Executing || oldValue == .Executing {
                didChangeValue(for: \.isExecuting)
            }
            if state == .Finished || oldValue == .Finished {
                didChangeValue(for: \.isFinished)
            }
        }
    }
    
    override var isReady: Bool { state == .Ready }
    override var isExecuting: Bool { state == .Executing }
    override var isFinished: Bool { state == .Finished }
    
    override func cancel() {
        super.cancel()
        cleanup()
    }
    
    init(error: Error) {
        self.error = error
        super.init()
    }
    
    override func start() {
        let isRunnable = !isFinished && !isCancelled && !isExecuting
        guard isRunnable else { return }
        main()
    }
    
    private var task: Task<Void, Never>? {
        didSet { oldValue?.cancel() }
    }
    
    private var window: UIWindow?
    
    override func main() {
        guard state != .Finished, task == nil else { return }
        state = .Executing
        task = Task {
            await withTaskCancellationHandler{ [weak self] in
                self?.state = .Finished
                self?.window = nil
            } operation: { @MainActor [weak self, error] in
                let scene = UIApplication.shared.connectedScenes.filter{ $0.activationState == .foregroundActive }
                    .compactMap{ $0 as? UIWindowScene }.first
                guard let scene else {
                    self?.state = .Finished
                    return
                }
                let subWindow = UIWindow(windowScene: scene)
                subWindow.windowLevel = .normal + 10
                let vc = UIViewController()
                subWindow.rootViewController = vc
                let alert = UIAlertController(title: "", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(.init(title: "확인", style: .default) { _ in
                    self?.cleanup()
                })
                guard self?.isFinished == false else { return }
                subWindow.isHidden = false
                self?.window = subWindow
                
                await withCheckedContinuation {
                    vc.present(alert, animated: true, completion: $0.resume)
                }
            }
        }
    }
    
    func cleanup() {
        print(#function)
        task?.cancel()
        state = .Finished
        window = nil
    }
    
    class func dismissNetworkAlert() {
        queue.cancelAllOperations()
    }
    
    func enqueueOperation() {
        guard !isFinished && !isExecuting else {
            assertionFailure("invalid Operation detected")
            return
        }
        Self.queue.addOperation(self)
    }
    
}
