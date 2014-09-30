import Text.Pandoc
import Text.Pandoc.Walk
import Data.Char (toLower)

main :: IO ()
main = interact (writeMarkdown writer . cleanup . readMarkdown def)
    where writer = def {writerSetextHeaders = False, writerWrapText = False}

cleanup :: Pandoc -> Pandoc
cleanup = walk blocks . walk inlines

-- The vowel stuff is done in order to get rid of EN_A_VS_AN rule
inlines :: Inline -> Inline
inlines (Code attr c) = Code attr $ if isVowel $ head c then "output" else "input"
inlines x = x

isVowel :: Char -> Bool
isVowel c = elem (toLower c) "aeiou"

blocks :: Block -> Block
blocks (CodeBlock ("",[],[]) code) = Para $ replicate (length $ lines code) LineBreak
blocks (CodeBlock _ code) = Para $ replicate (2 + length (lines code)) LineBreak
blocks (Table _ _ _ _ rows) = Para $ replicate (2 + length rows) LineBreak
-- Replace bullet lists with ordered, otherwise languageTool whines about whitespaces. 
blocks (BulletList items) = OrderedList (0,Decimal,Period) items 
blocks x = x
