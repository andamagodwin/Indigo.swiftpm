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
    @State private var synthesizer = AVSpeechSynthesizer()

    private let sampleImages = [
        "healthy_1", "healthy_2", "healthy_3",
        "rust_1", "rust_2", "rust_3"
    ]

    var body: some View {
        ZStack {
            // Background
            Color.black.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    cameraFrame
                    snapButton
                    if isProcessing {
                        ProgressView("Analyzing…")
                            .foregroundColor(.white)
                            .tint(.green)
                    }
                    if hasResult {
                        resultCard
                        actionButtons
                    }
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
            }

            // Flash overlay
            if showFlash {
                Color.white
                    .ignoresSafeArea()
                    .allowsHitTesting(false)
            }
        }
        .navigationTitle("Leaf Scanner")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }

    // MARK: - Camera Frame

    private var cameraFrame: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(white: 0.1))
                .aspectRatio(3.0 / 4.0, contentMode: .fit)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.green.opacity(0.5), lineWidth: 2)
                )

            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .aspectRatio(3.0 / 4.0, contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            } else {
                VStack(spacing: 12) {
                    Image(systemName: "viewfinder")
                        .font(.system(size: 48))
                        .foregroundColor(.green.opacity(0.6))
                    Text("Tap Snap to capture a leaf")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.5))
                }
            }
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
                        LinearGradient(colors: [.green, .mint],
                                       startPoint: .topLeading,
                                       endPoint: .bottomTrailing)
                    )
                    .frame(width: 72, height: 72)
                    .shadow(color: .green.opacity(0.5), radius: 8)

                Circle()
                    .stroke(Color.white.opacity(0.3), lineWidth: 3)
                    .frame(width: 80, height: 80)

                Image(systemName: "camera.fill")
                    .font(.title2)
                    .foregroundColor(.white)
            }
        }
        .disabled(isProcessing)
    }

    // MARK: - Result Card

    private var resultCard: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: isRust ? "exclamationmark.triangle.fill" : "checkmark.circle.fill")
                    .font(.title2)
                    .foregroundColor(isRust ? .orange : .green)

                Text(isRust ? "Disease Detected" : "Healthy Leaf")
                    .font(.headline)
                    .foregroundColor(.white)
            }

            VStack(spacing: 6) {
                HStack {
                    Text("Result:")
                        .foregroundColor(.white.opacity(0.6))
                    Text(resultLabel)
                        .foregroundColor(.white)
                        .bold()
                }

                HStack {
                    Text("Confidence:")
                        .foregroundColor(.white.opacity(0.6))
                    Text("\(Int(confidence))%")
                        .foregroundColor(.white)
                        .bold()
                }
            }
            .font(.subheadline)

            Text(isRust
                 ? "⚠️ This leaf shows signs of Coffee Leaf Rust. Quarantine the plant and apply a copper-based fungicide immediately."
                 : "✅ This leaf looks healthy! Keep monitoring regularly to catch any issues early.")
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.top, 4)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(white: 0.12))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(isRust ? Color.orange.opacity(0.4) : Color.green.opacity(0.4),
                                lineWidth: 1)
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
                    .padding()
                    .background(.ultraThinMaterial)
                    .foregroundColor(.white)
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
            }

            NavigationLink(destination: RecoveryView()) {
                Label("Continue", systemImage: "arrow.right.circle.fill")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        LinearGradient(colors: [.green, .mint],
                                       startPoint: .leading,
                                       endPoint: .trailing)
                    )
                    .foregroundColor(.white)
                    .cornerRadius(16)
                    .shadow(color: .green.opacity(0.4), radius: 8, y: 4)
            }
        }
    }

    // MARK: - Snap Logic

    private func performSnap() {
        // Pick a random sample image
        let name = sampleImages.randomElement() ?? "healthy_1"
        guard let url = Bundle.main.url(forResource: name, withExtension: "jpg"),
              let data = try? Data(contentsOf: url),
              let uiImage = UIImage(data: data) else {
            resultLabel = "Error: Could not load image"
            hasResult = true
            return
        }

        // Flash effect
        withAnimation(.easeIn(duration: 0.1)) { showFlash = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            withAnimation(.easeOut(duration: 0.25)) { showFlash = false }
        }

        selectedImage = uiImage
        isProcessing = true
        hasResult = false

        // Run classification
        classifyImage(uiImage)
    }

    // MARK: - Core ML Classification

    private func classifyImage(_ uiImage: UIImage) {
        guard let modelURL = Bundle.main.url(forResource: "IndigoLeafClassifier",
                                              withExtension: "mlmodelc") else {
            finalizeResult("Error", 0)
            return
        }

        do {
            let mlModel = try MLModel(contentsOf: modelURL)
            let vnModel = try VNCoreMLModel(for: mlModel)

            guard let ciImage = CIImage(image: uiImage) else {
                finalizeResult("Error", 0)
                return
            }

            let request = VNCoreMLRequest(model: vnModel) { request, _ in
                guard let results = request.results as? [VNClassificationObservation],
                      let top = results.first else {
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
            finalizeResult("Error", 0)
        }
    }

    private func finalizeResult(_ label: String, _ conf: Double) {
        resultLabel = label
        confidence = conf
        isRust = label.lowercased().contains("rust")
        isProcessing = false
        hasResult = true
    }

    // MARK: - Speech

    private func speakResult() {
        let text = "Result: \(resultLabel). Confidence: \(Int(confidence)) percent."
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.5
        synthesizer.speak(utterance)
    }
}
