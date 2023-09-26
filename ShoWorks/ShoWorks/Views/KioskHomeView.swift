//
//  KioskHomeView.swift
//  ShoWorks
//
//  Created by Lokesh on 25/09/23.
//

import Foundation
import CardStack
import SwiftUI

struct Person: Identifiable {
  let id = UUID()
  let name: String
  let image: UIImage
  let distance: Int = { .random(in: 1..<20) }()

  static let mock: [Person] = [
    Person(name: "Niall Miller", image: UIImage(named: "SplashLogo")!),
    Person(name: "Sammy Smart", image: UIImage(named: "SplashLogo")!),
    Person(name: "Edie Bain", image: UIImage(named: "SplashLogo")!),
    Person(name: "Gia Velez", image: UIImage(named: "SplashLogo")!),
    Person(name: "Harri Devine", image: UIImage(named: "SplashLogo")!),
  ]
}

struct CardView: View {
  let person: Person

  var body: some View {
    GeometryReader { geo in
      VStack {
//        Image(uiImage: self.person.image)
//          .resizable()
//          .aspectRatio(contentMode: .fill)
//          .frame(height: geo.size.width)
//          .clipped()
        Text(self.person.name)
        HStack {
          Text(self.person.name)
          Spacer()
          Text("\(self.person.distance) km away")
            .font(.footnote)
            .foregroundColor(.secondary)
        }
        .padding()
      }
      .background(Color.white)
      .cornerRadius(12)
      .shadow(radius: 4)
    }
  }
}

struct CardViewWithThumbs: View {
  let person: Person
  let direction: LeftRight?

  var body: some View {
    ZStack(alignment: .topTrailing) {
      ZStack(alignment: .topLeading) {
        CardView(person: person)
        Image(systemName: "checkmark.circle")
          .resizable()
          .foregroundColor(Color.green)
          .opacity(direction == .right ? 1 : 0)
          .frame(width: 100, height: 100)
          .padding()
      }

      Image(systemName: "xmark.circle.fill")
        .resizable()
        .foregroundColor(Color.red)
        .opacity(direction == .left ? 1 : 0)
        .frame(width: 100, height: 100)
        .padding()
    }
    .animation(.default)
  }
}

struct Basic: View {
  @State var data: [Person] = Person.mock

  var body: some View {
    CardStack(
      direction: LeftRight.direction,
      data: data,
      onSwipe: { card, direction in
        print("Swiped \(card.name) to \(direction)")
      },
      content: { person, _, _ in
        CardView(person: person)
      }
    )
    .padding()
    .scaledToFit()
    .frame(alignment: .center)
    .navigationBarTitle("Basic", displayMode: .inline)
  }
}

struct Thumbs: View {
  @State var data: [Person] = Person.mock

  var body: some View {
    CardStack(
      direction: LeftRight.direction,
      data: data,
      onSwipe: { card, direction in
        print("Swiped \(card.name) to \(direction)")
      },
      content: { person, direction, _ in
        CardViewWithThumbs(person: person, direction: direction)
      }
    )
    .padding()
    .scaledToFit()
    .frame(alignment: .center)
    .navigationBarTitle("Thumbs", displayMode: .inline)
  }
}

struct AddingCards: View {
  @State var data: [Person] = Array(Person.mock.prefix(2))

  var body: some View {
    CardStack(
      direction: LeftRight.direction,
      data: data,
      onSwipe: { _, _ in
        self.data.append(Person.mock.randomElement()!)
      },
      content: { person, _, _ in
        CardView(person: person)
      }
    )
    .padding()
    .scaledToFit()
    .frame(alignment: .center)
    .navigationBarTitle("Adding cards", displayMode: .inline)
  }
}

struct ReloadCards: View {
  @State var reloadToken = UUID()
  @State var data: [Person] = Person.mock.shuffled()

  var body: some View {
    CardStack(
      direction: LeftRight.direction,
      data: data,
      onSwipe: { card, direction in
        print("Swiped \(card.name) to \(direction)")
      },
      content: { person, _, _ in
        CardView(person: person)
      }
    )
    .id(reloadToken)
    .padding()
    .scaledToFit()
    .frame(alignment: .center)
    .navigationBarTitle("Reload cards", displayMode: .inline)
    .navigationBarItems(
      trailing:
        Button(action: {
          self.reloadToken = UUID()
          self.data = Person.mock.shuffled()
        }) {
          Text("Reload")
        }
    )
  }
}

struct CustomDirection: View {
  enum MyDirection {
    case up, down

    static func direction(degrees: Double) -> Self? {
      switch degrees {
      case 315..<360, 0..<45: return .up
      case 135..<225: return .down
      default: return nil
      }
    }
  }

  @State var data: [Person] = Person.mock

  var body: some View {
    CardStack(
      direction: MyDirection.direction,
      data: data,
      onSwipe: { card, direction in
        print("Swiped \(card.name) to \(direction)")
      },
      content: { person, _, _ in
        CardView(person: person)
      }
    )
    .padding()
    .scaledToFit()
    .frame(alignment: .center)
    .navigationBarTitle("Custom direction", displayMode: .inline)
  }
}

struct CustomConfiguration: View {
  @State var data: [Person] = Person.mock

  var body: some View {
    CardStack(
      direction: LeftRight.direction,
      data: data,
      onSwipe: { card, direction in
        print("Swiped \(card.name) to \(direction)")
      },
      content: { person, _, _ in
        CardView(person: person)
      }
    )
    .environment(
      \.cardStackConfiguration,
      CardStackConfiguration(
        maxVisibleCards: 3,
        swipeThreshold: 0.1,
        cardOffset: 40,
        cardScale: 0.2,
        animation: .linear
      )
    )
    .padding()
    .scaledToFit()
    .frame(alignment: .center)
    .navigationBarTitle("Custom configuration", displayMode: .inline)
  }
}

struct KioskHomeView: View {
    
    @EnvironmentObject var viewModel: KioskViewModel
    @Environment(\.presentationMode) var presentationMode
    @State var isPresented = false
    @StateObject var bleController = BLEController()
    @State var data: [Person] = Person.mock

  var body: some View {
      
        CardStack(
          direction: LeftRight.direction,
          data: data,
          onSwipe: { card, direction in
            print("Swiped \(card.name) to \(direction)")
          },
          content: { person, direction, _ in
            CardViewWithThumbs(person: person, direction: direction)
          }
        )
        .padding()
        .scaledToFill()
        .frame(alignment: .center)
        .navigationBarTitle("Welcome to Kiosk", displayMode: .inline)
        .environmentObject(bleController)
      
  }
}

struct KioskHomeView_Previews: PreviewProvider {
  static var previews: some View {
      KioskHomeView()
  }
}
