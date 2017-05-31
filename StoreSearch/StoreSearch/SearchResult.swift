//
//  SearchResult.swift
//  StoreSearch
//
//  Created by Norman Lopez on 5/23/17.
//  Copyright © 2017 Norman Lopez. All rights reserved.
//

import Foundation

private let displayNamesForKind = [
    "album": NSLocalizedString("Album", comment: "Localized kind: Album"),
    "audiobook": NSLocalizedString("Audio Book", comment: "Localized kind: Audio Book"),
    "book": NSLocalizedString("Book", comment: "Localized kind: Book"),
    "ebook": NSLocalizedString("E-Book",comment: "Localized kind: E-Book"),
    "feature-movie": NSLocalizedString("Movie",comment: "Localized kind: Feature Movie"),
    "music-video": NSLocalizedString("Music Video",comment: "Localized kind: Music Video"),
    "podcast": NSLocalizedString("Podcast",comment: "Localized kind: Podcast"),
    "software": NSLocalizedString("App",comment: "Localized kind: Software"),
    "song": NSLocalizedString("Song",comment: "Localized kind: Song"),
    "tv-episode": NSLocalizedString("TV Episode",comment: "Localized kind: TV Episode"),
]

class SearchResult {
    var name = ""
    var artistName = ""
    var artworkSmallURL = ""
    var artworkLargeURL = ""
    var storeURL = ""
    var kind = ""
    var currency = ""
    var price = 0.0
    var genre = ""
    
    func kindForDisplay() -> String {
        return displayNamesForKind[kind] ?? kind //(??) nil coalescing operator !!!
    }
}
