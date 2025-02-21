//
//  SponsorsView.swift
//  SwiftLeeds
//
//  Created by Muralidharan Kathiresan on 25/06/23.
//

import SwiftUI

struct SponsorsView: View {
    @Environment(\.openURL) var openURL
    @StateObject private var viewModel = SponsorsViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.sections) { section in
                switch section.type {
                case .platinum:
                    Section(header: sectionHeader(for: section.type)) {
                        ForEach(section.sponsors) { sponsor in
                            contentTile(for: sponsor)
                                .listRowBackground(Color.clear)
                                .listRowInsets(EdgeInsets())
                        }
                    }
                case .gold:
                    Section(header: sectionHeader(for: section.type)) {
                        ForEach(section.sponsors) { sponsor in
                            contentTile(for: sponsor)
                                .listRowBackground(Color.clear)
                                .listRowInsets(EdgeInsets())
                        }
                    }
                case .silver:
                    Section(header: sectionHeader(for: section.type)) {
                        grid(for: section.sponsors)
                            .listRowBackground(Color.clear)
                            .listRowInsets(EdgeInsets())
                    }
                }
            }
        }
        .task { try? await viewModel.loadSponsors() }
    }
}

private extension SponsorsView {
    func sectionHeader(for sponsorLevel: SponsorLevel) -> some View {
        Text("\(sponsorLevel.rawValue.capitalized) Sponsors")
            .font(.callout.weight(.semibold))
            .foregroundColor(.secondary)
            .frame(maxWidth:.infinity, alignment: .leading)
            .accessibilityAddTraits(.isHeader)
            .textCase(nil)
    }
    
    func contentTile(for sponsor: Sponsor) -> some View {
        ContentTileView(
            accessibilityLabel: "Sponsor",
            title: sponsor.name,
            subTitle: nil,
            imageURL: URL(string: sponsor.image),
            isImagePadded: true,
            imageBackgroundColor: .white,
            imageContentMode: .fit,
            onTap: { openSponsor(sponsor: sponsor) }
        )
        .frame(maxWidth: .infinity, alignment: .center)
    }
    
    func openSponsor(sponsor: Sponsor) {
        guard let link = URL(string: sponsor.url) else { return }
        openURL(link)
    }
    
    func grid(for sponsors: [Sponsor]) -> some View {
        let columns = [
            GridItem(.flexible()), GridItem(.flexible())
        ]
        return LazyVGrid(
            columns: columns,
            alignment: .leading,
            spacing: Padding.cellGap,
            pinnedViews: []) {
                ForEach(sponsors, id: \.self) { sponsor in
                    contentTile(for: sponsor)
                }
            }.foregroundColor(.clear)
    }
}

struct SponsorsView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftLeedsContainer {
            ScrollView {
                SponsorsView().padding()
            }
        }
    }
}
