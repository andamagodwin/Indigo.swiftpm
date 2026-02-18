import SwiftUI

struct RecoveryView: View {
    @State private var showCheck = false

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(red: 0.04, green: 0.15, blue: 0.08),
                         Color(red: 0.06, green: 0.06, blue: 0.16)],
                startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()

                Image(systemName: "checkmark.seal.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(
                        LinearGradient(colors: [.green, .mint],
                                       startPoint: .topLeading,
                                       endPoint: .bottomTrailing)
                    )
                    .scaleEffect(showCheck ? 1.0 : 0.3)
                    .opacity(showCheck ? 1.0 : 0.0)
                    .shadow(color: .green.opacity(0.5), radius: 16)

                Text("Crisis Avoided")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(.white)

                Text("Early detection can protect a family's livelihood.")
                    .font(.body)
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                Text("With tools like Indigo, farmers can identify disease before it spreads — saving their harvest, their income, and their future.")
                    .font(.callout)
                    .foregroundColor(.white.opacity(0.6))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                Spacer()

                Image(systemName: "leaf.fill")
                    .font(.system(size: 28))
                    .foregroundColor(.green.opacity(0.4))
                    .padding(.bottom, 32)
            }
            .padding(.horizontal, 32)
        }
        .navigationTitle("Recovery")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.2)) {
                showCheck = true
            }
        }
    }
}
