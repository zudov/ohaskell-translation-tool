ohaskell-translation-tool
=========================

# Purpose

I use [LanguageTool](https://languagetool.org/) for proof-reading and it often
finds real mistakes, but they are usually buried under the false-triggered
spelling mistakes in the code blocks.

That script allows to get rid of most of the false-triggered mistakes by cleaning
the file before feeding it into LanguageTool (or some other proof-reading app)

# What it does

The most important things that it does:

- wipe code blocks (the taken space is preserved)
- replace inline code with noun "input"/"output" depending on whether the first 
  letter is vowel (to get rid of a/an mistakes)
- wipes the table in the beginning (the taken space is preserved)

When removing, space is preserved, so when LanguageTool tells that the problem
is on the line 20 it is on on the line 20 in the original file (or at least 
it's supposed to be there)


# Usage
I use it this way:

```bash
alias languagetool="java -jar /some/path/LanguageTool-2.6/languagetool-commandline.jar"
ohaskell-translation-tool < own-exceptions.md |  languagetool -l en-GB -d EN_QUOTES
```

# Ignore.txt
I've also put a file ignore.txt, it contains words that are considered to be a
spelling mistake (e.g. stdin, stdout, Hackage), you might want to append it to
your `org/languagetool/resource/en/hunspell/ignore.txt`, so that LanguageTool
doesn't whine about them.

# Example
Suppose we have such text:

	----
	title: Great function
	prevChapter: /better/function.html
	nextChapter: /worse/function.html
	----

	# Header

	That is a awesome funtion `foldSum`:

	```haskell
	foldSum :: [Int] -> Int
	foldSum = foldl (+) 0
	```

Running LanguageTool on it would return a whole bunch of mistakes.

```bash
zudov@rhea ~/prog/haskell/ohaskell-translation-tool $ languagetool -l en-GB -d EN_QUOTES < example.md
Expected text language: English (GB)
Working on STDIN...
1.) Line 3, column 1, Rule ID: MORFOLOGIK_RULE_EN_GB
Message: Possible spelling mistake found
---- title: Great function prevChapter: /better/function.html nextChapter: /worse/f...
                           ^^^^^^^^^^^                                             
2.) Line 4, column 1, Rule ID: MORFOLOGIK_RULE_EN_GB
Message: Possible spelling mistake found
... function prevChapter: /better/function.html nextChapter: /worse/function.html ----  
                                                ^^^^^^^^^^^                             
3.) Line 8, column 9, Rule ID: EN_A_VS_AN
Message: Use 'an' instead of 'a' if the following word starts with a vowel sound, e.g. 'an article', 'an hour'
Suggestion: an
# Header That is a awesome funtion `foldSum`:  
                 ^                             
4.) Line 8, column 19, Rule ID: MORFOLOGIK_RULE_EN_GB
Message: Possible spelling mistake found
Suggestion: function
# Header That is a awesome funtion `foldSum`:  
                           ^^^^^^^             
5.) Line 8, column 28, Rule ID: MORFOLOGIK_RULE_EN_GB
Message: Possible spelling mistake found
# Header That is a awesome funtion `foldSum`:  
                                    ^^^^^^^    
6.) Line 13, column 4, Rule ID: MORFOLOGIK_RULE_EN_GB
Message: Possible spelling mistake found
Suggestion: Haskell
```haskell foldSum :: [Int] -> Int foldSum = foldl (+) ...
   ^^^^^^^                                             
7.) Line 14, column 1, Rule ID: MORFOLOGIK_RULE_EN_GB
Message: Possible spelling mistake found
```haskell foldSum :: [Int] -> Int foldSum = foldl (+) 0 ``` 
           ^^^^^^^                                           
8.) Line 14, column 13, Rule ID: MORFOLOGIK_RULE_EN_GB
Message: Possible spelling mistake found
Suggestion: ITT; Inc; Ind; NT; TNT; Ant; Dint; Hint; In; Ink; Inn; Ins; Inst; Into; It; Lint; Mint; Pint; Tint
```haskell foldSum :: [Int] -> Int foldSum = foldl (+) 0 ``` 
                       ^^^                                   
9.) Line 14, column 21, Rule ID: MORFOLOGIK_RULE_EN_GB
Message: Possible spelling mistake found
Suggestion: ITT; Inc; Ind; NT; TNT; Ant; Dint; Hint; In; Ink; Inn; Ins; Inst; Into; It; Lint; Mint; Pint; Tint
```haskell foldSum :: [Int] -> Int foldSum = foldl (+) 0 ``` 
                               ^^^                           
10.) Line 15, column 1, Rule ID: MORFOLOGIK_RULE_EN_GB
Message: Possible spelling mistake found
```haskell foldSum :: [Int] -> Int foldSum = foldl (+) 0 ``` 
                                   ^^^^^^^                   
11.) Line 15, column 11, Rule ID: MORFOLOGIK_RULE_EN_GB
Message: Possible spelling mistake found
Suggestion: fold; folds; foll; fold l
...```haskell foldSum :: [Int] -> Int foldSum = foldl (+) 0 ``` 
                                                ^^^^^           
Time: 524ms for 3 sentences (5.7 sentences/sec)
```

Processing it with ohaskell-translation-tool would return such output:

```bash
zudov@rhea ~/prog/haskell/ohaskell-translation-tool $ ohaskell-translation-tool < example.md 
\
\
\
\
\

# Header

That is a awesome funtion `input`:

\
\
\
\
```

And running LanguageTool on that would return something more useful:

```bash
zudov@rhea ~/prog/haskell/ohaskell-translation-tool $ ohaskell-translation-tool < example.md |  languagetool -l en-GB -d EN_QUOTES                        
Expected text language: English (GB)
Working on STDIN...
1.) Line 9, column 9, Rule ID: EN_A_VS_AN
Message: Use 'an' instead of 'a' if the following word starts with a vowel sound, e.g. 'an article', 'an hour'
Suggestion: an
That is a awesome funtion `input`:  
        ^                           
2.) Line 9, column 19, Rule ID: MORFOLOGIK_RULE_EN_GB
Message: Possible spelling mistake found
Suggestion: function
That is a awesome funtion `input`:  
                  ^^^^^^^           
Time: 402ms for 4 sentences (10.0 sentences/sec)
```

However, not all mistakes can be found.
