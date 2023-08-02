from dataclasses import dataclass
from typing import Self
from soundmining_tools.sequencer import SequenceNote


@dataclass
class UiTrack:
    track_name: str
    notes: list[SequenceNote]


@dataclass
class UiPiece:
    tracks: list[UiTrack]

    def get_duration(self) -> float:
        duration = 0
        for track in self.tracks:
            for note in track.notes:
                duration = max(duration, note.start + note.duration)
        return duration


class UiPieceBuilder:
    def __init__(self) -> None:
        self.tracks = {}

    def add_note(self, note: SequenceNote) -> Self:
        track_notes: list[SequenceNote] = self.tracks.get(note.track, [])
        track_notes.append(note)
        self.tracks[note.track] = track_notes
        return self

    def add_notes(self, notes: list[SequenceNote]) -> Self:
        for sequence_note in notes:
            self.add_note(sequence_note)
        return self

    def build(self) -> UiPiece:
        tracks = []
        for track_name, notes in self.tracks.items():
            tracks.append(UiTrack(track_name=track_name, notes=notes))
        return UiPiece(tracks=tracks)

