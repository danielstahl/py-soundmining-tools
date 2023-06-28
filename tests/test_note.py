import unittest
from soundmining_tools import note


# Here is a list of note names. https://pages.mtu.edu/~suits/notefreqs.html
class TestMelody(unittest.TestCase):
    def test_natural(self):
        self.assertEqual(note.note_to_hertz("a4"), 440.00)

    def test_sharp(self):
        self.assertEqual(note.note_to_hertz("fiss3"), 185.00)

    def test_flat(self):
        self.assertEqual(note.note_to_hertz("dess3"), 138.59)


if __name__ == '__main__':
    unittest.main()
