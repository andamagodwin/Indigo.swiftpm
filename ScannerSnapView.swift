import SwiftUI
import CoreML
import Vision
import AVFoundation

struct ScannerSnapView: View {
    @State private var resultLabel: String = ""
    @State private var confidence: Double = 0.0
    @State private var isRust: Bool = false
    @State private var hasResult: Bool = false
    @State private var selectedImage: UIImage? = nil
    @State private var showFlash: Bool = false
    @State private var isProcessing: Bool = false
    @State private var errorText: String = ""


    // Coffee palette on white
    private let coffee      = Color(red: 0.38, green: 0.22, blue: 0.10)
    private let coffeeLight = Color(red: 0.54, green: 0.35, blue: 0.18)
    private let caramel     = Color(red: 0.76, green: 0.56, blue: 0.34)
    private let coffeeBg    = Color(red: 0.97, green: 0.95, blue: 0.92)
    private let leafGreen   = Color(red: 0.25, green: 0.55, blue: 0.25)
    private let mintGreen   = Color(red: 0.35, green: 0.70, blue: 0.45)
    private let rustOrange  = Color(red: 0.85, green: 0.45, blue: 0.15)
    private let dangerRed   = Color(red: 0.75, green: 0.22, blue: 0.18)
    private let textDark    = Color(red: 0.20, green: 0.12, blue: 0.08)
    private let textSec     = Color(red: 0.50, green: 0.40, blue: 0.32)

    private let sampleImages = [
        "healthy_1", "healthy_2", "healthy_3",
        "rust_1", "rust_2", "rust_3"
    ]

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            VStack(spacing: 16) {
                cameraFrame
                    .frame(maxHeight: 300)
                    .padding(.horizontal, 24)
                    .padding(.top, 8)

                snapButton

                ScrollView {
                    VStack(spacing: 16) {
                        if isProcessing {
                            HStack(spacing: 10) {
                                ProgressView().tint(coffee)
                                Text("Analyzing leaf…")
                                    .font(.subheadline.weight(.medium))
                                    .foregroundColor(textSec)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 12).fill(coffeeBg)
                            )
                        }

                        if !errorText.isEmpty {
                            Text(errorText)
                                .font(.caption)
                                .foregroundColor(dangerRed)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(dangerRed.opacity(0.08))
                                )
                        }

                        if hasResult {
                            resultCard
                            actionButtons
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
                }
            }

            if showFlash {
                Color.white.ignoresSafeArea().allowsHitTesting(false)
            }
        }
        .navigationTitle("Leaf Scanner")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Camera Frame

    private var cameraFrame: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(coffeeBg)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(coffee.opacity(0.25), lineWidth: 2)
                )

            cameraCorners

            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            } else {
                VStack(spacing: 12) {
                    Image(systemName: "viewfinder")
                        .font(.system(size: 44))
                        .foregroundColor(coffee.opacity(0.35))
                    Text("Tap Snap to capture a leaf")
                        .font(.caption.weight(.medium))
                        .foregroundColor(textSec)
                }
            }
        }
    }

    private var cameraCorners: some View {
        GeometryReader { geo in
            let s: CGFloat = 24
            let pad: CGFloat = 8
            let color = coffee.opacity(0.4)
            let w: CGFloat = 3

            Path { p in
                p.move(to: CGPoint(x: pad, y: pad + s))
                p.addLine(to: CGPoint(x: pad, y: pad))
                p.addLine(to: CGPoint(x: pad + s, y: pad))
            }.stroke(color, lineWidth: w)

            Path { p in
                p.move(to: CGPoint(x: geo.size.width - pad - s, y: pad))
                p.addLine(to: CGPoint(x: geo.size.width - pad, y: pad))
                p.addLine(to: CGPoint(x: geo.size.width - pad, y: pad + s))
            }.stroke(color, lineWidth: w)

            Path { p in
                p.move(to: CGPoint(x: pad, y: geo.size.height - pad - s))
                p.addLine(to: CGPoint(x: pad, y: geo.size.height - pad))
                p.addLine(to: CGPoint(x: pad + s, y: geo.size.height - pad))
            }.stroke(color, lineWidth: w)

            Path { p in
                p.move(to: CGPoint(x: geo.size.width - pad - s, y: geo.size.height - pad))
                p.addLine(to: CGPoint(x: geo.size.width - pad, y: geo.size.height - pad))
                p.addLine(to: CGPoint(x: geo.size.width - pad, y: geo.size.height - pad - s))
            }.stroke(color, lineWidth: w)
        }
    }

    // MARK: - Snap Button

    private var snapButton: some View {
        Button {
            performSnap()
        } label: {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(colors: [coffee, coffeeLight],
                                       startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .frame(width: 72, height: 72)
                    .shadow(color: coffee.opacity(0.3), radius: 10)

                Circle()
                    .stroke(coffee.opacity(0.2), lineWidth: 3)
                    .frame(width: 80, height: 80)

                Image(systemName: "camera.fill")
                    .font(.title2)
                    .foregroundColor(.white)
            }
        }
        .disabled(isProcessing)
        .opacity(isProcessing ? 0.5 : 1.0)
    }

    // MARK: - Result Card

    private var resultCard: some View {
        VStack(spacing: 14) {
            HStack(spacing: 8) {
                Image(systemName: isRust ? "exclamationmark.triangle.fill" : "checkmark.circle.fill")
                    .font(.title3)
                    .foregroundColor(isRust ? rustOrange : leafGreen)

                Text(isRust ? "Disease Detected" : "Healthy Leaf")
                    .font(.headline)
                    .foregroundColor(textDark)
                Spacer()
            }

            Divider()

            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 6) {
                        Text("Result:").font(.subheadline).foregroundColor(textSec)
                        Text(resultLabel).font(.subheadline.weight(.semibold)).foregroundColor(textDark)
                    }
                    HStack(spacing: 6) {
                        Text("Confidence:").font(.subheadline).foregroundColor(textSec)
                        Text("\(Int(confidence))%").font(.subheadline.weight(.semibold)).foregroundColor(textDark)
                    }
                }
                Spacer()
            }

            Text(isRust
                 ? "⚠️ This leaf shows signs of Coffee Leaf Rust. Quarantine the plant and apply a copper-based fungicide immediately."
                 : "✅ This leaf looks healthy! Keep monitoring regularly to catch any issues early.")
                .font(.caption)
                .foregroundColor(textSec)
                .multilineTextAlignment(.leading)
                .padding(.top, 4)
                .lineSpacing(3)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(coffeeBg)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(isRust ? rustOrange.opacity(0.2) : leafGreen.opacity(0.2), lineWidth: 1)
                )
        )
    }

    // MARK: - Action Buttons

    private var actionButtons: some View {
        VStack(spacing: 12) {
            Button {
                speakResult()
            } label: {
                Label("Listen", systemImage: "speaker.wave.2.fill")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(coffeeBg)
                    .foregroundColor(coffee)
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(coffee.opacity(0.2), lineWidth: 1)
                    )
            }

            NavigationLink {
                RecoveryView()
            } label: {
                Label("Continue", systemImage: "arrow.right.circle.fill")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        LinearGradient(colors: [leafGreen, mintGreen],
                                       startPoint: .leading, endPoint: .trailing)
                    )
                    .foregroundColor(.white)
                    .cornerRadius(16)
                    .shadow(color: leafGreen.opacity(0.3), radius: 8, y: 4)
            }
        }
    }

    // MARK: - Snap Logic

    private func performSnap() {
        errorText = ""
        let name = sampleImages.randomElement() ?? "healthy_1"

        guard let url = Bundle.main.url(forResource: name, withExtension: "jpg") else {
            errorText = "Could not find \(name).jpg in bundle"
            hasResult = false
            return
        }

        guard let data = try? Data(contentsOf: url),
              let uiImage = UIImage(data: data) else {
            errorText = "Could not load image data"
            hasResult = false
            return
        }

        withAnimation(.easeIn(duration: 0.1)) { showFlash = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            withAnimation(.easeOut(duration: 0.25)) { showFlash = false }
        }

        selectedImage = uiImage
        isProcessing = true
        hasResult = false
        classifyImage(uiImage)
    }

    // MARK: - Core ML Classification

    private func classifyImage(_ uiImage: UIImage) {
        guard let modelURL = Bundle.main.url(forResource: "IndigoLeafClassifier",
                                              withExtension: "mlmodelc") else {
            errorText = "Could not find model in bundle"
            isProcessing = false
            return
        }

        do {
            let mlModel = try MLModel(contentsOf: modelURL)
            let vnModel = try VNCoreMLModel(for: mlModel)

            guard let ciImage = CIImage(image: uiImage) else {
                errorText = "Could not create CIImage"
                isProcessing = false
                return
            }

            let request = VNCoreMLRequest(model: vnModel) { request, error in
                if let error = error {
                    DispatchQueue.main.async {
                        self.errorText = "Vision error: \(error.localizedDescription)"
                        self.isProcessing = false
                    }
                    return
                }
                guard let results = request.results as? [VNClassificationObservation],
                      let top = results.first else {
                    DispatchQueue.main.async {
                        self.errorText = "No classification results"
                        self.isProcessing = false
                    }
                    return
                }
                let label = top.identifier
                let conf = Double(top.confidence) * 100.0
                DispatchQueue.main.async {
                    self.finalizeResult(label, conf)
                }
            }
            request.imageCropAndScaleOption = .scaleFill

            let handler = VNImageRequestHandler(ciImage: ciImage)
            try handler.perform([request])
        } catch {
            errorText = "ML error: \(error.localizedDescription)"
            isProcessing = false
        }
    }

    private func finalizeResult(_ label: String, _ conf: Double) {
        resultLabel = label
        confidence = conf
        isRust = label.lowercased().contains("rust")
        isProcessing = false
        hasResult = true
        errorText = ""
    }

    // MARK: - Speech

    private func speakResult() {
        let text = "Result: \(resultLabel). Confidence: \(Int(confidence)) percent."
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.5
        let speaker = AVSpeechSynthesizer()
        speaker.speak(utterance)
    }
}
