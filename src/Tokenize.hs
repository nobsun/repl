-- # Tokenize
-- 入力をEOLで分割
{-# LANGUAGE GHC2024 #-}
{-# LANGUAGE ImplicitParams #-}
{-# LANGUAGE ImportQualifiedPost #-}
{-# LANGUAGE LexicalNegation #-}
{-# LANGUAGE LambdaCase, MultiWayIf #-}
{-# LANGUAGE NPlusKPatterns #-}
{-# LANGUAGE DataKinds, PolyKinds, NoStarIsType, TypeFamilyDependencies #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE OverloadedRecordDot, NoFieldSelectors, DuplicateRecordFields #-}

module Tokenize
    ( entokenize
    , detokenize
    ) where

import Prelude hiding ( interact )
import Control.Concurrent
import Control.Concurrent.Chan
import Control.Exception
import Data.Bool
import Data.Char
import Data.List
import Data.List.Split
import Data.Maybe
import System.IO hiding (interact)
import System.IO.Unsafe
import System.Console.Haskeline

type Prompt        = String
type Quit          = String
type HistoryFile   = Maybe FilePath

entokenize :: (?prompt :: String, ?quit :: String, ?eol :: String)
           => IO [String]
entokenize = loop id where
    loop :: (String -> String) -> IO [String]
    loop acc = unsafeInterleaveIO $ do
        { mline <- runInputT defaultSettings (getInputLine ?prompt)
        ; case mline of
            Nothing   -> return []
            Just line
                | ?quit == line'        -> return []
                | otherwise      -> case splitOn ?eol line' of
                    [_]              -> loop (acc . (line' ++) . (' ':))
                    line'' : _       -> (acc (trim line'') :) <$> loop id
                    _                -> error "entokenize: impossible"
                where
                    line' = trim line
        }

trim :: String -> String
trim = dropWhileEnd isSpace . dropWhile isSpace

detokenize :: [String] -> IO ()
detokenize = putStr . unlines
