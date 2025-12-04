-- # Interact2
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

module Interact2
    ( interact'
    ) where

import System.IO.Unsafe
import System.Console.Haskeline


interact' :: ( ?history :: Maybe FilePath
             , ?prompt  :: String )
          => (String -> String)
          -> IO ()
interact' f =  putStr . f . unlines =<< loop where
    loop :: IO [String]
    loop = unsafeInterleaveIO 
         $ maybe (return []) ((<$> loop) . (:)) 
           =<< runInputT (defaultSettings { historyFile = ?history }) 
                         (getInputLine ?prompt)

