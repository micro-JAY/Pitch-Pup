//
//  PitchProcessor.swift
//  PitchPup
//

import Foundation

struct PitchResult {
    let noteName: String
    let octave: Int
    let cents: Double
    let midiNote: Int
}

struct PitchProcessor {
    // Reference pitch: A4 = 440 Hz
    private let referenceFrequency: Double = 440.0
    private let referenceMidiNote: Int = 69 // A4

    private let noteNames = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]

    func process(frequency: Double) -> PitchResult {
        guard frequency > 0 else {
            return PitchResult(noteName: "--", octave: 4, cents: 0, midiNote: 0)
        }

        // Calculate the number of semitones from A4
        // n = 12 * log2(f / 440)
        let semitonesFromA4 = 12.0 * log2(frequency / referenceFrequency)

        // Round to nearest semitone to get the closest note
        let nearestSemitone = round(semitonesFromA4)

        // Calculate cents deviation (100 cents = 1 semitone)
        let cents = (semitonesFromA4 - nearestSemitone) * 100.0

        // Calculate MIDI note number
        let midiNote = referenceMidiNote + Int(nearestSemitone)

        // Calculate note name and octave
        // MIDI note 0 is C-1, MIDI note 60 is C4
        let noteIndex = ((midiNote % 12) + 12) % 12 // Handle negative modulo
        let noteName = noteNames[noteIndex]

        // Octave calculation: MIDI note 60 (C4) is octave 4
        // octave = floor(midiNote / 12) - 1
        let octave = (midiNote / 12) - 1

        return PitchResult(
            noteName: noteName,
            octave: octave,
            cents: cents,
            midiNote: midiNote
        )
    }

    /// Returns the frequency for a given MIDI note number
    func frequency(forMidiNote midiNote: Int) -> Double {
        return referenceFrequency * pow(2.0, Double(midiNote - referenceMidiNote) / 12.0)
    }

    /// Returns nearby notes for the note ladder display
    func nearbyNotes(forMidiNote midiNote: Int, range: Int = 2) -> [(noteName: String, midiNote: Int, frequency: Double)] {
        var notes: [(String, Int, Double)] = []

        for offset in -range...range {
            let note = midiNote + offset
            let noteIndex = ((note % 12) + 12) % 12
            let noteName = noteNames[noteIndex]
            let freq = frequency(forMidiNote: note)
            notes.append((noteName, note, freq))
        }

        return notes
    }
}
