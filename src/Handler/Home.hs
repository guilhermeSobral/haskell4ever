{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Home where

import Import
--import Network.HTTP.Types.Status
import Database.Persist.Postgresql

getHomeR :: Handler Html
getHomeR = do
    defaultLayout $ do
        toWidgetHead [julios|
            function ola(){
                alert("oi");
            }
        |]
        toWidgetHead [cassius|
            h1
               color : blue;
        |]
        [whamlet|
            <h1>
               OI MUNDO! 
            
            <button>
               OI!
        |]          
    