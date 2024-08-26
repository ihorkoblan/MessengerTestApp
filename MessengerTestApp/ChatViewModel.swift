//
//  ChatViewModel.swift
//  MessengerTestApp
//
//  Created by Ihor on 23.08.2024.
//

import Combine
import Foundation

@MainActor
class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var userInput = ""
    @Published var keyboardHeight: CGFloat = 0
    
    var isScrolledToBottom = true
    
    private let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()

    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        setupTimer()
    }
    
    func sendMessageTapped() {
        guard !userInput.isEmpty else {
            return
        }
        addMessage(userInput)
        userInput = ""
    }
    
    func addMessage(_ text: String) {
        let newMessage = Message(id: UUID(), text: text)
        messages.append(newMessage)
    }
    
    private func setupTimer() {
        timer
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                let randomMessage = self?.generateRandomMessage() ?? ""
                self?.addMessage(randomMessage)
            }
            .store(in: &cancellables)
    }
    
    private func generateRandomMessage() -> String {
        let sentences = [
            "This is a short message.",
            "Here is a longer message that might take up two lines.",
            "This message is quite long, and it might even take up three lines depending on the screen width."
        ]
        return sentences.randomElement()!
    }
}



