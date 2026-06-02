import CarPlay

class CarPlaySceneDelegate: UIResponder, CPTemplateApplicationSceneDelegate {
    var interfaceController: CPInterfaceController?

    func templateApplicationScene(
        _ templateApplicationScene: CPTemplateApplicationScene,
        didConnect interfaceController: CPInterfaceController
    ) {
        self.interfaceController = interfaceController
        interfaceController.setRootTemplate(makeRootTemplate(), animated: false, completion: nil)
    }

    func templateApplicationScene(
        _ templateApplicationScene: CPTemplateApplicationScene,
        didDisconnect interfaceController: CPInterfaceController
    ) {
        self.interfaceController = nil
    }

    private func makeRootTemplate() -> CPGridTemplate {
        let image = UIImage(
            systemName: "mic.fill",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 60, weight: .medium)
        )!
        let talkButton = CPGridButton(titleVariants: ["Talk to Claude"], image: image) { _ in
            // handle voice input
        }
        return CPGridTemplate(title: "Claude", gridButtons: [talkButton])
    }
}
