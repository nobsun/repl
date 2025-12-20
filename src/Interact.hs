-- # Interact2
-- Haskeline を使用して簡単な行編集が可能にする
{-# LANGUAGE GHC2024 #-}
{-# LANGUAGE ImplicitParams #-}
{-# LANGUAGE ImportQualifiedPost #-}
{-# LANGUAGE LexicalNegation #-}
{-# LANGUAGE LambdaCase, MultiWayIf #-}
{-# LANGUAGE NPlusKPatterns #-}
{-# LANGUAGE DataKinds, PolyKinds, NoStarIsType, TypeFamilyDependencies #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE OverloadedRecordDot, NoFieldSelectors, DuplicateRecordFields #-}

module Interact
    ( interact'
    ) where

import System.IO.Unsafe
import System.Console.Haskeline

interact' :: ( ?history :: Maybe FilePath
             , ?prompt  :: String )
          => (String -> String)
          -> IO ()
interact' f =  putStr . f . unlines =<< readIter

readIter :: ( ?history :: Maybe FilePath
            , ?prompt  :: String )
         => IO [String]
readIter = loop
    where
        loop :: IO [String]
        loop = unsafeInterleaveIO
             $ maybe (return []) ((<$> loop) . (:)) 
               =<< runInputT (defaultSettings { historyFile = ?history }) 
                             (getInputLine ?prompt)

