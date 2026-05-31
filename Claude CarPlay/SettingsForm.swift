import SwiftUI

struct SettingsForm: View {
    @State private var apiKey = ""
    @State private var useWhisper = false
    @State private var wakeWord = "Claude"
    @State private var voiceSpeed = 1.0
    @State private var toastMessage: String? = nil
    @State private var apiKeyVisible = false

    var body: some View {
        Form {
            Section(header: Text("API Configuration")) {
                HStack {
                    SecureInputField(placeholder: "Claude API Key", text: $apiKey, isSecure: !apiKeyVisible)
                    Button {
                        apiKeyVisible.toggle()
                    } label: {
                        Image(systemName: apiKeyVisible ? "eye.slash" : "eye")
                            .foregroundStyle(.secondary)
                    }
                    .buttonStyle(.plain)
                }
                Toggle("Use Whisper for transcription", isOn: $useWhisper)
            }

            Section(header: Text("Voice Settings")) {
                TextField("Wake word", text: $wakeWord)
                Slider(value: $voiceSpeed, in: 0.5...2.0) {
                    Text("Speech speed")
                }
            }

            Section {
                Button("Save") {
                    let success = Keychain.save(apiKey, forKey: "claude_api_key")
                    showToast(success ? "Saved successfully" : "Failed to save")
                }
            }
        }
        .navigationTitle("Settings")
        .onAppear {
            apiKey = Keychain.load(forKey: "claude_api_key") ?? ""
        }
        .overlay(alignment: .bottom) {
            if let message = toastMessage {
                Text(message)
                    .font(.footnote)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(.regularMaterial, in: Capsule())
                    .padding(.bottom, 16)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(.easeInOut, value: toastMessage)
    }

    private func showToast(_ message: String) {
        toastMessage = message
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            toastMessage = nil
        }
    }
}

#Preview {
    NavigationStack {
        SettingsForm()
    }
}
