import SwiftUI

struct PlantingView: View {
    @State private var phase = 0
    @State private var isPlanted = false
    @State private var showContinue = false
    @State private var currentImageIndex = 1

    // Coffee palette on white
    private let coffee = Color(red: 0.38, green: 0.22, blue: 0.10)
    private let coffeeLight = Color(red: 0.54, green: 0.35, blue: 0.18)
    private let coffeeBg = Color(red: 0.97, green: 0.95, blue: 0.92)
    private let caramel = Color(red: 0.76, green: 0.56, blue: 0.34)
    private let leafGreen = Color(red: 0.25, green: 0.55, blue: 0.25)
    private let mintGreen = Color(red: 0.35, green: 0.70, blue: 0.45)
    private let textDark = Color(red: 0.20, green: 0.12, blue: 0.08)
    private let textSec = Color(red: 0.50, green: 0.40, blue: 0.32)

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            // Ambient background glow that grows when planted
            Circle()
                .fill(leafGreen.opacity(isPlanted ? 0.08 : 0.0))
                .frame(width: 400, height: 400)
                .blur(radius: 80)
                .offset(y: 50)
                .animation(.easeInOut(duration: 2.0), value: isPlanted)

            VStack(spacing: 30) {
                storySection

                Spacer()

                // Interactive Animation Area
                interactiveAnimationSection

                Spacer()

                if showContinue {
                    continueButton
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                } else {
                    // Placeholder to prevent layout jump
                    Color.clear.frame(height: 56)
                }
            }
            .padding(.horizontal, 32)
            .padding(.top, 24)
            .padding(.bottom, 40)
        }
        .navigationTitle("The Farm")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var storySection: some View {
        VStack(spacing: 14) {
            Image(systemName: "mountain.2.fill")
                .font(.system(size: 32))
                .foregroundColor(caramel)

            Text(
                "In the highlands of Uganda, a family depends on their coffee farm for everything — school fees, food, and hope."
            )
            .font(.body)
            .foregroundColor(textDark)
            .multilineTextAlignment(.center)
            .lineSpacing(4)

            Text(isPlanted ? "A new life begins to grow." : "Tap the seed to plant it in the soil.")
                .font(.callout.weight(.medium))
                .foregroundColor(isPlanted ? leafGreen : coffeeLight)
                .padding(.top, 8)
                .animation(.easeInOut, value: isPlanted)
        }
        .padding(.top, 20)
    }

    private var interactiveAnimationSection: some View {
        ZStack {
            // Sequence of images crossfading smoothly
            Image("plant\(currentImageIndex)")
                .resizable()
                .scaledToFit()
                .frame(width: 400, height: 400)
                .id(currentImageIndex)  // Forces SwiftUI to treat each frame as a unique view for transition
                .transition(.opacity.animation(.easeInOut(duration: 0.5)))
                .shadow(color: mintGreen.opacity(0.4), radius: currentImageIndex == 4 ? 12 : 0)

            // Tap Target Overlay (Invisible, captures tap)
            if !isPlanted {
                Circle()
                    .fill(Color.white.opacity(0.01))
                    .frame(width: 300, height: 300)
                    .onTapGesture {
                        triggerGrowthSequence()
                    }
                    // Pulsing hint for user to tap
                    .overlay(
                        Circle()
                            .stroke(caramel.opacity(0.5), lineWidth: 2)
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

    private var continueButton: some View {
        NavigationLink(value: "Crisis") {
            Label("Continue Journey", systemImage: "arrow.right.circle.fill")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    LinearGradient(
                        colors: [leafGreen, mintGreen],
                        startPoint: .leading, endPoint: .trailing)
                )
                .foregroundColor(.white)
                .cornerRadius(16)
                .shadow(color: leafGreen.opacity(0.3), radius: 8, y: 4)
        }
    }

    // MARK: - Orchestrating the Growth Animation
    private func triggerGrowthSequence() {
        guard !isPlanted else { return }
        phase = 0  // Stop the hint pulse

        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()

        withAnimation {
            isPlanted = true
            currentImageIndex = 1
        }

        // Frame 2
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            withAnimation {
                currentImageIndex = 2
            }
        }

        // Frame 3
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            let softImpact = UIImpactFeedbackGenerator(style: .soft)
            softImpact.impactOccurred()

            withAnimation {
                currentImageIndex = 3
            }
        }

        // Frame 4
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
            let softImpact = UIImpactFeedbackGenerator(style: .soft)
            softImpact.impactOccurred()

            withAnimation {
                currentImageIndex = 4
            }
        }

        // Action button appearance
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.6) {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                showContinue = true
            }
        }
    }
}
