//
//  ContentView.swift
//  MusicKit Introduction
//
//  Created by Ayush Singh on 15/06/22.
//

import SwiftUI
import MusicKit

struct Item: Identifiable, Hashable {
    var id = UUID()
    let name: String
    let artist: String
    let imageUrl: URL?
}

struct ContentView: View {
    @State var songs = [Item]()
    
    var body: some View {
        
        
        NavigationView {
            List(songs) { song in
                NavigationLink(destination: MusicView(name: "\(song.name)", artist: song.artist, imageUrl: song.imageUrl)) {
                    HStack {
                        AsyncImage(url: song.imageUrl)
                            .frame(width: 75, height: 75, alignment: .center)
                        VStack(alignment: .leading) {
                            Text(song.name)
                                .font(.title3)
                            Text(song.artist)
                                .font(.footnote)
                        }
                        .padding()
                    }
                    
                    
                    
                }
            }
        }

        .onAppear() {
            fetchMusic()
        }
        
        
    }
    
    private let request: MusicCatalogSearchRequest = {
        var request = MusicCatalogSearchRequest(term: "close", types: [Song.self])
        
        request.limit = 25
        return request
        
    }()
    
    private func fetchMusic() {
        //Request Permission
        Task {
            let status = await MusicAuthorization.request()
            switch status {
            case .authorized :
                //Get Response
                do {
                    let result = try await request.response()
                    self.songs = result.songs.compactMap({
                        return .init(name: $0.title, artist: $0.artistName, imageUrl: $0.artwork?.url(width: 75, height: 75))
                        
                    })
                    print(songs[0])
                } catch  {
                    print(error)
                }
                //Assign Songs
            default :
                return
            }
            
        }
        
        
        
    }
}

struct MusicView: View {
    
    let name : String
    let artist: String
    let imageUrl: URL?

    var body: some View {
        AsyncImage(url: imageUrl)
            .frame(width: 250, height: 250, alignment: .center)
            .scaledToFill()

        Text("\(name)")
            .font(.title)
        Text("\(artist)")
            .font(.title)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
