import SwiftUI

struct SplashScreenView: View {
    var body: some View {
        ZStack {
            // Hintergrundfarbe, passend zum App-Theme
            Color(.systemBackground)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                // Das Logo aus den Assets laden
                Image("SplashLogo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 150)
                    .padding()
                
                Text("SportyPlanner")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.accentColor)
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
