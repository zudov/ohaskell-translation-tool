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
