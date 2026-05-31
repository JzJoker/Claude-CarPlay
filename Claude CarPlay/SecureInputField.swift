import SwiftUI
import UIKit

struct SecureInputField: UIViewRepresentable {
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool

    func makeUIView(context: Context) -> UITextField {
        let field = UITextField()
        field.placeholder = placeholder
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.delegate = context.coordinator
        return field
    }

    func updateUIView(_ field: UITextField, context: Context) {
        let coordinator = context.coordinator
        if coordinator.isSecure != isSecure {
            coordinator.isSecure = isSecure
            coordinator.revealTimer?.invalidate()
            field.text = isSecure
                ? String(repeating: "•", count: coordinator.realText.count)
                : coordinator.realText
        } else if !field.isFirstResponder {
            coordinator.realText = text
            field.text = isSecure ? String(repeating: "•", count: text.count) : text
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text, isSecure: isSecure)
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        @Binding var text: String
        var isSecure: Bool
        var realText: String
        var revealTimer: Timer?

        init(text: Binding<String>, isSecure: Bool) {
            _text = text
            self.isSecure = isSecure
            self.realText = text.wrappedValue
        }

        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            var chars = Array(realText)
            let start = min(range.location, chars.count)
            let end = min(range.location + range.length, chars.count)
            chars.replaceSubrange(start..<end, with: Array(string))
            realText = String(chars)
            text = realText

            if isSecure {
                revealTimer?.invalidate()
                if !string.isEmpty, let last = realText.last {
                    textField.text = String(repeating: "•", count: realText.count - 1) + String(last)
                    revealTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { [weak self, weak textField] _ in
                        guard let self, let textField else { return }
                        textField.text = String(repeating: "•", count: self.realText.count)
                    }
                } else {
                    textField.text = String(repeating: "•", count: realText.count)
                }
            } else {
                textField.text = realText
            }

            return false
        }
    }
}
