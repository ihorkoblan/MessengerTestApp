//
//  ChatView.swift
//  MessengerTestApp
//
//  Created by Ihor on 23.08.2024.
//

import SwiftUI
import Combine

struct ChatView: View {
    @StateObject private var viewModel = ChatViewModel()
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(viewModel.messages) { message in
                            Text(message.text)
                                .padding()
                                .background(Color.blue.opacity(0.2))
                                .cornerRadius(8)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .id(message.id)
                        }
                    }
                    
                    .padding()
                    .background(
                        GeometryReader { geometry in
                            Color.clear
                                .onChange(of: geometry.frame(in: .global).maxY) { _, _ in
                                    let isBottom = geometry.frame(in: .global).maxY <= UIScreen.main.bounds.height + 20.0
                                    viewModel.isScrolledToBottom = isBottom
                                }
                        }
                    )
                }
                .onChange(of: $viewModel.messages.count) { _, _ in
                    if viewModel.isScrolledToBottom {
                        withAnimation {
                            proxy.scrollTo(viewModel.messages.last?.id, anchor: .bottom)
                        }
                    }
                }
            }
            
            HStack {
                TextField("Send a message", text: $viewModel.userInput)
                    .textFieldStyle(.roundedBorder)
                    .focused($isFocused)
                Button(action: viewModel.sendMessageTapped)   {
                    Image(systemName: "paperplane")
                }
            }
            .padding()
        }
        .onTapGesture {
            hideKeyboard()
        }
    }
    
    private func hideKeyboard() {
        isFocused = false
    }
}
