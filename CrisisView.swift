import SwiftUI

struct CrisisView: View {
    @State private var phase = 0
    @State private var isInfected = false
    @State private var currentImageIndex = 1
    @State private var showScanButton = false
    @State private var showContent = false

    // Coffee palette on white
    private let coffee = Color(red: 0.38, green: 0.22, blue: 0.10)
    private let coffeeBg = Color(red: 0.97, green: 0.95, blue: 0.92)
    private let amber = Color(red: 0.75, green: 0.50, blue: 0.15)
    private let rustOrange = Color(red: 0.85, green: 0.45, blue: 0.15)
    private let dangerRed = Color(red: 0.75, green: 0.22, blue: 0.18)
    private let textDark = Color(red: 0.20, green: 0.12, blue: 0.08)
    private let textSec = Color(red: 0.50, green: 0.40, blue: 0.32)

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            Circle()
                .fill(rustOrange.opacity(isInfected ? 0.08 : 0.0))
                .frame(width: 400, height: 400)
                .blur(radius: 80)
                .offset(y: -60)
                .animation(.easeInOut(duration: 2.0), value: isInfected)

            VStack(spacing: 28) {
                Spacer()
                crisisText
                interactiveAnimationSection

                if showScanButton {
                    scanButton
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                } else {
                    Color.clear.frame(height: 56)
                }
                Spacer().frame(height: 40)
            }
            .padding(.horizontal, 32)
            .opacity(showContent ? 1 : 0)
            .offset(y: showContent ? 0 : 20)
        }
        .navigationTitle("Crisis")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) { showContent = true }
        }
    }

    private var interactiveAnimationSection: some View {
        ZStack {
            // Sequence of images crossfading smoothly
            Image("crisis\(currentImageIndex)")
                .resizable()
                .scaledToFit()
                .frame(width: 400, height: 400)
                .id(currentImageIndex)  // Forces SwiftUI to treat each frame as a unique view for transition
                .transition(.opacity.animation(.easeInOut(duration: 0.4)))
                .shadow(color: rustOrange.opacity(0.4), radius: currentImageIndex == 6 ? 12 : 0)

            // Tap Target Overlay (Invisible, captures tap)
            if !isInfected {
                Circle()
                    .fill(Color.white.opacity(0.01))
                    .frame(width: 300, height: 300)
                    .onTapGesture {
                        triggerInfectionSequence()
                    }
                    // Pulsing hint for user to tap
                    .overlay(
                        Circle()
                            .stroke(rustOrange.opacity(0.5), lineWidth: 2)
                            .scaleEffect(phase == -1 ? 1.3 : 1.0)
                            .opacity(phase == -1 ? 0 : 1)
                            .animation(
                                .easeInOut(duration: 1.5).repeatForever(autoreverses: false),
                                value: phase)
                    )
            }
        }
        .frame(height: 400)
        .onAppear {
            // Start the pulsing tap hint
            phase = -1
        }
    }

    private var crisisText: some View {
        VStack(spacing: 14) {
            Text("Weeks later, orange spots appear…")
                .font(.title2.bold())
                .foregroundColor(rustOrange)
                .multilineTextAlignment(.center)

            Text(
                "Coffee Leaf Rust — a fungal disease that can destroy an entire harvest and wipe out a family's income."
            )
            .font(.body)
            .foregroundColor(textDark)
            .multilineTextAlignment(.center)
            .lineSpacing(4)

            Text("But what if you could catch it early?")
                .font(.callout.weight(.medium))
                .italic()
                .foregroundColor(textSec)
                .padding(.top, 4)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(coffeeBg)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(rustOrange.opacity(0.15), lineWidth: 1)
                )
        )
    }

    private var scanButton: some View {
        NavigationLink(value: "Scanner") {
            Label("Scan Leaf", systemImage: "camera.viewfinder")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    LinearGradient(
                        colors: [rustOrange, dangerRed],
                        startPoint: .leading, endPoint: .trailing)
                )
                .foregroundColor(.white)
                .cornerRadius(16)
                .shadow(color: rustOrange.opacity(0.3), radius: 8, y: 4)
        }
    }

    // MARK: - Orchestrating the Infection Animation
    private func triggerInfectionSequence() {
        guard !isInfected else { return }
        phase = 0  // Stop the hint pulse

        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()

        withAnimation {
            isInfected = true
            currentImageIndex = 2
        }

        // Frame 3
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation { currentImageIndex = 3 }
        }

        // Frame 4
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let softImpact = UIImpactFeedbackGenerator(style: .soft)
            softImpact.impactOccurred()
            withAnimation { currentImageIndex = 4 }
        }

        // Frame 5
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation { currentImageIndex = 5 }
        }

        // Frame 6
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            let heavyImpact = UIImpactFeedbackGenerator(style: .heavy)
            heavyImpact.impactOccurred()
            withAnimation { currentImageIndex = 6 }
        }

        // Action button appearance
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.8) {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                showScanButton = true
            }
        }
    }
}
