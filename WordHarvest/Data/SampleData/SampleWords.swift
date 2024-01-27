//
//  SampleWords.swift
//  WordHarvest
//
//  Created by Amari DeVaughn on 1/24/24.
//

import Foundation

let imagination = SavedWord(word: "Imagination", phonetic: "/ɪˌmædʒəˈneɪʃən/", definitions: ["The image-making power of the mind; the act of mentally creating or reproducing an object not previously perceived; the ability to create such images.", "Particularly, construction of false images; fantasizing.", "Creativity; resourcefulness."], audio: URL(string:"https://api.dictionaryapi.dev/media/pronunciations/en/imagination-us.mp3"), example: "His imagination makes him a valuable team member.", synonyms: [
    "creativity",
    "fancy",
    "imaginativeness",
    "invention"
    ], book: "Alan Watts")


let dream = SavedWord(word: "Dream", phonetic: "/dɹiːm/", definitions: ["Imaginary events seen in the mind while sleeping.", "A hope or wish.", "A visionary scheme; a wild conceit; an idle fancy."], audio: URL(string:"https://api.dictionaryapi.dev/media/pronunciations/en/dream-us.mp3" ), example: "a dream of bliss", synonyms: [
    "sweven",
    "vision",
], book: "Alan Watts")
