import unittest
from machinetranslation import english_to_french, english_to_german

class TestTranslation(unittest.TestCase):
    def test_english_to_french(self):
        self.assertRaises(TypeError, english_to_french, None)
        self.assertEqual(english_to_french('Hello'), 'Bonjour')
        self.assertEqual(english_to_french('Goodbye'), 'Au revoir')
    def test_english_to_german(self):
        self.assertRaises(TypeError, english_to_german, None)
        self.assertEqual(english_to_german('Hello'), 'Hallo')
        self.assertEqual(english_to_german('Thanks'), 'Vielen Dank')

unittest.main()