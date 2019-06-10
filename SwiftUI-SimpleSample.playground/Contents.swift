import PlaygroundSupport
import SwiftUI

// A simple extension by 'View' to change offset axis
extension View {

  public func offset(by offset: CGPoint) -> Self.Modified<_OffsetEffect> {
    self.offset(x: offset.x, y: offset.y)
  }

}

struct LiveView: View {

  // A initial position
  @State var position: CGPoint = .zero

  // Define the initial animation
  @State var animation: Animation = .spring()

  // Define the index of actual animation
  @State var indexOfAnimation: Int = 0

  // Define the name of actual animation
  @State var actualAnimation: String = "Spring"

  var body: some View {
    // Define a "stackView" in center both axis
    VStack {

      ZStack {
        // Define a big circle
        Circle()
          .foregroundColor(Color.black.opacity(0.1))
          .frame(width: 320, height: 320)

        // Define a image to centered a big circle
        // and events to handler the move it
        // out of the larger circle
        Image(systemName: "asterisk.circle.fill")
          .scaleEffect(CGSize(width: 3, height: 3))
          .foregroundColor(Color.blue.opacity(0.5))
          .offset(by: self.position)
          .animation(animation)
          .gesture(DragGesture()
            .onChanged {
              self.position = $0.location
            }
            .onEnded { _ in
              if sqrt(self.position.x * self.position.x + self.position.y * self.position.y) > 160 {
                self.position = .zero
              }
            })
      }

      // Define button to handler the change animation
      Button(action: {
        self.indexOfAnimation += 1
        
        if self.indexOfAnimation > 2 {
          self.indexOfAnimation = 0
        }

        switch self.indexOfAnimation {
        case 0:
          self.animation = .spring()
          self.actualAnimation = "Spring"

        case 1:
          self.animation = .fluidSpring()
          self.actualAnimation = "Fluid Spring"

        default:
          self.animation = .basic()
          self.actualAnimation = "Basic"
        }

        print("Animation changed")
      }) {
        Text("Change Animation")
      }.padding()

      Text("Actual animation: " + actualAnimation)
    }
  }

}

PlaygroundPage.current.liveView = UIHostingController(rootView: LiveView())
